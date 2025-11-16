-- WE ARE USING POSTGRESQL SYNTAX HERE
CREATE TABLE company (
    company_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nip VARCHAR(10) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE
);

CREATE TABLE position (
    position_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE CASCADE
);

CREATE TABLE responsibility (
    responsibility_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL
);

CREATE TABLE responsibility_position (
    responsibility_id INT NOT NULL,
    position_id INT NOT NULL,
    PRIMARY KEY (responsibility_id, position_id),
    FOREIGN KEY (responsibility_id) REFERENCES responsibility(responsibility_id) ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES position(position_id) ON DELETE CASCADE
);

CREATE TABLE worker (
    worker_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    pesel VARCHAR(11) NOT NULL UNIQUE,
    login VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employment_type (
    employment_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE employment (
    employment_id SERIAL PRIMARY KEY,
    worker_id INT NOT NULL,
    position_id INT NOT NULL,
    employment_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    FOREIGN KEY (worker_id) REFERENCES worker(worker_id) ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES position(position_id) ON DELETE CASCADE,
    FOREIGN KEY (employment_type_id) REFERENCES employment_type(employment_type_id) ON DELETE CASCADE
);

CREATE TABLE responsibility_employment (
    responsibility_id INT NOT NULL,
    employment_id INT NOT NULL,
    PRIMARY KEY (responsibility_id, employment_id),
    FOREIGN KEY (responsibility_id) REFERENCES responsibility(responsibility_id) ON DELETE CASCADE,
    FOREIGN KEY (employment_id) REFERENCES employment(employment_id) ON DELETE CASCADE
);

CREATE TABLE partner (
    partner_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nip VARCHAR(10) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE facture (
    facture_id SERIAL PRIMARY KEY,
    partner_id INT NOT NULL,
    company_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255) NULL,
    date DATE NOT NULL,
    FOREIGN KEY (partner_id) REFERENCES partner(partner_id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE
);

CREATE TABLE worktime_type (
    worktime_type_id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL
);

CREATE TABLE worktime (
    worktime_id SERIAL PRIMARY KEY,
    employment_id INT NOT NULL,
    worktime_type_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    FOREIGN KEY (employment_id) REFERENCES employment(employment_id) ON DELETE CASCADE,
    FOREIGN KEY (worktime_type_id) REFERENCES worktime_type(worktime_type_id) ON DELETE CASCADE
);

CREATE TABLE absence_type (
    absence_type_id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL
);

CREATE TABLE holiday_request (
    holiday_request_id SERIAL PRIMARY KEY,
    employment_id INT NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    reason VARCHAR(255) NULL,
    justification VARCHAR(255) NULL,
    absence_start DATE NOT NULL,
    absence_end DATE NOT NULL,
    FOREIGN KEY (employment_id) REFERENCES employment(employment_id) ON DELETE CASCADE
);

CREATE TABLE absence (
    absence_id SERIAL PRIMARY KEY,
    employment_id INT NOT NULL,
    absence_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    holiday_request_id INT NULL,
    FOREIGN KEY (employment_id) REFERENCES employment(employment_id) ON DELETE CASCADE,
    FOREIGN KEY (absence_type_id) REFERENCES absence_type(absence_type_id) ON DELETE CASCADE,
    FOREIGN KEY (holiday_request_id) REFERENCES holiday_request(holiday_request_id) ON DELETE SET NULL
);