CREATE OR REPLACE FUNCTION trg_employment_no_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM employment e
        JOIN position p1 ON p1.position_id = e.position_id
        JOIN department d1 ON d1.department_id = p1.department_id
        JOIN position p2 ON p2.position_id = NEW.position_id
        JOIN department d2 ON d2.department_id = p2.department_id
        WHERE e.worker_id = NEW.worker_id
          AND e.employment_id <> NEW.employment_id
          AND d1.company_id = d2.company_id
          AND (
              NEW.start_date <= COALESCE(e.end_date, '9999-12-31')
              AND e.start_date <= COALESCE(NEW.end_date, '9999-12-31')
          )
    ) THEN
        RAISE EXCEPTION 'Pracownik ma już zatrudnienie w tej firmie w tym okresie.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_employment_no_overlap
AFTER INSERT OR UPDATE ON employment
FOR EACH ROW
EXECUTE FUNCTION trg_employment_no_overlap();


CREATE OR REPLACE FUNCTION trg_check_worktime_limit()
RETURNS TRIGGER AS $$
DECLARE
    max_minutes_per_day INT := 1440;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM worktime wt
        INNER JOIN (
            SELECT DISTINCT employment_id, date
            FROM (
                SELECT NEW.employment_id AS employment_id, NEW.date AS date
                UNION ALL
                SELECT OLD.employment_id AS employment_id, OLD.date AS date
            ) AS affected_rows
        ) AS affected_rows
        ON wt.employment_id = affected_rows.employment_id
        AND wt.date = affected_rows.date
        GROUP BY wt.employment_id, wt.date
        HAVING SUM(EXTRACT(HOUR FROM wt.time) * 60 + EXTRACT(MINUTE FROM wt.time)) > max_minutes_per_day
    ) THEN
        RAISE EXCEPTION 'Pracownik ma za dużo godzin.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_worktime_limit
AFTER INSERT OR UPDATE ON worktime
FOR EACH ROW
EXECUTE FUNCTION trg_check_worktime_limit();