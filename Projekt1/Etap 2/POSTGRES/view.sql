-- General views for Company 1

CREATE OR REPLACE VIEW v_company1 AS
SELECT * 
FROM company
WHERE company_id = 1;

CREATE OR REPLACE VIEW v_department_company1 AS
SELECT * 
FROM department d
WHERE d.company_id = 1;

CREATE OR REPLACE VIEW v_position_company1 AS
SELECT * 
FROM position p
WHERE p.department_id IN (SELECT department_id FROM v_department_company1);

CREATE OR REPLACE VIEW v_employment_company1 AS
SELECT * 
FROM employment e
WHERE e.position_id IN (SELECT position_id FROM v_position_company1);

CREATE OR REPLACE VIEW v_worktime_company1 AS
SELECT * 
FROM worktime w
WHERE w.employment_id IN (SELECT employment_id FROM v_employment_company1);

CREATE OR REPLACE VIEW v_absence_company1 AS
SELECT * 
FROM absence a
WHERE a.employment_id IN (SELECT employment_id FROM v_employment_company1);

CREATE OR REPLACE VIEW v_holiday_request_company1 AS
SELECT * 
FROM holiday_request hr
WHERE hr.employment_id IN (SELECT employment_id FROM v_employment_company1);

CREATE OR REPLACE VIEW v_responsibility_employment_company1 AS
SELECT * 
FROM responsibility_employment re
WHERE re.employment_id IN (SELECT employment_id FROM v_employment_company1);

CREATE OR REPLACE VIEW v_responsibility_position_company1 AS
SELECT * 
FROM responsibility_position rp
WHERE rp.position_id IN (SELECT position_id FROM v_position_company1);

CREATE OR REPLACE VIEW v_facture_company1 AS
SELECT * 
FROM facture f
WHERE f.company_id = 1;

-- big view

CREATE OR REPLACE VIEW v_total_working_time_company1 AS
WITH last_month_employment AS (
    SELECT 
        e.employment_id,
        w.first_name,
        w.last_name,
        w.pesel,
        e.start_date,
        e.end_date
    FROM v_employment_company1 e
    JOIN worker w ON e.worker_id = w.worker_id
    WHERE
        EXTRACT(YEAR FROM e.start_date) <= EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month') AND
        EXTRACT(MONTH FROM e.start_date) <= EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month') AND
        (e.end_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day' OR e.end_date IS NULL)
),
worktime_summary AS (
    SELECT 
        e.employment_id,
        SUM(EXTRACT(EPOCH FROM wt.time) / 3600.0) AS total_work_hours
    FROM v_worktime_company1 wt
    JOIN v_employment_company1 e ON wt.employment_id = e.employment_id
    WHERE 
        wt.date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month') AND
        wt.date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY e.employment_id
),
absence_summary AS (
    SELECT 
        e.employment_id,
        SUM((a.end_date - a.start_date + 1) * 8) AS total_absence_hours
    FROM v_absence_company1 a
    JOIN v_employment_company1 e ON a.employment_id = e.employment_id
    WHERE 
        a.start_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month') AND
        a.end_date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY e.employment_id
)
SELECT
    lme.employment_id,
    lme.first_name,
    lme.last_name,
    lme.pesel,
    COALESCE(ws.total_work_hours, 0) AS total_work_hours,
    COALESCE(abss.total_absence_hours, 0) AS total_absence_hours,
    COALESCE(ws.total_work_hours, 0) + COALESCE(abss.total_absence_hours, 0) AS total_hours
FROM last_month_employment lme
LEFT JOIN worktime_summary ws ON ws.employment_id = lme.employment_id
LEFT JOIN absence_summary abss ON abss.employment_id = lme.employment_id;