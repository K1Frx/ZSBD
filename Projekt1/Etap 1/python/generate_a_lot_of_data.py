import pyodbc
import random

def generate_worktime(cursor):
    employment_id = 333
    worktime_type_id = random.randint(1, 3)
    date = f"2022-{random.randint(1, 12):02}-{random.randint(1, 28):02}"
    work_hours = random.randint(6, 10)
    work_minutes = random.choice([0, 15, 30, 45])

    cursor.execute(f"""
    INSERT INTO Worktime(EmploymentID, WorktimeTypeID, Date, Time)
    VALUES ({employment_id}, {worktime_type_id}, '{date}', '{work_hours:02}:{work_minutes:02}')
    """)

def generate_absence(cursor):
    employment_id = 333
    absence_type_id = random.randint(1, 5)
    start_date = f"2022-{random.randint(1, 12):02}-{random.randint(1, 28):02}"
    end_date = start_date
    cursor.execute(f"""
    INSERT INTO Absence(EmploymentID, AbsenceTypeID, StartDate, EndDate)
    VALUES ({employment_id}, {absence_type_id}, '{start_date}', '{end_date}')
    """)

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
    for _ in range(10000):
        generate_worktime(cursor)
        generate_absence(cursor)

    connection.commit()
