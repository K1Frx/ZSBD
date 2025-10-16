--CREATE LOGIN hr1_company1 with PASSWORD = 'hr1_company1';

--USE Projekt1;
--CREATE USER hr1_company1 FOR LOGIN hr1_company1;

GRANT SELECT ON v_Company1 TO hr1_company1;
GRANT SELECT ON v_Department_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Position_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Employment_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Worktime_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Absence_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_HolidayRequest_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_ResponsibilityEmployment_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Facture_Company1 TO hr1_company1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Worker TO hr1_company1;
GRANT SELECT ON EmploymentType TO hr1_company1;
GRANT SELECT ON WorktimeType TO hr1_company1;
GRANT SELECT ON AbsenceType TO hr1_company1;
GRANT SELECT ON Responsibility TO hr1_company1;
