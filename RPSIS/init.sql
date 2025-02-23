create table departments
(
    id   serial primary key,
    name text unique not null
);

create table brigades
(
    id            serial primary key,
    department_id int references departments (id) on delete cascade
);

create table employees
(
    id                 serial primary key,
    name               text not null,
    position           text not null,
    department_id      int  references departments (id) on delete set null,
    brigade_id         int  references brigades (id) on delete set null,
    medical_check_date date
);

create table locomotives
(
    id                   serial primary key,
    model                text not null,
    last_inspection_date date not null
);

create table locomotive_brigades
(
    id            serial primary key,
    locomotive_id int references locomotives (id) on delete cascade,
    brigade_id    int references brigades (id) on delete cascade
);

create table technicians
(
    id          serial primary key,
    employee_id int references employees (id) on delete cascade
);

create table locomotive_maintenance
(
    id               serial primary key,
    locomotive_id    int references locomotives (id) on delete cascade,
    technician_id    int  references technicians (id) on delete set null,
    maintenance_date date not null,
    maintenance_type text not null
);

create table schedules
(
    id             serial primary key,
    train_type     text        not null,
    train_number   text unique not null,
    departure_time timestamp   not null,
    arrival_time   timestamp   not null,
    route          text        not null,
    ticket_price   decimal     not null
);

create table tickets
(
    id             serial primary key,
    schedule_id    int references schedules (id) on delete cascade,
    passenger_name text                                                       not null,
    status         text check (status in ('booked', 'purchased', 'returned')) not null
);

create table baggage
(
    id             serial primary key,
    passenger_name text    not null,
    baggage_weight decimal not null,
    schedule_id    int     references schedules (id) on delete set null
);

create table delays
(
    id          serial primary key,
    schedule_id int references schedules (id) on delete cascade,
    reason      text     not null,
    delay_time  interval not null
);
