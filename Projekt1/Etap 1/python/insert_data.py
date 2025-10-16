import random
from datetime import datetime, timedelta
import pyodbc

used_pesels = set()
employment_id = 0
absence_id = 0
worktime_id = 0
holiday_request_id = 0

def get_pesel():
    while True:
        pesel = ''.join(random.choices('0123456789', k=11))
        if pesel not in used_pesels:
            used_pesels.add(pesel)
            return pesel
        
def get_workers_sql():
    return f"""
SET IDENTITY_INSERT WORKER ON;

INSERT INTO WORKER (WorkerID, FirstName, LastName, Pesel, Login) VALUES
(1, 'Programista Backend 1', 'Technologie Polskie', '{get_pesel()}', 'pbackend1_technologie_polskie'),
(2, 'Programista Backend 2', 'Technologie Polskie', '{get_pesel()}', 'pbackend2_technologie_polskie'),
(3, 'Programista Frontend 1', 'Technologie Polskie', '{get_pesel()}', 'pfrontend1_technologie_polskie'),
(4, 'Programista Frontend 2', 'Technologie Polskie', '{get_pesel()}', 'pfrontend2_technologie_polskie'),
(5, 'DevOps 1', 'Technologie Polskie', '{get_pesel()}', 'devops1_technologie_polskie'),
(6, 'DevOps 2', 'Technologie Polskie', '{get_pesel()}', 'devops2_technologie_polskie'),
(7, 'Kierownik IT 1', 'Technologie Polskie', '{get_pesel()}', 'kierownik_it1_technologie_polskie'),
(8, 'Specjalista ds. Rekrutacji 1', 'Technologie Polskie', '{get_pesel()}', 'rekrutacja1_technologie_polskie'),
(9, 'Specjalista ds. Rekrutacji 2', 'Technologie Polskie', '{get_pesel()}', 'rekrutacja2_technologie_polskie'),
(10, 'Starszy specjalista ds. Rekrutacji 1', 'Technologie Polskie', '{get_pesel()}', 'starszy_rekrutacja1_technologie_polskie'),
(11, 'Starszy specjalista ds. Rekrutacji 2', 'Technologie Polskie', '{get_pesel()}', 'starszy_rekrutacja2_technologie_polskie'),
(12, 'Specjalista ds. Kadr 1', 'Technologie Polskie', '{get_pesel()}', 'kadr1_technologie_polskie'),
(13, 'Specjalista ds. Kadr 2', 'Technologie Polskie', '{get_pesel()}', 'kadr2_technologie_polskie'),
(14, 'Starszy specjalista ds. Kadr 1', 'Technologie Polskie', '{get_pesel()}', 'starszy_kadr1_technologie_polskie'),
(15, 'Starszy specjalista ds. Kadr 2', 'Technologie Polskie', '{get_pesel()}', 'starszy_kadr2_technologie_polskie'),
(16, 'Kierownik HR 1', 'Technologie Polskie', '{get_pesel()}', 'kierownik_hr1_technologie_polskie'),
(17, 'Analityk Finansowy 1', 'Technologie Polskie', '{get_pesel()}', 'analityk_finansowy1_technologie_polskie'),
(18, 'Analityk Finansowy 2', 'Technologie Polskie', '{get_pesel()}', 'analityk_finansowy2_technologie_polskie'),
(19, 'Księgowy 1', 'Technologie Polskie', '{get_pesel()}', 'ksiegowy1_technologie_polskie'),
(20, 'Księgowy 2', 'Technologie Polskie', '{get_pesel()}', 'ksiegowy2_technologie_polskie'),
(21, 'Główny Księgowy 1', 'Technologie Polskie', '{get_pesel()}', 'glowny_ksiegowy1_technologie_polskie'),
(22, 'Content creator 1', 'Technologie Polskie', '{get_pesel()}', 'content_creator1_technologie_polskie'),
(23, 'Content creator 2', 'Technologie Polskie', '{get_pesel()}', 'content_creator2_technologie_polskie'),
(24, 'Specjalista SEO 1', 'Technologie Polskie', '{get_pesel()}', 'specjalista_seo1_technologie_polskie'),
(25, 'Specjalista SEO 2', 'Technologie Polskie', '{get_pesel()}', 'specjalista_seo2_technologie_polskie'),
(26, 'Kierownik Marketingu 1', 'Technologie Polskie', '{get_pesel()}', 'kierownik_marketingu1_technologie_polskie'),
(27, 'Przedstawiciel Handlowy 1', 'Technologie Polskie', '{get_pesel()}', 'przedstawiciel_handlowy1_technologie_polskie'),
(28, 'Przedstawiciel Handlowy 2', 'Technologie Polskie', '{get_pesel()}', 'przedstawiciel_handlowy2_technologie_polskie'),
(39, 'Kierownik Sprzedaży 1', 'Technologie Polskie', '{get_pesel()}', 'kierownik_sprzedazy1_technologie_polskie'),
(40, 'Programista Backend 1', 'Biznes Polska', '{get_pesel()}', 'programista_backend1_biznes_polska'),
(41, 'Programista Backend 2', 'Biznes Polska', '{get_pesel()}', 'programista_backend2_biznes_polska'),
(42, 'Programista Frontend 1', 'Biznes Polska', '{get_pesel()}', 'programista_frontend1_biznes_polska'),
(43, 'Programista Frontend 2', 'Biznes Polska', '{get_pesel()}', 'programista_frontend2_biznes_polska'),
(44, 'DevOps 1', 'Biznes Polska', '{get_pesel()}', 'devops1_biznes_polska'),
(45, 'DevOps 2', 'Biznes Polska', '{get_pesel()}', 'devops2_biznes_polska'),
(46, 'Kierownik IT 1', 'Biznes Polska', '{get_pesel()}', 'kierownik_it1_biznes_polska'),
(47, 'Specjalista ds. Rekrutacji 1', 'Biznes Polska', '{get_pesel()}', 'specjalista_ds_rekrutacji1_biznes_polska'),
(48, 'Specjalista ds. Rekrutacji 2', 'Biznes Polska', '{get_pesel()}', 'specjalista_ds_rekrutacji2_biznes_polska'),
(49, 'Starszy specjalista ds. Rekrutacji 1', 'Biznes Polska', '{get_pesel()}', 'starszy_specjalista_ds_rekrutacji1_biznes_polska'),
(50, 'Starszy specjalista ds. Rekrutacji 2', 'Biznes Polska', '{get_pesel()}', 'starszy_specjalista_ds_rekrutacji2_biznes_polska'),
(51, 'Specjalista ds. Kadr 1', 'Biznes Polska', '{get_pesel()}', 'specjalista_ds_kadr1_biznes_polska'),
(52, 'Specjalista ds. Kadr 2', 'Biznes Polska', '{get_pesel()}', 'specjalista_ds_kadr2_biznes_polska'),
(53, 'Starszy specjalista ds. Kadr 1', 'Biznes Polska', '{get_pesel()}', 'starszy_specjalista_ds_kadr1_biznes_polska'),
(54, 'Starszy specjalista ds. Kadr 2', 'Biznes Polska', '{get_pesel()}', 'starszy_specjalista_ds_kadr2_biznes_polska'),
(55, 'Kierownik HR 1', 'Biznes Polska', '{get_pesel()}', 'kierownik_hr1_biznes_polska'),
(56, 'Analityk Finansowy 1', 'Biznes Polska', '{get_pesel()}', 'analityk_finansowy1_biznes_polska'),
(57, 'Analityk Finansowy 2', 'Biznes Polska', '{get_pesel()}', 'analityk_finansowy2_biznes_polska'),
(58, 'Księgowy 1', 'Biznes Polska', '{get_pesel()}', 'ksiegowy1_biznes_polska'),
(59, 'Księgowy 2', 'Biznes Polska', '{get_pesel()}', 'ksiegowy2_biznes_polska'),
(60, 'Główny Księgowy 1', 'Biznes Polska', '{get_pesel()}', 'glowny_ksiegowy1_biznes_polska'),
(61, 'Content creator 1', 'Biznes Polska', '{get_pesel()}', 'content_creator1_biznes_polska'),
(62, 'Content creator 2', 'Biznes Polska', '{get_pesel()}', 'content_creator2_biznes_polska'),
(63, 'Specjalista SEO 1', 'Biznes Polska', '{get_pesel()}', 'specjalista_seo1_biznes_polska'),
(64, 'Specjalista SEO 2', 'Biznes Polska', '{get_pesel()}', 'specjalista_seo2_biznes_polska'),
(65, 'Kierownik Marketingu 1', 'Biznes Polska', '{get_pesel()}', 'kierownik_marketingu1_biznes_polska'),
(66, 'Przedstawiciel Handlowy 1', 'Biznes Polska', '{get_pesel()}', 'przedstawiciel_handlowy1_biznes_polska'),
(67, 'Przedstawiciel Handlowy 2', 'Biznes Polska', '{get_pesel()}', 'przedstawiciel_handlowy2_biznes_polska'),
(68, 'Kierownik Sprzedaży 1', 'Biznes Polska', '{get_pesel()}', 'kierownik_sprzedazy1_biznes_polska'),
(69, 'Programista Backend 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'pbackend1_innowacje_sp_z_oo'),
(70, 'Programista Backend 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'pbackend2_innowacje_sp_z_oo'),
(71, 'Programista Frontend 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'pfrontend1_innowacje_sp_z_oo'),
(72, 'Programista Frontend 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'pfrontend2_innowacje_sp_z_oo'),
(73, 'DevOps 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'devops1_innowacje_sp_z_oo'),
(74, 'DevOps 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'devops2_innowacje_sp_z_oo'),
(75, 'Kierownik IT 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'kierownik_it1_innowacje_sp_z_oo'),
(76, 'Specjalista ds. Rekrutacji 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_rekrutacji1_innowacje_sp_z_oo'),
(77, 'Specjalista ds. Rekrutacji 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_rekrutacji2_innowacje_sp_z_oo'),
(78, 'Starszy specjalista ds. Rekrutacji 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'starszy_specjalista_rekrutacji1_innowacje_sp_z_oo'),
(79, 'Starszy specjalista ds. Rekrutacji 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'starszy_specjalista_rekrutacji2_innowacje_sp_z_oo'),
(80, 'Specjalista ds. Kadr 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_kadr1_innowacje_sp_z_oo'),
(81, 'Specjalista ds. Kadr 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_kadr2_innowacje_sp_z_oo'),
(82, 'Starszy specjalista ds. Kadr 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'starszy_specjalista_kadr1_innowacje_sp_z_oo'),
(83, 'Starszy specjalista ds. Kadr 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'starszy_specjalista_kadr2_innowacje_sp_z_oo'),
(84, 'Kierownik HR 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'kierownik_hr1_innowacje_sp_z_oo'),
(85, 'Analityk Finansowy 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'analityk_finansowy1_innowacje_sp_z_oo'),
(86, 'Analityk Finansowy 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'analityk_finansowy2_innowacje_sp_z_oo'),
(87, 'Księgowy 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'ksiegowy1_innowacje_sp_z_oo'),
(88, 'Księgowy 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'ksiegowy2_innowacje_sp_z_oo'),
(89, 'Główny Księgowy 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'glowny_ksiegowy1_innowacje_sp_z_oo'),
(90, 'Content creator 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'content_creator1_innowacje_sp_z_oo'),
(91, 'Content creator 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'content_creator2_innowacje_sp_z_oo'),
(92, 'Specjalista SEO 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_seo1_innowacje_sp_z_oo'),
(93, 'Specjalista SEO 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'specjalista_seo2_innowacje_sp_z_oo'),
(94, 'Kierownik Marketingu 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'kierownik_marketingu1_innowacje_sp_z_oo'),
(95, 'Przedstawiciel Handlowy 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'przedstawiciel_handlowy1_innowacje_sp_z_oo'),
(96, 'Przedstawiciel Handlowy 2', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'przedstawiciel_handlowy2_innowacje_sp_z_oo'),
(97, 'Kierownik Sprzedaży 1', 'Innowacje Sp. z o.o.', '{get_pesel()}', 'kierownik_sprzedazy1_innowacje_sp_z_oo'),
(98, 'Programista Backend 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'pbackend1_globalne_przedsiebiorstwo'),
(99, 'Programista Backend 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'pbackend2_globalne_przedsiebiorstwo'),
(100, 'Programista Frontend 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'pfrontend1_globalne_przedsiebiorstwo'),
(101, 'Programista Frontend 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'pfrontend2_globalne_przedsiebiorstwo'),
(102, 'DevOps 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'devops1_globalne_przedsiebiorstwo'),
(103, 'DevOps 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'devops2_globalne_przedsiebiorstwo'),
(104, 'Kierownik IT 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'kierownik_it1_globalne_przedsiebiorstwo'),
(105, 'Specjalista ds. Rekrutacji 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_rekrutacji1_globalne_przedsiebiorstwo'),
(106, 'Specjalista ds. Rekrutacji 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_rekrutacji2_globalne_przedsiebiorstwo'),
(107, 'Starszy specjalista ds. Rekrutacji 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'starszy_specjalista_rekrutacji1_globalne_przedsiebiorstwo'),
(108, 'Starszy specjalista ds. Rekrutacji 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'starszy_specjalista_rekrutacji2_globalne_przedsiebiorstwo'),
(109, 'Specjalista ds. Kadr 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_kadr1_globalne_przedsiebiorstwo'),
(110, 'Specjalista ds. Kadr 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_kadr2_globalne_przedsiebiorstwo'),
(111, 'Starszy specjalista ds. Kadr 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'starszy_specjalista_kadr1_globalne_przedsiebiorstwo'),
(112, 'Starszy specjalista ds. Kadr 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'starszy_specjalista_kadr2_globalne_przedsiebiorstwo'),
(113, 'Kierownik HR 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'kierownik_hr1_globalne_przedsiebiorstwo'),
(114, 'Analityk Finansowy 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'analityk_finansowy1_globalne_przedsiebiorstwo'),
(115, 'Analityk Finansowy 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'analityk_finansowy2_globalne_przedsiebiorstwo'),
(116, 'Księgowy 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'ksiegowy1_globalne_przedsiebiorstwo'),
(117, 'Księgowy 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'ksiegowy2_globalne_przedsiebiorstwo'),
(118, 'Główny Księgowy 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'glowny_ksiegowy1_globalne_przedsiebiorstwo'),
(119, 'Content creator 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'content_creator1_globalne_przedsiebiorstwo'),
(120, 'Content creator 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'content_creator2_globalne_przedsiebiorstwo'),
(121, 'Specjalista SEO 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_seo1_globalne_przedsiebiorstwo'),
(122, 'Specjalista SEO 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'specjalista_seo2_globalne_przedsiebiorstwo'),
(123, 'Kierownik Marketingu 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'kierownik_marketingu1_globalne_przedsiebiorstwo'),
(124, 'Przedstawiciel Handlowy 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'przedstawiciel_handlowy1_globalne_przedsiebiorstwo'),
(125, 'Przedstawiciel Handlowy 2', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'przedstawiciel_handlowy2_globalne_przedsiebiorstwo'),
(126, 'Kierownik Sprzedaży 1', 'Globalne Przedsiębiorstwo', '{get_pesel()}', 'kierownik_sprzedazy1_globalne_przedsiebiorstwo');

SET IDENTITY_INSERT WORKER OFF;
"""

