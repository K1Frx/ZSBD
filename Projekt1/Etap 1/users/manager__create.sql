CREATE LOGIN manager1_company1 with PASSWORD = 'manager1_company1';

USE Projekt1;
CREATE USER manager1_company1 FOR LOGIN manager1_company1;

GRANT SELECT ON v_Department1_Manager TO manager1_company1;
GRANT SELECT ON v_Worktime_Departament1_Manager TO manager1_company1;
GRANT SELECT ON v_Absence_Departament1_Manager TO manager1_company1;
GRANT SELECT, UPDATE ON v_HolidayRequest_Departament1_Manager TO manager1_company1;
GRANT SELECT ON v_Worker_Departament1_Manager TO manager1_company1;
GRANT SELECT ON EmploymentType TO hr1_company1;
GRANT SELECT ON WorktimeType TO hr1_company1;
GRANT SELECT ON AbsenceType TO hr1_company1;
GRANT SELECT ON Responsibility TO hr1_company1;
