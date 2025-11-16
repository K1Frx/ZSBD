import pyodbc
import pandas as pd

databases_migration_config = {
    "tables": [
        {
            "source_table": "Company",
            "destination_table": "company",
            "columns_mapping": {
                "CompanyID": "company_id",
                "Name": "name",
                "NIP": "nip",
                "Address": "address"
            }
        },
        {
            "source_table": "Department",
            "destination_table": "department",
            "columns_mapping": {
                "DepartmentID": "department_id",
                "Name": "name",
                "CompanyID": "company_id"
            }
        },
        {
            "source_table": "Position",
            "destination_table": "position",
            "columns_mapping": {
                "PositionID": "position_id",
                "Name": "name",
                "Description": "description",
                "DepartmentID": "department_id"
            }
        },
        {
            "source_table": "Responsibility",
            "destination_table": "responsibility",
            "columns_mapping": {
                "ResponsibilityID": "responsibility_id",
                "Name": "name",
                "Description": "description"
            }
        },
        {
            "source_table": "ResponsibilityPosition",
            "destination_table": "responsibility_position",
            "columns_mapping": {
                "ResponsibilityID": "responsibility_id",
                "PositionID": "position_id"
            }
        },
        {
            "source_table": "Worker",
            "destination_table": "worker",
            "columns_mapping": {
                "WorkerID": "worker_id",
                "FirstName": "first_name",
                "LastName": "last_name",
                "Pesel": "pesel",
                "Login": "login"
            }
        },
        {
            "source_table": "EmploymentType",
            "destination_table": "employment_type",
            "columns_mapping": {
                "EmploymentTypeID": "employment_type_id",
                "Type": "name",
                "Description": "description"
            }
        },
        {
            "source_table": "Employment",
            "destination_table": "employment",
            "columns_mapping": {
                "EmploymentID": "employment_id",
                "WorkerID": "worker_id",
                "PositionID": "position_id",
                "EmploymentTypeID": "employment_type_id",
                "StartDate": "start_date",
                "EndDate": "end_date"
            }
        },
        {
            "source_table": "ResponsibilityEmployment",
            "destination_table": "responsibility_employment",
            "columns_mapping": {
                "ResponsibilityID": "responsibility_id",
                "EmploymentID": "employment_id"
            }
        },
        {
            "source_table": "Partner",
            "destination_table": "partner",
            "columns_mapping": {
                "PartnerID": "partner_id",
                "Name": "name",
                "NIP": "nip",
                "Address": "address"
            }
        },
        {
            "source_table": "Facture",
            "destination_table": "facture",
            "columns_mapping": {
                "FactureID": "facture_id",
                "PartnerID": "partner_id",
                "CompanyID": "company_id",
                "Amount": "amount",
                "Description": "description",
                "Date": "date"
            }
        },
        {
            "source_table": "WorktimeType",
            "destination_table": "worktime_type",
            "columns_mapping": {
                "WorktimeTypeID": "worktime_type_id",
                "Type": "type"
            }
        },
        {
            "source_table": "Worktime",
            "destination_table": "worktime",
            "columns_mapping": {
                "WorktimeID": "worktime_id",
                "EmploymentID": "employment_id",
                "WorktimeTypeID": "worktime_type_id",
                "Date": "date",
                "Time": "time"
            }
        },
        {
            "source_table": "AbsenceType",
            "destination_table": "absence_type",
            "columns_mapping": {
                "AbsenceTypeID": "absence_type_id",
                "Type": "type"
            }
        },
        {
            "source_table": "HolidayRequest",
            "destination_table": "holiday_request",
            "columns_mapping": {
                "HolidayRequestID": "holiday_request_id",
                "EmploymentID": "employment_id",
                "Status": "status",
                "Reason": "reason",
                "Justification": "justification",
                "AbsenceStart": "absence_start",
                "AbsenceEnd": "absence_end"
            }
        },
        {
            "source_table": "Absence",
            "destination_table": "absence",
            "columns_mapping": {
                "AbsenceID": "absence_id",
                "EmploymentID": "employment_id",
                "AbsenceTypeID": "absence_type_id",
                "StartDate": "start_date",
                "EndDate": "end_date",
                "HolidayRequestID": "holiday_request_id"
            }
        }
    ]
}

mssql_database_host = "localhost"
mssql_database_server = "KAMILF"
mssql_database_name = "Projekt1"
windows_auth = True

mssql_connection = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={mssql_database_server};"
    f"DATABASE={mssql_database_name};"
    f"Trusted_Connection={'yes' if windows_auth else 'no'};"
)


postgres_database_host = "localhost"
postgres_database_port = 5432
postgres_database_name = "Projekt1"
postgres_database_user = "postgres"
postgres_database_password = "Admin123!"
postgres_connection = f"postgresql://{postgres_database_user}:{postgres_database_password}@{postgres_database_host}:{postgres_database_port}/{postgres_database_name}"

for table_config in databases_migration_config["tables"]:
    source_table = table_config["source_table"]
    query = f"SELECT * FROM {source_table}"
    source_data = pd.read_sql(query, mssql_connection)
    df = pd.DataFrame(source_data)
    df.rename(columns=table_config["columns_mapping"], inplace=True)
    
    destination_table = table_config["destination_table"]
    df.to_sql(destination_table, postgres_connection, if_exists='append', index=False)
    print(f"Data migrated for table: {source_table} to {destination_table}")