def get_random_responsibilities(cursor, employment_id):
    responsibilities = random.sample(range(1, 11), random.randint(3, 6))
    for responsibility_id in responsibilities:
        cursor.execute(f"""
                       
            INSERT INTO ResponsibilityEmployment (EmploymentID, ResponsibilityID) VALUES
            ({employment_id}, {responsibility_id});

        """)

def generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date):
    current_date = start_date
    end_date = end_date if end_date else '2025-10-31'

    current_date = datetime.strptime(current_date, '%Y-%m-%d')
    end_date = datetime.strptime(end_date, '%Y-%m-%d')

    global absence_id, holiday_request_id, worktime_id
    while current_date <= end_date:
        
        # Check if the current date is a weekday (Monday to Friday)
        if current_date.weekday() >= 5:  # 5 = Saturday, 6 = Sunday
            current_date += timedelta(days=1)
            continue

        is_absent = random.randint(0, 100) < 6  # 6% chance of absence
        if is_absent:
            absence_type = random.randint(1, 6)
            if absence_type != 6:
                cursor.execute(f"""
                    SET IDENTITY_INSERT HolidayRequest ON;
                                          
                    INSERT INTO HolidayRequest (HolidayRequestID, EmploymentID, Status, Reason, Justification, AbsenceStart, AbsenceEnd) VALUES
                    ({holiday_request_id}, {employment_id}, 'Approved', 'Powód nieobecności', 'Uzasadnienie kierownika', '{current_date}', '{current_date}');

                    SET IDENTITY_INSERT HolidayRequest OFF;
                """)
                
                cursor.execute(f"""
                    SET IDENTITY_INSERT Absence ON;
                               
                    INSERT INTO Absence (AbsenceID, EmploymentID, AbsenceTypeID, StartDate, EndDate, HolidayRequestID) VALUES
                    ({absence_id}, {employment_id}, {absence_type}, '{current_date}', '{current_date}', {holiday_request_id});    

                    SET IDENTITY_INSERT Absence OFF;
                """)
                
                absence_id += 1
                holiday_request_id += 1

            else:
                cursor.execute(f"""
                    SET IDENTITY_INSERT Absence ON;
                               
                    INSERT INTO Absence (AbsenceID, EmploymentID, AbsenceTypeID, StartDate, EndDate, HolidayRequestID) VALUES
                    ({absence_id}, {employment_id}, {absence_type}, '{current_date}', '{current_date}', NULL);

                    SET IDENTITY_INSERT Absence OFF;
                """)
                
                absence_id += 1

        else:
            worktime_type = random.randint(1, 6)
            work_hours = random.randint(6, 10)
            work_minutes = random.choice([0, 15, 30, 45])

            cursor.execute(f"""
                SET IDENTITY_INSERT Worktime ON;
                           
                INSERT INTO Worktime (WorktimeID, EmploymentID, WorktimeTypeID, Date, Time) VALUES
                ({worktime_id}, {employment_id}, {worktime_type}, '{current_date}', '{work_hours:02}:{work_minutes:02}');

                SET IDENTITY_INSERT Worktime OFF;
            """)

            worktime_id += 1

        current_date += timedelta(days=1)

