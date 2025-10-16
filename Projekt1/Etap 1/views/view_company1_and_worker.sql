-- General views for Company 1
USE Projekt1;

GO
CREATE VIEW v_Company1
AS
SELECT * FROM Company
WHERE CompanyID = 1
WITH CHECK OPTION;

GO
CREATE VIEW v_Department_Company1
AS
SELECT * FROM Department d
WHERE d.CompanyID = 1
WITH CHECK OPTION;

GO
CREATE VIEW v_Position_Company1
AS
SELECT * FROM Position p
WHERE p.DepartmentID IN (SELECT DepartmentID FROM v_Department_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_Employment_Company1
AS
SELECT * FROM Employment e
WHERE e.PositionID IN (SELECT PositionID FROM v_Position_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_Worktime_Company1
AS
SELECT * FROM Worktime w
WHERE w.EmploymentID IN (SELECT EmploymentID FROM v_Employment_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_Absence_Company1
AS
SELECT * FROM Absence a
WHERE a.EmploymentID IN (SELECT EmploymentID FROM v_Employment_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_HolidayRequest_Company1
AS
SELECT * FROM HolidayRequest hr
WHERE hr.EmploymentID IN (SELECT EmploymentID FROM v_Employment_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_ResponsibilityEmployment_Company1
AS
SELECT * FROM ResponsibilityEmployment re
WHERE re.EmploymentID IN (SELECT EmploymentID FROM v_Employment_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_ResponsibilityPosition_Company1
AS
SELECT * FROM ResponsibilityPosition rp
WHERE rp.PositionID IN (SELECT PositionID FROM v_Position_Company1)
WITH CHECK OPTION;

GO
CREATE VIEW v_Facture_Company1
AS
SELECT * FROM Facture f
WHERE f.CompanyID = 1
WITH CHECK OPTION;


-- Big view!

GO
CREATE VIEW v_Total_Working_Time_Company1
AS
WITH LastMonthEmployment AS (
    SELECT 
        e.EmploymentID,
        w.FirstName,
        w.LastName,
        w.Pesel as 'Pesel',
        e.StartDate,
        e.EndDate
    FROM v_Employment_Company1 e
    JOIN Worker w ON e.WorkerID = w.WorkerID
    WHERE
        YEAR(e.StartDate) <= YEAR(DATEADD(MONTH, -1, GETDATE())) AND
        MONTH(e.StartDate) <= MONTH(DATEADD(MONTH, -1, GETDATE())) AND
        (e.EndDate >= EOMONTH(GETDATE(), -1) OR e.EndDate IS NULL)
),
WorktimeSummary AS (
    SELECT 
        e.EmploymentID,
        SUM(DATEDIFF(MINUTE, '00:00:00', wt.Time) / 60.0) AS TotalWorkHours
    FROM v_Worktime_Company1 wt
    JOIN v_Employment_Company1 e ON wt.EmploymentID = e.EmploymentID
    WHERE 
        wt.Date >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) AND
        wt.Date < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND
    GROUP BY e.EmploymentID
),
AbsenceSummary AS (
    SELECT 
        e.EmploymentID,
        SUM(DATEDIFF(DAY, a.StartDate, a.EndDate) + 1) * 8 AS TotalAbsenceHours
    FROM v_Absence_Company1 a
    JOIN v_Employment_Company1 e ON a.EmploymentID = e.EmploymentID
    WHERE 
        a.StartDate >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) AND
        a.EndDate < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND
    GROUP BY e.EmploymentID
)
SELECT
    lme.EmploymentID,
    lme.FirstName,
    lme.LastName,
    lme.Pesel,
    ws.TotalWorkHours,
    abss.TotalAbsenceHours,
    ws.TotalWorkHours + abss.TotalAbsenceHours AS 'Total hours'
FROM LastMonthEmployment lme
JOIN WorktimeSummary ws ON ws.EmploymentID = lme.EmploymentID
JOIN AbsenceSummary abss ON abss.EmploymentID = lme.EmploymentID;
-- views for department managers in company 1

GO
CREATE VIEW v_Department1_Manager
AS
SELECT * FROM Department
WHERE DepartmentID = 1
WITH CHECK OPTION;

GO
CREATE VIEW v_Worktime_Departament1_Manager
AS
SELECT 
    w.*
FROM Worktime w
WHERE w.EmploymentID IN (
    SELECT e.EmploymentID
    FROM Employment e
    JOIN Position p ON e.PositionID = p.PositionID
    WHERE p.DepartmentID = 1
)
WITH CHECK OPTION;

GO
CREATE VIEW v_Absence_Departament1_Manager
AS
SELECT 
    a.*
FROM Absence a
WHERE a.EmploymentID IN (
    SELECT e.EmploymentID
    FROM Employment e
    JOIN Position p ON e.PositionID = p.PositionID
    WHERE p.DepartmentID = 1
)
WITH CHECK OPTION;

GO
CREATE VIEW v_HolidayRequest_Departament1_Manager
AS
SELECT
    hr.*
FROM HolidayRequest hr
WHERE hr.EmploymentID IN (
    SELECT e.EmploymentID
    FROM Employment e
    JOIN Position p ON e.PositionID = p.PositionID
    WHERE p.DepartmentID = 1
)
WITH CHECK OPTION;

GO
CREATE VIEW v_Worker_Departament1_Manager
AS
SELECT
    w.*
FROM Worker w
WHERE w.WorkerID IN (
    SELECT e.WorkerID
    FROM Employment e
    JOIN Position p ON e.PositionID = p.PositionID
    WHERE p.DepartmentID = 1
)
WITH CHECK OPTION;

-- views for worker

GO
CREATE VIEW v_Worker_Self
AS
SELECT * FROM Worker
WHERE Login = SUSER_NAME()WITH CHECK OPTION;

GO
CREATE VIEW v_Employment_Self
AS
SELECT * FROM Employment
WHERE WorkerID IN (
    SELECT WorkerID FROM Worker
    WHERE Login = SUSER_NAME()
)
AND StartDate <= GETDATE() AND (EndDate IS NULL OR EndDate >= GETDATE())
WITH CHECK OPTION;

GO
CREATE VIEW v_Absence_Self
AS
SELECT * FROM ABSENCE
WHERE EmploymentID IN(
    SELECT EmploymentID FROM v_Employment_Self
)
WITH CHECK OPTION;

GO
CREATE VIEW v_Worktime_Self
AS
SELECT * FROM Worktime
WHERE EmploymentID IN(
    SELECT EmploymentID FROM v_Employment_Self
)
WITH CHECK OPTION;

GO
CREATE VIEW v_HolidayRequest_Self
AS
SELECT * FROM HolidayRequest
WHERE EmploymentID IN(
    SELECT EmploymentID FROM v_Employment_Self
)
WITH CHECK OPTION;

