CREATE TABLE Company (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    NIP NVARCHAR(10) NOT NULL UNIQUE,
    Address NVARCHAR(255) NOT NULL
);

SET IDENTITY_INSERT Company ON;

INSERT INTO Company (CompanyID, Name, NIP, Address) VALUES
(1, 'Technologie Polskie', '1234567890', 'ul. Technologiczna 1, Warszawa'),
(2, 'Biznes Polska', '0987654321', 'ul. Biznesowa 2, Kraków'),
(3, 'Innowacje Sp. z o.o.', '1122334455', 'ul. Innowacyjna 3, Wrocław'),
(4, 'Globalne Przedsiębiorstwo', '6677889900', 'ul. Globalna 4, Gdańsk');

SET IDENTITY_INSERT Company OFF;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    CompanyID INT NOT NULL,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID) ON DELETE CASCADE
);

SET IDENTITY_INSERT Department ON;

INSERT INTO Department (DepartmentID, Name, CompanyID) VALUES
(1, 'Dział IT', 1),
(2, 'Dział HR', 1),
(3, 'Dział Finansów', 1),
(4, 'Dział Marketingu', 1),
(5, 'Dział Sprzedaży', 1),
(6, 'Dział IT', 2),
(7, 'Dział HR', 2),
(8, 'Dział Finansów', 2),
(9, 'Dział Marketingu', 2),
(10, 'Dział Sprzedaży', 2),
(11, 'Dział IT', 3),
(12, 'Dział HR', 3),
(13, 'Dział Finansów', 3),
(14, 'Dział Marketingu', 3),
(15, 'Dział Sprzedaży', 3),
(16, 'Dział IT', 4),
(17, 'Dział HR', 4),
(18, 'Dział Finansów', 4),
(19, 'Dział Marketingu', 4),
(20, 'Dział Sprzedaży', 4);

SET IDENTITY_INSERT Department OFF;

CREATE TABLE Position (
    PositionID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    DepartmentID INT NOT NULL,
    Description NVARCHAR(255) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE CASCADE
);

SET IDENTITY_INSERT Position ON;

