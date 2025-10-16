CREATE TRIGGER trg_Employment_NoOverlap
ON Employment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Employment e
            ON e.WorkerID = i.WorkerID
            AND e.EmploymentID <> i.EmploymentID
        JOIN Position p1 ON p1.PositionID = e.PositionID
        JOIN Department d1 ON d1.DepartmentID = p1.DepartmentID
        JOIN Position p2 ON p2.PositionID = i.PositionID
        JOIN Department d2 ON d2.DepartmentID = p2.DepartmentID
        WHERE d1.CompanyID = d2.CompanyID
            AND (
                i.StartDate <= ISNULL(e.EndDate, '9999-12-31')
                AND e.StartDate <= ISNULL(i.EndDate, '9999-12-31')
            )
    )
    BEGIN
        RAISERROR('Pracownik ma już zatrudnienie w tej firmie w tym okresie.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END