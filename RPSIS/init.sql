-- Тип бригады. Локомотивная, бригада техников и тд
create table brigade_types
(
    id        serial primary key,
    type_name varchar(255) not null
);

-- Бригады
create table brigades
(
    id             serial primary key,
    brigade_number int                                                 not null,
    brigade_type   int references brigade_types (id) on delete cascade not null
);

-- Отделы
create table departments
(
    id              serial primary key,
    department_name varchar(255) not null
);

create table professions
(
    id              serial primary key,
    profession_name varchar(255) not null
);

create table professions_attributes
(
    id             serial primary key,
    profession_id  int references professions (id) on delete cascade not null,
    attribute_name varchar(255)                                      not null,
    data_type      varchar(255)                                      not null
);

-- Сотрудники
create table employee
(
    id                 serial primary key,
    full_name          varchar(255) not null,
    department_id      int          references departments (id) on delete set null, -- Отдел к которому он привязан
    brigade_id         int          references brigades (id) on delete set null,    -- Бригада в которой он состоит
    date_of_employment date         not null,                                       -- Дата приёма на работу
    date_of_dismissal  date default null                                            -- Дата увольнения
);

create table employee_professions
(
    id               serial primary key,
    employee_id      int references employee (id) on delete cascade    not null,
    profession_id    int references professions (id) on delete cascade not null,
    appointment_date date                                              not null
);

create table attributes_values
(
    id                      serial primary key,
    employee_id             int references employee (id) on delete cascade               not null,
    profession_attribute_id int references professions_attributes (id) on delete cascade not null,
    value                   text
);


create table departments_headmasters
(
    department_id int references departments (id),
    headmaster_id int references employee (id),
    primary key (department_id, headmaster_id)
);

-- Локомотивы
create table locomotives
(
    id                    serial primary key,
    locomotive_number     varchar(255) not null,
    locomotive_brigade_id int          references brigades (id) on delete set null
);

create table locomotive_tech_brigades
(
    locomotive_id int references locomotives (id) on delete cascade,
    brigade_id    int references brigades (id) on delete cascade,
    primary key (locomotive_id, brigade_id),
    unique (locomotive_id)
);

-- График техосмотров
create table inspection_schedule
(
    id              serial primary key,
    inspection_date date not null
);

-- Проведённое техобслуживание (техосмотр, ремонт и тп)
create table tech_maintenance
(
    id                     serial primary key,
    maintenance_date       date not null,
    description            text not null,
    inspection_schedule_id int  references inspection_schedule (id) on delete set null
);

-- Свзяь локомотивом и проведённым техобслуживанием
create table locomotives_tech_maintenance
(
    locomotive_id int references locomotives (id),
    tech_id       int references tech_maintenance (id),
    primary key (locomotive_id, tech_id)
);

create table med_check
(
    id             serial primary key,
    employee_id    int references employee (id) on delete cascade not null,
    med_check_date date                                           not null,
    status         varchar(255)                                   not null
);

create table train_types
(
    id         serial primary key,
    train_type varchar(255) not null
);

create table route_types
(
    id          serial primary key,
    description text not null
);

create table routes
(
    id              serial primary key,
    departure_point varchar(255)                                      not null,
    arrival_point   varchar(255)                                      not null,
    route_type      int references route_types (id) on delete cascade not null,
    main_points     text[]                                            not null
);

create table train_schedule
(
    id             serial primary key,
    train_id       int references locomotives (id) on delete cascade not null,
    departure_time timestamp                                         not null,
    arrival_time   timestamp                                         not null,
    route_id       int references routes (id) on delete cascade      not null,
    train_type_id  int references train_types (id) on delete cascade not null,
    ticket_price   int                                               not null check ( ticket_price >= 0 )
);

create table passengers
(
    id        serial primary key,
    full_name varchar(255) not null,
    age       int          not null
);

create table ticket_offices
(
    id                   serial primary key,
    ticket_office_number int not null
);

create table ticket_statuses
(
    id          serial primary key,
    description text not null
);

create table tickets
(
    id               serial primary key,
    train_id         int references locomotives (id) on delete cascade not null,
    passenger_id     int references passengers (id) on delete cascade  not null,
    ticket_office_id int                                               references ticket_offices (id) on delete set null,
    purchase_date    timestamp,
    status           int                                               references ticket_statuses (id) on delete set null -- Куплен, забронирован, возвращён и тд
);

create table luggage
(
    id           serial primary key,
    passenger_id int references passengers (id) on delete cascade not null
);

create table ticket_refunds
(
    id          serial primary key,
    ticket_id   int references tickets (id) on delete cascade not null,
    refund_date timestamp                                     not null
);

create table delay_reasons
(
    id          serial primary key,
    description text not null
);

create table train_delays
(
    id                serial primary key,
    train_schedule_id int references train_schedule (id) on delete cascade not null,
    delay_reason_id   int                                                  references delay_reasons on delete set null,
    delay             time                                                 not null
);

