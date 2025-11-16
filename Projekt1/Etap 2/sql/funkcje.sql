CREATE FUNCTION fn_GetTotalYearsWorked (@WorkerID INT, @CompanyID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalDays DECIMAL(10, 2);

    SELECT @TotalDays = SUM(DATEDIFF(DAY, e.StartDate, ISNULL(e.EndDate, GETDATE())) + 1)
    FROM Employment AS e
    JOIN Position AS p ON e.PositionID = p.PositionID
    JOIN Department AS d ON p.DepartmentID = d.DepartmentID
    WHERE e.WorkerID = @WorkerID
      AND d.CompanyID = @CompanyID;

    IF @TotalDays IS NULL
        RETURN 0;

    RETURN FLOOR(@TotalDays / 365.25);
END;
GO



Create FUNCTION fn_GetAnnualAbsenceDays (@WorkerID INT, @CompanyID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalYears INT;
    DECLARE @BaseLeave INT = 26; 
    DECLARE @BonusLeave INT;

    SET @TotalYears = dbo.fn_GetTotalYearsWorked(@WorkerID, @CompanyID);
    SET @BonusLeave = FLOOR(@TotalYears / 2);

    RETURN @BaseLeave + @BonusLeave;
END;
GO






CREATE FUNCTION fn_GetRemainingLeaveDays (@WorkerID INT, @CompanyID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalEntitlement INT;
    DECLARE @LeaveTaken INT;
    DECLARE @CurrentYearStart DATE = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
    DECLARE @CurrentYearEnd DATE = DATEFROMPARTS(YEAR(GETDATE()), 12, 31);
    
    DECLARE @VacationTypeID INT = 2;

    SET @TotalEntitlement = dbo.fn_GetAnnualAbsenceDays(@WorkerID, @CompanyID);

    SELECT
        @LeaveTaken = COALESCE(
            SUM(
                DATEDIFF(
                    DAY,
                    CASE
                        WHEN a.StartDate < @CurrentYearStart THEN @CurrentYearStart
                        ELSE a.StartDate
                    END,
                    CASE
                        WHEN a.EndDate > @CurrentYearEnd THEN @CurrentYearEnd
                        ELSE a.EndDate
                    END
                ) + 1
            ),
            0
        )
    FROM Absence AS a
    JOIN Employment AS e ON a.EmploymentID = e.EmploymentID
    JOIN Position AS p ON e.PositionID = p.PositionID
    JOIN Department AS d ON p.DepartmentID = d.DepartmentID
    WHERE e.WorkerID = @WorkerID
    AND d.CompanyID = @CompanyID
    AND a.AbsenceTypeID = @VacationTypeID
    AND a.StartDate <= @CurrentYearEnd
    AND a.EndDate >= @CurrentYearStart;

    RETURN @TotalEntitlement - @LeaveTaken;
END;
GO