INSERT INTO Position (PositionID, Name, DepartmentID, Description) VALUES
-- IT
(1, 'Programista Backend', 1, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(2, 'Programista Frontend', 1, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(3, 'DevOps', 1, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(4, 'Kierownik IT', 1, 'Zarządzanie zespołem IT i projektami technologicznymi'),
(5, 'Programista Backend', 6, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(6, 'Programista Frontend', 6, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(7, 'DevOps', 6, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(8, 'Kierownik IT', 6, 'Zarządzanie zespołem IT i projektami technologicznymi'),
(9, 'Programista Backend', 11, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(10, 'Programista Frontend', 11, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(11, 'DevOps', 11, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(12, 'Kierownik IT', 11, 'Zarządzanie zespołem IT i projektami technologicznymi'),
(13, 'Programista Backend', 16, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(14, 'Programista Frontend', 16, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(15, 'DevOps', 16, 'Odpowiedzialny za rozwój i utrzymanie oprogramowania'),
(16, 'Kierownik IT', 16, 'Zarządzanie zespołem IT i projektami technologicznymi'),
-- HR
(17, 'Specjalista ds. Rekrutacji', 2, 'Odpowiedzialny za procesy rekrutacyjne'),
(18, 'Specjalista ds. Rekrutacji', 7, 'Odpowiedzialny za procesy rekrutacyjne'),
(19, 'Specjalista ds. Rekrutacji', 12, 'Odpowiedzialny za procesy rekrutacyjne'),
(20, 'Specjalista ds. Rekrutacji', 17, 'Odpowiedzialny za procesy rekrutacyjne'),
(21, 'Starszy specjalista ds. Rekrutacji', 2, 'Odpowiedzialny za procesy rekrutacyjne'),
(22, 'Starszy specjalista ds. Rekrutacji', 7, 'Odpowiedzialny za procesy rekrutacyjne'),
(23, 'Starszy specjalista ds. Rekrutacji', 12, 'Odpowiedzialny za procesy rekrutacyjne'),
(24, 'Starszy specjalista ds. Rekrutacji', 17, 'Odpowiedzialny za procesy rekrutacyjne'),
(25, 'Specjalista ds. Kadr', 2, 'Odpowiedzialny za zarządzanie kadrami'),
(26, 'Specjalista ds. Kadr', 7, 'Odpowiedzialny za zarządzanie kadrami'),
(27, 'Specjalista ds. Kadr', 12, 'Odpowiedzialny za zarządzanie kadrami'),
(28, 'Specjalista ds. Kadr', 17, 'Odpowiedzialny za zarządzanie kadrami'),
(29, 'Starszy specjalista ds. Kadr', 2, 'Odpowiedzialny za zarządzanie kadrami'),
(30, 'Starszy specjalista ds. Kadr', 7, 'Odpowiedzialny za zarządzanie kadrami'),
(31, 'Starszy specjalista ds. Kadr', 12, 'Odpowiedzialny za zarządzanie kadrami'),
(32, 'Starszy specjalista ds. Kadr', 17, 'Odpowiedzialny za zarządzanie kadrami'),
(33, 'Kierownik HR', 2, 'Zarządzanie zespołem HR i procesami kadrowymi'),
(34, 'Kierownik HR', 7, 'Zarządzanie zespołem HR i procesami kadrowymi'),
(35, 'Kierownik HR', 12, 'Zarządzanie zespołem HR i procesami kadrowymi'),
(36, 'Kierownik HR', 17, 'Zarządzanie zespołem HR i procesami kadrowymi'),
-- Finanse
(37, 'Analityk Finansowy', 3, 'Odpowiedzialny za analizę finansową'),
(38, 'Analityk Finansowy', 8, 'Odpowiedzialny za analizę finansową'),
(39, 'Analityk Finansowy', 13, 'Odpowiedzialny za analizę finansową'),
(40, 'Analityk Finansowy', 18, 'Odpowiedzialny za analizę finansową'),
(41, 'Księgowy', 3, 'Odpowiedzialny za prowadzenie księgowości'),
(42, 'Księgowy', 8, 'Odpowiedzialny za prowadzenie księgowości'),
(43, 'Księgowy', 13, 'Odpowiedzialny za prowadzenie księgowości'),
(44, 'Księgowy', 18, 'Odpowiedzialny za prowadzenie księgowości'),
(45, 'Główny Księgowy', 3, 'Odpowiedzialny za prowadzenie księgowości'),
(46, 'Główny Księgowy', 8, 'Odpowiedzialny za prowadzenie księgowości'),
(47, 'Główny Księgowy', 13, 'Odpowiedzialny za prowadzenie księgowości'),
(48, 'Główny Księgowy', 18, 'Odpowiedzialny za prowadzenie księgowości'),
-- Marketing
(49, 'Content creator', 4, 'Odpowiedzialny za tworzenie treści marketingowych'),
(50, 'Content creator', 9, 'Odpowiedzialny za tworzenie treści marketingowych'),
(51, 'Content creator', 14, 'Odpowiedzialny za tworzenie treści marketingowych'),
(52, 'Content creator', 19, 'Odpowiedzialny za tworzenie treści marketingowych'),
(53, 'Specjalista SEO', 4, 'Odpowiedzialny za optymalizację pod kątem wyszukiwarek'),
(54, 'Specjalista SEO', 9, 'Odpowiedzialny za optymalizację pod kątem wyszukiwarek'),
(55, 'Specjalista SEO', 14, 'Odpowiedzialny za optymalizację pod kątem wyszukiwarek'),
(56, 'Specjalista SEO', 19, 'Odpowiedzialny za optymalizację pod kątem wyszukiwarek'),
(57, 'Kierownik Marketingu', 4, 'Zarządzanie zespołem marketingowym i kampaniami'),
(58, 'Kierownik Marketingu', 9, 'Zarządzanie zespołem marketingowym i kampaniami'),
(59, 'Kierownik Marketingu', 14, 'Zarządzanie zespołem marketingowym i kampaniami'),
(60, 'Kierownik Marketingu', 19, 'Zarządzanie zespołem marketingowym i kampaniami'),
-- Sprzedaż
(61, 'Przedstawiciel Handlowy', 5, 'Odpowiedzialny za sprzedaż produktów i usług'),
(62, 'Przedstawiciel Handlowy', 10, 'Odpowiedzialny za sprzedaż produktów i usług'),
(63, 'Przedstawiciel Handlowy', 15, 'Odpowiedzialny za sprzedaż produktów i usług'),
(64, 'Przedstawiciel Handlowy', 20, 'Odpowiedzialny za sprzedaż produktów i usług'),
(65, 'Kierownik Sprzedaży', 5, 'Zarządzanie zespołem sprzedaży i strategią sprzedaży'),
(66, 'Kierownik Sprzedaży', 10, 'Zarządzanie zespołem sprzedaży i strategią sprzedaży'),
(67, 'Kierownik Sprzedaży', 15, 'Zarządzanie zespołem sprzedaży i strategią sprzedaży'),
(68, 'Kierownik Sprzedaży', 20, 'Zarządzanie zespołem sprzedaży i strategią sprzedaży');

SET IDENTITY_INSERT Position OFF;

CREATE TABLE Responsibility (
    ResponsibilityID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255) NOT NULL  
);

SET IDENTITY_INSERT Responsibility ON;

INSERT INTO Responsibility (ResponsibilityID, Name, Description) VALUES
(1, 'Zarządzanie projektami', 'Nadzór nad realizacją projektów od początku do końca'),
(2, 'Rozwój oprogramowania', 'Tworzenie i utrzymanie aplikacji oraz systemów'),
(3, 'Wsparcie techniczne', 'Pomoc użytkownikom w rozwiązywaniu problemów technicznych'),
(4, 'Rekrutacja', 'Prowadzenie procesów rekrutacyjnych i selekcji kandydatów'),
(5, 'Zarządzanie kadrami', 'Nadzór nad dokumentacją pracowniczą i procesami kadrowymi'),
(6, 'Analiza finansowa', 'Przygotowywanie analiz i raportów finansowych'),
(7, 'Księgowość', 'Prowadzenie ksiąg rachunkowych i rozliczeń finansowych'),
(8, 'Tworzenie treści marketingowych', 'Opracowywanie materiałów promocyjnych i reklamowych'),
(9, 'Optymalizacja SEO', 'Poprawa widoczności stron internetowych w wyszukiwarkach'),
(10, 'Sprzedaż produktów i usług', 'Pozyskiwanie klientów i realizacja celów sprzedażowych'),
(11, 'Zarządzanie zespołem', 'Kierowanie pracą zespołu i motywowanie pracowników');

SET IDENTITY_INSERT Responsibility OFF;

CREATE TABLE ResponsibilityPosition (
    PositionID INT NOT NULL,
    ResponsibilityID INT NOT NULL,
    PRIMARY KEY (PositionID, ResponsibilityID),
    FOREIGN KEY (PositionID) REFERENCES Position(PositionID) ON DELETE CASCADE,
    FOREIGN KEY (ResponsibilityID) REFERENCES Responsibility(ResponsibilityID) ON DELETE CASCADE
);

INSERT INTO ResponsibilityPosition (PositionID, ResponsibilityID) VALUES
(1, 2), (1, 3),
(2, 2), (2, 3),
(3, 2), (3, 3),
(4, 1), (4, 11),
(5, 2), (5, 3),
(6, 2), (6, 3),
(7, 2), (7, 3),
(8, 1), (8, 11),
(9, 2), (9, 3),
(10, 2), (10, 3),
(11, 2), (11, 3),
(12, 1), (12, 11),
(13, 2), (13, 3),
(14, 2), (14, 3),
(15, 2), (15, 3),
(16, 1), (16, 11),
(17, 4),
(18, 4),
(19, 4),
(20, 4),
(21, 4),
(22, 4),
(23, 4),
(24, 4),
(25, 5),
(26, 5),
(27, 5),
(28, 5),
(29, 5),
(30, 5),
(31, 5),
(32, 5),
(33, 4), (33, 5), (33, 11),
(34, 4), (34, 5), (34, 11),
(35, 4), (35, 5), (35, 11),
(36, 4), (36, 5), (36, 11),
(37, 6),
(38, 6),
(39, 6),
(40, 6),
(41, 7),
(42, 7),
(43, 7),
(44, 7),
(45, 7), (45, 11),
(46, 7), (46, 11),
(47, 7), (47, 11),
(48, 7), (48, 11),
(49, 8),
(50, 8),
(51, 8),
(52, 8),
(53, 9),
(54, 9),
(55, 9),
(56, 9),
(57, 8), (57, 9), (57, 11),
(58, 8), (58, 9), (58, 11),
(59, 8), (59, 9), (59, 11),
(60, 8), (60, 9), (60, 11),
(61, 10),
(62, 10),
(63, 10),
(64, 10),
(65, 10), (65, 11),
(66, 10), (66, 11),
(67, 10), (67, 11),
(68, 10), (68, 11);

CREATE TABLE Worker (
    WorkerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(255) NOT NULL,
    LastName NVARCHAR(255) NOT NULL,
    Pesel NVARCHAR(11) NOT NULL UNIQUE,
    Login NVARCHAR(100) NOT NULL UNIQUE
);

-- in python

CREATE TABLE EmploymentType (
    EmploymentTypeID INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(255) NOT NULL
);

SET IDENTITY_INSERT EmploymentType ON;

INSERT INTO EmploymentType (EmploymentTypeID, Type) VALUES
(1, 'UoP'),
(2, 'UZ'),
(3, 'UD');

SET IDENTITY_INSERT EmploymentType OFF;

CREATE TABLE Employment (
    EmploymentID INT PRIMARY KEY IDENTITY(1,1),
    WorkerID INT NOT NULL,
    EmploymentTypeID INT NOT NULL,
    PositionID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    FOREIGN KEY (WorkerID) REFERENCES Worker(WorkerID) ON DELETE CASCADE,
    FOREIGN KEY (EmploymentTypeID) REFERENCES EmploymentType(EmploymentTypeID) ON DELETE CASCADE,
    FOREIGN KEY (PositionID) REFERENCES Position(PositionID) ON DELETE CASCADE
);

-- EMPLOYMENT IN PYTHON!

CREATE TABLE ResponsibilityEmployment (
    EmploymentID INT NOT NULL,
    ResponsibilityID INT NOT NULL,
    PRIMARY KEY (EmploymentID, ResponsibilityID),
    FOREIGN KEY (EmploymentID) REFERENCES Employment(EmploymentID) ON DELETE CASCADE,
    FOREIGN KEY (ResponsibilityID) REFERENCES Responsibility(ResponsibilityID) ON DELETE CASCADE
);

-- RESPONSIBILITY<>EMPLOYMENT IN PYTHON!

CREATE TABLE Partner (
    PartnerID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    NIP NVARCHAR(10) NOT NULL UNIQUE,
    Address NVARCHAR(255) NOT NULL,
);

SET IDENTITY_INSERT Partner ON;

INSERT INTO Partner (PartnerID, Name, NIP, Address) VALUES
(1, 'Klient Technologie Polskie', '1112223334', 'ul. Klienta 1, Warszawa'),
(2, 'Dostawca Technologie Polskie', '5556667778', 'ul. Dostawcy 2, Kraków'),
(3, 'Klient Biznes Polska', '9998887776', 'ul. Klienta 3, Wrocław'),
(4, 'Dostawca Biznes Polska', '4443332221', 'ul. Dostawcy 4, Gdańsk'),
(5, 'Klient Innowacje Sp. z o.o.', '1231231230', 'ul. Klienta 5, Poznań'),
(6, 'Dostawca Innowacje Sp. z o.o.', '3213213210', 'ul. Dostawcy 6, Łódź'),
(7, 'Klient Globalne Przedsiębiorstwo', '4564564560', 'ul. Klienta 7, Szczecin'),
(8, 'Dostawca Globalne Przedsiębiorstwo', '6546546540', 'ul. Dostawcy 8, Lublin');

SET IDENTITY_INSERT Partner OFF;

CREATE TABLE Facture (
    FactureID INT PRIMARY KEY IDENTITY(1,1),
    PartnerID INT NOT NULL,
    CompanyID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (PartnerID) REFERENCES Partner(PartnerID) ON DELETE CASCADE,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID) ON DELETE CASCADE
);

SET IDENTITY_INSERT Facture ON;

INSERT INTO Facture (FactureID, CompanyID, PartnerID, Amount, Description, Date) VALUES
(1, 1, 1, 15000.00, 'Usługi IT dla Klienta Technologie Polskie', '2023-01-15'),
(2, 1, 2, 8000.00, 'Zakup sprzętu komputerowego od Dostawcy Technologie Polskie', '2023-02-10'),
(3, 2, 3, 12000.00, 'Usługi konsultingowe dla Klienta Biznes Polska', '2023-03-05'),
(4, 2, 4, 5000.00, 'Zakup oprogramowania od Dostawcy Biznes Polska', '2023-04-12'),
(5, 3, 5, 20000.00, 'Rozwój aplikacji dla Klienta Innowacje Sp. z o.o.', '2023-05-20'),
(6, 3, 6, 7000.00, 'Zakup licencji od Dostawcy Innowacje Sp. z o.o.', '2023-06-18'),
(7, 4, 7, 25000.00, 'Usługi doradcze dla Klienta Globalne Przedsiębiorstwo', '2023-07-22'),
(8, 4, 8, 9000.00, 'Zakup sprzętu sieciowego od Dostawcy Globalne Przedsiębiorstwo', '2023-08-30'),
(9, 1, 1, 16000.00, 'Usługi IT dla Klienta Technologie Polskie - projekt B', '2023-09-14'),
(10, 1, 2, 8500.00, 'Zakup monitorów od Dostawcy Technologie Polskie', '2023-10-11'),
(11, 2, 3, 13000.00, 'Usługi konsultingowe dla Klienta Biznes Polska - projekt C', '2023-11-06'),
(12, 2, 4, 5500.00, 'Zakup oprogramowania od Dostawcy Biznes Polska - aktualizacja', '2023-12-13'),
(13, 3, 5, 21000.00, 'Rozwój aplikacji dla Klienta Innowacje Sp. z o.o. - projekt D', '2024-01-21'),
(14, 3, 6, 7500.00, 'Zakup licencji od Dostawcy Innowacje Sp. z o.o. - rozszerzenie', '2024-02-19'),
(15, 4, 7, 26000.00, 'Usługi doradcze dla Klienta Globalne Przedsiębiorstwo - projekt E', '2024-03-23'),
(16, 4, 8, 9500.00, 'Zakup sprzętu sieciowego od Dostawcy Globalne Przedsiębiorstwo - modernizacja', '2024-04-01');

SET IDENTITY_INSERT Facture OFF;

CREATE TABLE WorktimeType (
    WorktimeTypeID INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(255) NOT NULL
);

SET IDENTITY_INSERT WorktimeType ON;

INSERT INTO WorktimeType (WorktimeTypeID, Type) VALUES
(1, 'Praca zdalna'),
(2, 'Praca stacjonarna'),
(3, 'Praca w delegacji'),
(4, 'Praca zdalna - nadgodziny'),
(5, 'Praca stacjonarna - nadgodziny'),
(6, 'Praca w delegacji - nadgodziny');

SET IDENTITY_INSERT WorktimeType OFF;
CREATE TABLE Worktime (
    WorktimeID INT PRIMARY KEY IDENTITY(1,1),
    EmploymentID INT NOT NULL,
    WorktimeTypeID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    FOREIGN KEY (EmploymentID) REFERENCES Employment(EmploymentID) ON DELETE CASCADE,
    FOREIGN KEY (WorktimeTypeID) REFERENCES WorktimeType(WorktimeTypeID) ON DELETE CASCADE
);


-- WORKTIME IN PYTHON!

CREATE TABLE AbsenceType (
    AbsenceTypeID INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(255) NOT NULL
);

SET IDENTITY_INSERT AbsenceType ON;

INSERT INTO AbsenceType (AbsenceTypeID, Type) VALUES
(1, 'Chorobowe'),
(2, 'Urlop wypoczynkowy'),
(3, 'Urlop okolicznościowy'),
(4, 'Urlop bezpłatny'),
(5, 'Opieka nad dzieckiem'),
(6, 'Nieobecność nieusprawiedliwiona');

SET IDENTITY_INSERT AbsenceType OFF;

CREATE TABLE HolidayRequest (
    HolidayRequestID INT PRIMARY KEY IDENTITY(1,1),
    EmploymentID INT NOT NULL,
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    Reason NVARCHAR(255),
    Justification NVARCHAR(255),
    AbsenceStart DATE NOT NULL,
    AbsenceEnd DATE NOT NULL,
    FOREIGN KEY (EmploymentID) REFERENCES Employment(EmploymentID) ON DELETE CASCADE
);

-- HOLIDAY REQUEST IN PYTHON!

CREATE TABLE Absence (
    AbsenceID INT PRIMARY KEY IDENTITY(1,1),
    EmploymentID INT NOT NULL,
    AbsenceTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    HolidayRequestID INT NULL,
    FOREIGN KEY (EmploymentID) REFERENCES Employment(EmploymentID) ON DELETE CASCADE,
    FOREIGN KEY (AbsenceTypeID) REFERENCES AbsenceType(AbsenceTypeID) ON DELETE CASCADE,
    FOREIGN KEY (HolidayRequestID) REFERENCES HolidayRequest(HolidayRequestID) ON DELETE NO ACTION
);