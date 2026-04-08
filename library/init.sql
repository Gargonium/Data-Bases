create table libraries
(
    id      serial primary key,
    name    varchar(255) not null,
    address varchar(255) not null
);

create table reading_rooms
(
    id         serial primary key,
    library_id int not null references libraries (id) on delete restrict
);

create table storages
(
    id         serial primary key,
    library_id int not null references libraries (id) on delete restrict
);

create table racks
(
    id         serial primary key,
    storage_id int not null references storages (id) on delete restrict
);

create table shelves
(
    id      serial primary key,
    rack_id int not null references racks (id) on delete restrict
);

create table reader_categories
(
    id   serial primary key,
    name varchar(255) not null unique
);

create table readers
(
    id                serial primary key,
    category_id       int          not null references reader_categories (id),
    unique (id, category_id),
    library_id        int          not null references libraries (id) on delete restrict,
    first_name        varchar(255) not null,
    last_name         varchar(255) not null,
    registration_date date         not null default current_date
);

create table reader_category_attributes
(
    id          serial primary key,
    category_id int          not null references reader_categories (id) on delete cascade,
    unique (id, category_id),
    name        varchar(255) not null
);

create table reader_category_attribute_values
(
    reader_id    int          not null,
    category_id  int          not null,
    attribute_id int          not null,
    value        varchar(255) not null,
    primary key (reader_id, attribute_id),
    foreign key (reader_id, category_id) references readers (id, category_id),
    foreign key (attribute_id, category_id) references reader_category_attributes (id, category_id)
);

create table work_categories
(
    id   serial primary key,
    name varchar(255) not null unique
);

create table authors
(
    id         serial primary key,
    first_name varchar(255),
    last_name  varchar(255) not null
);

create table works
(
    id          serial primary key,
    title       varchar(255) not null,
    category_id int          not null references work_categories (id) on delete restrict,
    unique (id, category_id),
    author      int          not null references authors (id) on delete restrict
);

create table work_category_attributes
(
    id          serial primary key,
    category_id int          not null references work_categories (id) on delete cascade,
    unique (id, category_id),
    name        varchar(255) not null
);

create table work_category_attribute_values
(
    work_id      int          not null,
    category_id  int          not null,
    attribute_id int          not null,
    value        varchar(255) not null,
    primary key (work_id, attribute_id),
    foreign key (work_id, category_id) references works (id, category_id),
    foreign key (attribute_id, category_id) references work_category_attributes (id, category_id)
);

create table publications
(
    id           serial primary key,
    title        varchar(255) not null,
    publish_date date         not null,
    publisher    varchar(255) not null
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

create table employee
(
    id              serial primary key,
    library_id      int          not null references libraries (id) on delete restrict,
    reading_room_id int          not null references reading_rooms (id) on delete restrict,
    first_name      varchar(255) not null,
    last_name       varchar(255) not null
);

create table publications_copy
(
    inventory_number     int  not null unique primary key,
    publication_id       int  not null references publications (id) on delete restrict,
    shelf_id             int  not null references shelves (id) on delete restrict,
    receipt_date         date not null,
    received_employee_id int  not null references employee (id) on delete restrict
);

create table written_off
(
    id                    serial primary key,
    inventory_number      varchar(255) not null unique,
    publication_id        int          not null references publications (id) on delete restrict,
    write_off_date        date         not null,
    write_off_employee_id int          not null references employee (id)
);

create table loans
(
    id                    serial primary key,
    reader_id             int  not null references readers (id) on delete restrict,
    copy_inventory_number int  not null references publications_copy (inventory_number) on delete restrict,
    date_of_issue         date not null,
    return_date           date not null check ( return_date > loans.date_of_issue ),
    expire_date           date not null check ( expire_date > loans.date_of_issue ),
    issued_employee_id    int  not null references employee (id) on delete restrict
);

create table reading_process
(
    id                    serial primary key,
    reader_id             int       not null references readers (id) on delete cascade,
    copy_inventory_number int       not null references publications_copy (inventory_number) on delete cascade,
    issued_employee_id    int       not null references employee (id) on delete cascade,
    library_id            int       not null references libraries (id) on delete cascade,
    reading_room_id       int       not null references reading_rooms (id) on delete cascade,
    issued_date           date      not null default current_date,
    issued_time           time not null,
    return_date           date      null,
    return_time           time not null check ( return_time > reading_process.issued_time )
);