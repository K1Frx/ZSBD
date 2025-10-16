CREATE LOGIN pbackend1_technologie_polskie WITH PASSWORD = 'pbackend1_technologie_polskie';

USE Projekt1;
CREATE USER pbackend1_technologie_polskie FOR LOGIN pbackend1_technologie_polskie;

GRANT SELECT ON v_Worker_Self TO pbackend1_technologie_polskie;
GRANT SELECT ON v_Absence_Self TO pbackend1_technologie_polskie;
GRANT SELECT, INSERT, UPDATE, DELETE ON v_Worktime_Self TO pbackend1_technologie_polskie;
GRANT SELECT ON v_HolidayRequest_Self TO pbackend1_technologie_polskie;
GRANT SELECT ON v_Employment_Self TO pbackend1_technologie_polskie;