def create_worker_data(cursor, worker_id):
    worker_data = cursor.execute(f"SELECT * FROM Worker WHERE WorkerID = {worker_id}").fetchone()

    if worker_data is None:
        return

    position_name = worker_data[1][:-2]
    company_name = worker_data[2]

    company_id = cursor.execute(f"SELECT CompanyID FROM Company WHERE Name = '{company_name}'").fetchone()[0]
    position_id = cursor.execute(f"""
                                 
        SELECT 
            PositionID 
        FROM Position
        JOIN Department ON Position.DepartmentID = Department.DepartmentID
        JOIN Company ON Department.CompanyID = Company.CompanyID
        WHERE Position.Name = '{position_name}' AND Company.CompanyID = {company_id};

    """).fetchone()[0]
    
    employment_type = random.choice([1, 2, 3])

    global employment_id
    employments_num = random.randint(1, 6)
    is_employed = random.randint(0,10) < 8

    if employments_num >= 1:
        if is_employed:
            start_date = '2025-05-01'
            end_date = None

            if end_date:
                cursor.execute(f"""
                    SET IDENTITY_INSERT Employment ON;
                               
                    INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
                    ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});

                    SET IDENTITY_INSERT Employment OFF;
                """)
            else:
                cursor.execute(f"""
                    SET IDENTITY_INSERT Employment ON;
                               
                    INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
                    ({employment_id}, {worker_id}, {position_id}, '{start_date}', NULL, {employment_type});

                    SET IDENTITY_INSERT Employment OFF;
                """)

            generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
            get_random_responsibilities(cursor, employment_id)

            employment_id += 1

        else:
            start_date = '2025-05-01'
            end_date = '2025-10-31'
            employment_type = random.choice([1, 2, 3])
            cursor.execute(f"""
                SET IDENTITY_INSERT Employment ON;
                           
                INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
                ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});

                SET IDENTITY_INSERT Employment OFF;
            """)

            generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
            get_random_responsibilities(cursor, employment_id)

            employment_id += 1

    if employments_num >= 2:
        start_date = '2024-12-01'
        end_date = '2025-04-30'
        employment_type = random.choice([1, 2, 3])

        cursor.execute(f"""
            SET IDENTITY_INSERT Employment ON;
                       
            INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
            ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});

            SET IDENTITY_INSERT Employment OFF;
        """)
        
        generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
        get_random_responsibilities(cursor, employment_id)

        employment_id += 1

    if employments_num >= 3:
        start_date = '2024-05-01'
        end_date = '2024-11-30'
        employment_type = random.choice([1, 2, 3])

        cursor.execute(f"""
            SET IDENTITY_INSERT Employment ON;
                       
            INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
            ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});
            
            SET IDENTITY_INSERT Employment OFF;
        """)
        generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
        get_random_responsibilities(cursor, employment_id)
        
        employment_id += 1

    if employments_num >= 4:
        start_date = '2024-01-01'
        end_date = '2024-04-30'
        employment_type = random.choice([1, 2, 3])

        cursor.execute(f"""
            SET IDENTITY_INSERT Employment ON;
                       
            INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
            ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});
            
            SET IDENTITY_INSERT Employment OFF;
        """)
        generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
        get_random_responsibilities(cursor, employment_id)
        employment_id += 1

    if employments_num >= 5:
        start_date = '2023-05-01'
        end_date = '2023-12-31'
        employment_type = random.choice([1, 2, 3])

        cursor.execute(f"""
            SET IDENTITY_INSERT Employment ON;
            
            INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
            ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});
            
            SET IDENTITY_INSERT Employment OFF;
        """)
        generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
        get_random_responsibilities(cursor, employment_id)
        employment_id += 1

    if employments_num >= 6:
        start_date = '2022-05-01'
        end_date = '2023-04-30'
        employment_type = random.choice([1, 2, 3])

        cursor.execute(f"""
            SET IDENTITY_INSERT Employment ON;
                       
            INSERT INTO Employment (EmploymentID, WorkerID, PositionID, StartDate, EndDate, EmploymentTypeID) VALUES
            ({employment_id}, {worker_id}, {position_id}, '{start_date}', '{end_date}', {employment_type});
            
            SET IDENTITY_INSERT Employment OFF;
        """)
        generate_worktimes_and_absences_sql(cursor, employment_id, start_date, end_date)
        get_random_responsibilities(cursor, employment_id)
        employment_id += 1

if __name__ == "__main__":
    database_host = "localhost"
    database_server = "KAMILF"
    database_name = "Projekt1"
    windows_auth = True

    connection = pyodbc.connect(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={database_server};"
        f"DATABASE={database_name};"
        f"Trusted_Connection={'yes' if windows_auth else 'no'};"
    )

    cursor = connection.cursor()
    cursor.execute(get_workers_sql())
    for id in range(1, 127):
        create_worker_data(cursor, id)
    connection.commit()