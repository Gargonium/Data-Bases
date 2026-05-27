-- 1.  Проверка согласованности зала, к которому прикреплён сотрудник и библиотеки

create or replace function check_employee_room_library()
    returns trigger as
$$
begin
    if (select library_id from reading_rooms where id = new.reading_room_id)
        <> new.library_id then
        raise exception 'Читальный зал % не принадлежит библиотеке %',
            new.reading_room_id, new.library_id;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_employee_room_library
    before insert or update
    on employee
    for each row
execute function check_employee_room_library();

-- 2. Если у книги стоит "только для читального зала", то её нельзя выдать на дом

create or replace function prevent_loans_reading_room_only()
    returns trigger as
$$
begin
    if exists (select 1
               from publication_rules pr
               where pr.publication_id = (select publication_id
                                          from publications_copy
                                          where inventory_number = new.copy_inventory_number)
                 and pr.reading_room_only = true) then
        raise exception 'Экземпляр % предназначен только для читального зала',
            new.copy_inventory_number;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_loans_reading_room_only
    before insert
    on loans
    for each row
execute function prevent_loans_reading_room_only();


-- Чтобы протестировать выполни select, и вставь результат в copy_inventory_number
-- select inventory_number from publications_copy where publication_id = (select publication_id from publication_rules where reading_room_only = true);
--
-- insert into loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
-- values (1, 1001, '2024-12-18', null, null, 1);


-- 3. Если не указать дату возврата книги, то установится автоматически
create or replace function set_loan_expire_date()
    returns trigger as
$$
declare
    v_loan_period int;
    v_room_only   boolean;
begin
    select pr.loan_period_days, pr.reading_room_only
    into v_loan_period, v_room_only
    from publication_rules pr
             join publications_copy pc on pc.publication_id = pr.publication_id
    where pc.inventory_number = new.copy_inventory_number;

    if v_room_only then
        raise exception 'Внутренняя ошибка: попытка выдать зальное издание.';
    end if;

    if v_loan_period is null then
        raise exception 'Для издания не задан срок выдачи.';
    end if;

    new.expire_date := new.date_of_issue + v_loan_period;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_loans_set_expire_date
    before insert
    on loans
    for each row
    when (new.expire_date is null)
execute function set_loan_expire_date();

-- 4. Нельзя выдать то, что у же выдано
-- На руки
create or replace function check_no_active_loan()
    returns trigger as
$$
begin
    if exists (select 1
               from loans
               where copy_inventory_number = new.copy_inventory_number
                 and return_date is null
                 and id <> coalesce(new.id, -1)) then
        raise exception 'Экземпляр % уже находится на руках', new.copy_inventory_number;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_loans_no_active
    before insert or update
    on loans
    for each row
execute function check_no_active_loan();

-- Test
-- select copy_inventory_number from loans where return_date is null;
-- insert into loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
-- values (1, 100038, '2024-12-18', null, null, 1);


-- В зал
create or replace function check_no_active_reading()
    returns trigger as
$$
begin
    if exists (select 1
               from reading_process
               where copy_inventory_number = new.copy_inventory_number
                 and return_date is null
                 and id <> coalesce(new.id, -1)) then
        raise exception 'Экземпляр % сейчас читают в зале', new.copy_inventory_number;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_reading_process_no_active
    before insert or update
    on reading_process
    for each row
execute function check_no_active_reading();

-- Test

-- select copy_inventory_number from reading_process where return_date is null;
-- insert into reading_process (reader_id, copy_inventory_number, issued_employee_id, library_id, reading_room_id, issued_time, return_date, return_time)
-- values (1, 100072, 1, 1, 1,  '11:21:21',null, null);

-- 5. При списывании книги, удаляем запись о ней в основном фонде
create or replace function write_off_copy()
    returns trigger as
$$
declare
    v_inv_int int;
    v_pub_id  int;
begin
    begin
        v_inv_int := new.inventory_number::int;
    exception
        when others then
            raise exception 'Инвентарный номер должен быть целым числом';
    end;

    select publication_id
    into v_pub_id
    from publications_copy
    where inventory_number = v_inv_int;

    if not found then
        raise exception 'Экземпляр % не найден в фонде', new.inventory_number;
    end if;

    if v_pub_id <> new.publication_id then
        raise exception 'Не совпадает publication_id для экземпляра %', new.inventory_number;
    end if;

    if exists (select 1 from loans where copy_inventory_number = v_inv_int and return_date is null) then
        raise exception 'Нельзя списать экземпляр % – он на руках', new.inventory_number;
    end if;
    if exists (select 1 from reading_process where copy_inventory_number = v_inv_int and return_date is null) then
        raise exception 'Нельзя списать экземпляр % – он в читальном зале', new.inventory_number;
    end if;

    delete from publications_copy where inventory_number = v_inv_int;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_written_off_process
    before insert
    on written_off
    for each row
execute function write_off_copy();

-- Test

-- insert into publications_copy (inventory_number, publication_id, shelf_id, receipt_date, received_employee_id)
-- values ('9999', 1, 1, '2025-04-03', 1);
--
-- insert into written_off (inventory_number, publication_id, write_off_date, write_off_employee_id)
-- values ('9999', 1, '2026-05-06', 1);
--
-- delete from written_off where inventory_number = '9999';

-- 6. Функция проверки доступности экземпляра по инвертарному номеру
create or replace function is_copy_available(p_inv_number int)
    returns boolean as $$
begin
    if not exists (
        select 1 from publications_copy
        where inventory_number = p_inv_number
    ) then
        return false;
    end if;

    return not exists (
        select 1 from loans
        where copy_inventory_number = p_inv_number and return_date is null
        union all
        select 1 from reading_process
        where copy_inventory_number = p_inv_number and return_date is null
    );
end;
$$ language plpgsql;

-- Test
-- select is_copy_available(100057);

