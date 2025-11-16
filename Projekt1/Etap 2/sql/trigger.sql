CREATE TRIGGER trg_CheckWorktimeLimit
ON Worktime
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxMinutesPerDay INT = 1440;

    IF EXISTS (
        SELECT 1
        FROM Worktime AS wt
        
        INNER JOIN (
            SELECT DISTINCT EmploymentID, Date
            FROM inserted
        ) AS affected_rows
        ON wt.EmploymentID = affected_rows.EmploymentID
        AND wt.Date = affected_rows.Date
         
        GROUP BY
            wt.EmploymentID,
            wt.Date

        HAVING
            SUM(
                (DATEPART(HOUR, wt.Time) * 60) + DATEPART(MINUTE, wt.Time)
            ) > @MaxMinutesPerDay
    )
    BEGIN
        RAISERROR('Pracownik ma za dużo godzin.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO