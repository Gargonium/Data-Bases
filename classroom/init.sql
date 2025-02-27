create table "group"
(
    group_id   int primary key generated by default as identity,
    group_name varchar(50) not null unique
);

create table Student
(
    student_id int primary key generated by default as identity,
    name       varchar(100) not null,
    surname    varchar(100) not null,
    birth_date date         not null,
    group_id   int          not null references "group" (group_id)
);

create table leaders
(
    student_id int not null references "group" (group_id),
    group_id   int not null references Student (student_id),
    primary key (student_id, group_id)
);

create table Subject
(
    subject_id   int primary key generated by default as identity,
    subject_name varchar(100) not null unique
);

create table Teacher
(
    teacher_id int primary key generated by default as identity,
    name       varchar(100) not null,
    surname    varchar(100) not null
);

create table Teaching
(
    teacher_id int not null references Teacher (teacher_id),
    subject_id int not null references Subject (subject_id),
    group_id   int not null references "group" (group_id),
    primary key (teacher_id, subject_id, group_id)
);
