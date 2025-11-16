DECLARE @CurrentMonthStart DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
DECLARE @NextMonthStart DATE = DATEADD(MONTH, 1, @CurrentMonthStart);

SELECT
w.WorkerID,
w.FirstName,
w.LastName,
e.EmploymentID,
    
SUM(
    (DATEPART(HOUR, wt.Time) * 60) + DATEPART(MINUTE, wt.Time)
) AS TotalMinutes,
    
CAST(
    (SUM( (DATEPART(HOUR, wt.Time) * 60) + DATEPART(MINUTE, wt.Time) ) / 60) 
    AS VARCHAR(10)
) + 'h ' +
CAST(
    (SUM( (DATEPART(HOUR, wt.Time) * 60) + DATEPART(MINUTE, wt.Time) ) % 60) 
    AS VARCHAR(2)
) + 'm' AS FormattedWorkTime

FROM Worktime AS wt
JOIN Employment AS e ON wt.EmploymentID = e.EmploymentID
JOIN Worker AS w ON e.WorkerID = w.WorkerID
WHERE
wt.Date >= @CurrentMonthStart 
AND wt.Date < @NextMonthStart

GROUP BY
w.WorkerID,
w.FirstName,
w.LastName,
e.EmploymentID

ORDER BY
w.LastName,
w.FirstName,
e.EmploymentID;