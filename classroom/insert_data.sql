-- Наполнение таблицы "group" данными
INSERT INTO "group" (group_name)
VALUES ('Group A'),
       ('Group B'),
       ('Group C'),
       ('Group D'),
       ('Group E'),
       ('Group F'),
       ('Group G'),
       ('Group H'),
       ('Group I'),
       ('Group J'),
       ('Group K'),
       ('Group L'),
       ('Group M'),
       ('Group N'),
       ('Group O'),
       ('Group P'),
       ('Group Q'),
       ('Group R'),
       ('Group S'),
       ('Group T'),
       ('Group U'),
       ('Group V'),
       ('Group W'),
       ('Group X'),
       ('Group Y'),
       ('Group Z'),
       ('Group AA'),
       ('Group AB'),
       ('Group AC'),
       ('Group AD');

-- Наполнение таблицы Student данными (случайное распределение по группам)
INSERT INTO Student (name, surname, birth_date, group_id)
VALUES ('Alice', 'Smith', '2000-01-15', 1),
       ('Bob', 'Johnson', '1999-07-23', 2),
       ('Charlie', 'Williams', '2001-03-10', 1),
       ('Diana', 'Brown', '2000-11-05', 3),
       ('Eve', 'Davis', '1998-12-12', 5),
       ('Frank', 'Miller', '2001-05-25', 4),
       ('Grace', 'Wilson', '1999-09-09', 6),
       ('Hank', 'Moore', '2000-08-22', 1),
       ('Ivy', 'Taylor', '2001-02-28', 7),
       ('Jack', 'Anderson', '1999-03-14', 2),
       ('Kate', 'Thomas', '2000-04-04', 2),
       ('Leo', 'Jackson', '2000-05-30', 8),
       ('Mia', 'White', '1999-01-16', 9),
       ('Nick', 'Harris', '2001-07-01', 1),
       ('Olivia', 'Martin', '1998-08-18', 3),
       ('Paul', 'Thompson', '2000-10-10', 4),
       ('Quinn', 'Garcia', '2001-09-09', 1),
       ('Ryan', 'Martinez', '2000-11-30', 5),
       ('Sophia', 'Robinson', '1999-06-20', 6),
       ('Tom', 'Clark', '2000-07-07', 1),
       ('Uma', 'Rodriguez', '2000-08-08', 2),
       ('Vince', 'Lewis', '1998-09-19', 3),
       ('Will', 'Walker', '1999-10-25', 4),
       ('Xena', 'Hall', '2000-03-03', 5),
       ('Yara', 'Allen', '1999-12-12', 5),
       ('Zoe', 'Young', '2000-06-06', 6),
       ('Adam', 'King', '2001-01-21', 7),
       ('Betty', 'Scott', '2000-09-12', 7),
       ('Carl', 'Green', '2001-10-14', 8),
       ('Dora', 'Adams', '2000-05-15', 9),
       ('Ethan', 'Baker', '2000-02-02', 1),
       ('Fiona', 'Hill', '2001-12-12', 1),
       ('George', 'Evans', '1999-11-11', 10),
       ('Helen', 'Brooks', '2001-06-06', 2),
       ('Ian', 'Russell', '1998-10-10', 1),
       ('Jane', 'Wright', '2000-03-03', 10),
       ('Kevin', 'Barnes', '1999-09-09', 11),
       ('Lily', 'Butler', '1998-04-04', 1),
       ('Michael', 'Sanders', '2001-05-05', 12),
       ('Nina', 'Murphy', '2000-08-08', 12),
       ('Owen', 'Cook', '1999-07-07', 2),
       ('Pam', 'Peterson', '2000-01-01', 13),
       ('Quincy', 'Bailey', '2001-11-11', 2),
       ('Ray', 'Reed', '2000-04-04', 14),
       ('Sandy', 'Kelly', '1999-02-02', 15),
       ('Tim', 'Ward', '1998-06-06', 16),
       ('Ursula', 'Price', '1999-05-05', 3),
       ('Victor', 'Howard', '2000-07-07', 1),
       ('Wendy', 'Bell', '2001-09-09', 4),
       ('Xander', 'Jenkins', '2000-11-11', 3),
       ('Ricardo', 'Wilson', '2000-09-12', 16),
       ('Henry', 'Wilson', '1979-08-09', 12),
       ('Avocado', 'Harris', '2001-07-01', 10);

-- Наполнение таблицы leaders данными (случайное распределение лидеров по группам)
INSERT INTO leaders (student_id, group_id)
VALUES (1, 1),
       (2, 2),
       (5, 5),
       (6, 4),
       (14, 3),
       (18, 6),
       (26, 7);

-- Наполнение таблицы Subject данными
INSERT INTO Subject (subject_name)
VALUES ('Mathematics'),
       ('Physics'),
       ('History'),
       ('Chemistry'),
       ('Biology'),
       ('Geography'),
       ('English'),
       ('Literature'),
       ('Computer Science'),
       ('Economics'),
       ('Art'),
       ('Music'),
       ('Physical Education'),
       ('Philosophy'),
       ('Psychology');

-- Наполнение таблицы Teacher данными
INSERT INTO Teacher (name, surname)
VALUES ('John', 'Doe'),
       ('Emma', 'White'),
       ('Michael', 'Green'),
       ('Laura', 'Black'),
       ('David', 'Gray'),
       ('Sarah', 'Brown'),
       ('Tom', 'Jones'),
       ('Anna', 'Moore'),
       ('George', 'Miller'),
       ('Eve', 'Scott');

-- Наполнение таблицы Teaching данными (учителя преподают разные предметы разным группам)
INSERT INTO Teaching (teacher_id, subject_id, group_id)
VALUES (1, 1, 1),   -- John Doe teaches Mathematics to Group A
       (1, 2, 2),   -- John Doe teaches Physics to Group B
       (1, 3, 3),   -- John Doe teaches History to Group C
       (2, 4, 4),   -- Emma White teaches Chemistry to Group D
       (2, 5, 1),   -- Emma White teaches Biology to Group A
       (2, 6, 5),   -- Emma White teaches Geography to Group E
       (3, 7, 6),   -- Michael Green teaches English to Group F
       (3, 8, 7),   -- Michael Green teaches Literature to Group G
       (3, 9, 8),   -- Michael Green teaches Computer Science to Group H
       (4, 10, 1),  -- Laura Black teaches Economics to Group A
       (4, 11, 9),  -- Laura Black teaches Art to Group I
       (4, 12, 10), -- Laura Black teaches Music to Group J
       (5, 13, 2),  -- David Gray teaches Physical Education to Group B
       (6, 14, 3),  -- Sarah Brown teaches Philosophy to Group C
       (6, 15, 4),  -- Sarah Brown teaches Psychology to Group D
       (7, 1, 10),  -- Tom Jones teaches Mathematics to Group J
       (8, 2, 11),  -- Anna Moore teaches Physics to Group K
       (9, 3, 12),  -- George Miller teaches History to Group L
       (10, 4, 1); -- Eve Scott teaches Chemistry to Group A

