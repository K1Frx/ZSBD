CREATE PROCEDURE usp_AddNewWorker
    @FirstName NVARCHAR(255),
    @LastName NVARCHAR(255),
    @Pesel NVARCHAR(11),
    @Login NVARCHAR(100),
    
    @NewWorkerID INT OUTPUT 
AS
BEGIN
    SET NOCOUNT ON;

    -- WALIDACJA DANYCH

    -- Sprawdzenie czy PESEL juz istnieje
    IF EXISTS (SELECT 1 FROM Worker WHERE Pesel = @Pesel)
    BEGIN
        RAISERROR(N'Blad: Pracownik o PESEL [%s] juz istnieje w tabeli Worker.', 16, 1, @Pesel);
        RETURN -1;
    END;

    -- Sprawdzenie dlugosci PESEL
    IF LEN(ISNULL(@Pesel, '')) != 11
    BEGIN
        RAISERROR(N'Blad: PESEL musi miec dokladnie 11 znakow.', 16, 1);
        RETURN -1;
    END;

    -- Sprawdzenie czy Login juz istnieje
    IF EXISTS (SELECT 1 FROM Worker WHERE Login = @Login)
    BEGIN
        RAISERROR(N'Blad: Login [%s] jest juz przypisany do innego pracownika.', 16, 1, @Login);
        RETURN -1;
    END;
    
    -- Sprawdzenie pustych wartosci
    IF ISNULL(@FirstName, '') = '' OR ISNULL(@LastName, '') = ''
    BEGIN
        RAISERROR(N'Blad: Imie i Nazwisko nie moga byc puste.', 16, 1);
        RETURN -1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        INSERT INTO Worker (FirstName, LastName, Pesel, Login)
        VALUES (@FirstName, @LastName, @Pesel, @Login);

        SET @NewWorkerID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
        PRINT N'Sukces: Cała operacja zakończona pomyślnie.';
        RETURN 0;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT N'Blad: Transakcja wycofana.';
        END

        RETURN -1;
    END CATCH
END;
GO




CREATE PROCEDURE usp_ApproveHolidayRequest
    @HolidayRequestID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TargetEmploymentID INT;
    DECLARE @TargetStartDate DATE;
    DECLARE @TargetEndDate DATE;
    DECLARE @CurrentStatus NVARCHAR(50);
    DECLARE @VacationAbsenceTypeID INT = 2;

    SELECT
        @TargetEmploymentID = EmploymentID,
        @TargetStartDate = AbsenceStart,
        @TargetEndDate = AbsenceEnd,
        @CurrentStatus = Status
    FROM HolidayRequest WITH (HOLDLOCK, UPDLOCK)
    WHERE HolidayRequestID = @HolidayRequestID;

    IF @TargetEmploymentID IS NULL
    BEGIN
        RAISERROR(N'Błąd: Wniosek urlopowy o ID [%d] nie istnieje.', 16, 1, @HolidayRequestID);
        RETURN -1;
    END;

    IF @CurrentStatus != 'Pending'
    BEGIN
        RAISERROR(N'Błąd: Wniosek nie jest w stanie "Pending". Obecny status: %s.', 16, 1, @CurrentStatus);
        RETURN -1;
    END;

    IF EXISTS (
        SELECT 1
        FROM Absence
        WHERE EmploymentID = @TargetEmploymentID
          AND StartDate <= @TargetEndDate
          AND EndDate >= @TargetStartDate
    )
    BEGIN
        RAISERROR(N'Błąd: Pracownik ma już inną zarejestrowaną nieobecność w tym terminie.', 16, 1);
        RETURN -1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
    
        UPDATE HolidayRequest
        SET Status = 'Approved'
        WHERE HolidayRequestID = @HolidayRequestID;

        INSERT INTO Absence (
            EmploymentID,
            AbsenceTypeID,
            HolidayRequestID,
            StartDate,
            EndDate
        )
        VALUES (
            @TargetEmploymentID,
            @VacationAbsenceTypeID,
            @HolidayRequestID,
            @TargetStartDate,
            @TargetEndDate
        );
        
        COMMIT TRANSACTION;
        PRINT N'Sukces: Wniosek został zatwierdzony i utworzono nieobecność.';
        RETURN 0;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT N'Błąd: Transakcja wycofana.';
        END
        
        RETURN -1;
    END CATCH
END;
GO