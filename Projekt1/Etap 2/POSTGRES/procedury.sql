CREATE OR REPLACE PROCEDURE usp_add_new_worker(
    p_first_name VARCHAR(255),
    p_last_name VARCHAR(255),
    p_pesel VARCHAR(11),
    p_login VARCHAR(100),
    OUT new_worker_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- WALIDACJA DANYCH

    -- Sprawdzenie czy PESEL już istnieje
    IF EXISTS (SELECT 1 FROM worker WHERE pesel = p_pesel) THEN
        RAISE EXCEPTION 'Błąd: Pracownik o PESEL [%] już istnieje w tabeli Worker.', p_pesel;
    END IF;

    -- Sprawdzenie długości PESEL
    IF char_length(COALESCE(p_pesel, '')) != 11 THEN
        RAISE EXCEPTION 'Błąd: PESEL musi mieć dokładnie 11 znaków.';
    END IF;

    -- Sprawdzenie czy Login już istnieje
    IF EXISTS (SELECT 1 FROM worker WHERE login = p_login) THEN
        RAISE EXCEPTION 'Błąd: Login [%] jest już przypisany do innego pracownika.', p_login;
    END IF;

    -- Sprawdzenie pustych wartości
    IF COALESCE(p_first_name, '') = '' OR COALESCE(p_last_name, '') = '' THEN
        RAISE EXCEPTION 'Błąd: Imię i nazwisko nie mogą być puste.';
    END IF;

    -- Rozpoczęcie transakcji
    BEGIN
        INSERT INTO worker (first_name, last_name, pesel, login)
        VALUES (p_first_name, p_last_name, p_pesel, p_login)
        RETURNING worker_id INTO new_worker_id;

        RAISE NOTICE 'Sukces: Cała operacja zakończona pomyślnie.';
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Błąd: Transakcja wycofana. %', SQLERRM;
    END;
END;
$$;





CREATE OR REPLACE PROCEDURE usp_approve_holiday_request(p_holiday_request_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    target_employment_id INT;
    target_start_date DATE;
    target_end_date DATE;
    current_status VARCHAR(50);
    vacation_absence_type_id INT := 2;
BEGIN
    -- Pobranie i zablokowanie wiersza wniosku urlopowego
    SELECT employment_id, absence_start, absence_end, status
    INTO target_employment_id, target_start_date, target_end_date, current_status
    FROM holiday_request
    WHERE holiday_request_id = p_holiday_request_id
    FOR UPDATE;

    -- Sprawdzenie, czy wniosek istnieje
    IF target_employment_id IS NULL THEN
        RAISE EXCEPTION 'Błąd: Wniosek urlopowy o ID [%] nie istnieje.', p_holiday_request_id;
    END IF;

    -- Sprawdzenie statusu wniosku
    IF current_status != 'Pending' THEN
        RAISE EXCEPTION 'Błąd: Wniosek nie jest w stanie "Pending". Obecny status: %', current_status;
    END IF;

    -- Sprawdzenie konfliktu z innymi nieobecnościami
    IF EXISTS (
        SELECT 1
        FROM absence
        WHERE employment_id = target_employment_id
          AND start_date <= target_end_date
          AND end_date >= target_start_date
    ) THEN
        RAISE EXCEPTION 'Błąd: Pracownik ma już inną zarejestrowaną nieobecność w tym terminie.';
    END IF;

    -- Rozpoczęcie transakcji
    BEGIN
        -- Aktualizacja statusu wniosku urlopowego
        UPDATE holiday_request
        SET status = 'Approved'
        WHERE holiday_request_id = p_holiday_request_id;

        -- Dodanie nowej nieobecności
        INSERT INTO absence (
            employment_id,
            absence_type_id,
            holiday_request_id,
            start_date,
            end_date
        )
        VALUES (
            target_employment_id,
            vacation_absence_type_id,
            p_holiday_request_id,
            target_start_date,
            target_end_date
        );

        RAISE NOTICE 'Sukces: Wniosek został zatwierdzony i utworzono nieobecność.';
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Błąd: Transakcja wycofana. %', SQLERRM;
    END;
END;
$$;