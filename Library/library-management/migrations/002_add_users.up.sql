-- Создаём таблицу пользователей для аутентификации
create table if not exists users (
                                     id serial primary key,
                                     login varchar(100) unique not null,
    password_hash varchar(255) not null,
    role varchar(50) not null check (role in ('admin', 'librarian', 'reader')),
    reader_id int references readers(id) on delete cascade,
    employee_id int references employee(id) on delete cascade,
    created_at timestamp default now()
    );

-- Добавляем уникальность: у пользователя может быть либо reader_id, либо employee_id, но не оба сразу
alter table users add constraint check_user_type check (
    (reader_id is null and employee_id is not null) or
    (reader_id is not null and employee_id is null) or
    (role = 'admin' and reader_id is null and employee_id is null)
    );