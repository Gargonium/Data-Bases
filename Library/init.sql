create table libraries
(
    id      serial primary key,
    name    varchar(255) not null,
    address varchar(255) not null
);

create type hall_type_T as enum ('abonnement', 'reading_room');

create table halls
(
    id         serial primary key,
    library_id int          not null references libraries (id) on delete cascade,
    hall_type  hall_type_T  not null,
    name       varchar(255) not null
);

create table reader_categories
(
    id   serial primary key,
    name varchar(255) not null unique
);

create table readers
(
    id                serial primary key,
    category_id       int          not null references reader_categories (id) on delete restrict,
    library_id        int          not null references libraries (id) on delete restrict,
    first_name        varchar(255) not null,
    last_name         varchar(255) not null,
    registration_date date         not null default current_date
);

create table reader_category_attributes
(
    id          serial primary key,
    category_id int          not null references reader_categories (id) on delete cascade,
    name        varchar(255) not null
);

create table reader_category_attribute_values
(
    reader_id    int          not null references readers (id) on delete cascade,
    attribute_id int          not null references reader_category_attributes (id) on delete cascade,
    value        varchar(255) not null,
    primary key (reader_id, attribute_id)
);

create table work_categories
(
    id   serial primary key,
    name varchar(255) not null unique
);

create table works
(
    id          serial primary key,
    title       varchar(255) not null,
    category_id int          not null references work_categories (id) on delete restrict
);

create table work_category_attributes
(
    id          serial primary key,
    category_id int          not null references work_categories (id) on delete cascade,
    name        varchar(255) not null
);

create table work_category_attribute_values
(
    work_id      int          not null references works (id) on delete cascade,
    attribute_id int          not null references work_category_attributes (id) on delete cascade,
    value        varchar(255) not null,
    primary key (work_id, attribute_id)
);

create table publications
(
    id serial primary key
);

create table publications_works
(
    publication_id int not null references publications (id) on delete cascade,
    work_id        int not null references works (id) on delete cascade,
    primary key (work_id, publication_id)
);

create table publication_rules
(
    publication_id    int primary key references publications (id) on delete cascade,
    reading_room_only boolean not null default false,
    loan_period_days  int,
    check ((reading_room_only = true and loan_period_days is null) or (reading_room_only = false))
);

create type publications_status_T as enum ('available', 'loaned');

create table publications_copy
(
    id                  serial primary key,
    inventory_number    varchar(255)          not null unique,
    publication_id      int                   not null references publications (id) on delete restrict,
    publications_status publications_status_T not null default 'available',
    library_id          int                   not null references libraries (id) on delete restrict
);

create table loans
(
    id        serial primary key,
    reader_id int not null references readers (id) on delete restrict,
    copy_id   int not null references publications_copy (id) on delete restrict
);

create table employee
(
    id         serial primary key,
    library_id int          not null references libraries (id) on delete restrict,
    first_name varchar(255) not null,
    last_name  varchar(255) not null
);