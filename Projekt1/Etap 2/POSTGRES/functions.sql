CREATE OR REPLACE FUNCTION fn_get_total_years_worked(worker_id_param INT, company_id_param INT)
RETURNS INT AS $$
DECLARE
    total_days NUMERIC(10, 2) := 0;
BEGIN
    SELECT COALESCE(SUM((COALESCE(e.end_date, CURRENT_DATE) - e.start_date) + 1), 0)
    INTO total_days
    FROM employment e
    JOIN position p ON e.position_id = p.position_id
    JOIN department d ON p.department_id = d.department_id
    WHERE e.worker_id = worker_id_param
      AND d.company_id = company_id_param;

    RETURN FLOOR(total_days / 365.25)::INT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_get_annual_absence_days(worker_id_param INT, company_id_param INT)
RETURNS INT AS $$
DECLARE
    total_years INT;
    base_leave INT := 26;
    bonus_leave INT;
BEGIN
    total_years := fn_get_total_years_worked(worker_id_param, company_id_param);
    bonus_leave := FLOOR(total_years / 2);

    RETURN base_leave + bonus_leave;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_remaining_leave_days(worker_id_param INT, company_id_param INT)
RETURNS INT AS $$
DECLARE
    total_entitlement INT;
    leave_taken INT := 0;
    current_year_start DATE := make_date(EXTRACT(YEAR FROM CURRENT_DATE)::INT, 1, 1);
    current_year_end DATE := make_date(EXTRACT(YEAR FROM CURRENT_DATE)::INT, 12, 31);
    vacation_type_id INT := 2;
BEGIN
    total_entitlement := fn_get_annual_absence_days(worker_id_param, company_id_param);

    SELECT COALESCE(
        SUM(
            (LEAST(a.end_date, current_year_end) - GREATEST(a.start_date, current_year_start) + 1)
        ), 0)
    INTO leave_taken
    FROM absence a
    JOIN employment e ON a.employment_id = e.employment_id
    JOIN position p ON e.position_id = p.position_id
    JOIN department d ON p.department_id = d.department_id
    WHERE e.worker_id = worker_id_param
      AND d.company_id = company_id_param
      AND a.absence_type_id = vacation_type_id
      AND a.start_date <= current_year_end
      AND a.end_date >= current_year_start;

    RETURN total_entitlement - leave_taken;
END;
$$ LANGUAGE plpgsql;