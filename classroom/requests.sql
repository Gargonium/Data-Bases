-- 1. Выбрать всех студентов. Сортировка по имени
select *
from student
order by name;

-- 2. Выбрать студентов у которых номер зачётки (или id) между (N1, N2)
select *
from student
where student_id between 1 and 4;

-- 3.	Выбрать всех студентов с фамилией, начинающейся с "A*".
select *
from student
where surname like 'A%';

-- 4.	Список студентов в группе.
select s.*
from student s
         join "group" g on s.group_id = g.group_id
where g.group_id = 5;

-- 5.	Список всех студентов у преподавателя.
select s.*
from student s
         join "group" g on s.group_id = g.group_id
         join teaching t on g.group_id = t.group_id
where t.teacher_id = 2;

-- 6.	Посчитать кол-во студентов у преподавателя.
select count(s.student_id) as num_students
from student s
         join "group" g on s.group_id = g.group_id
         join teaching t on g.group_id = t.group_id
where t.teacher_id = 2;

-- 7.	Найти группы, в которых нет старосты.
select g.*
from "group" g
         left join leaders l on g.group_id = l.group_id
where l.student_id is null;

-- 8.	Вывести ФИО преподавателя и кол-во студентов, у которого больше всего студентов.
select t.teacher_id, t.name, t.surname, count(s.student_id) as num_students
from teacher t
         join teaching p on t.teacher_id = p.teacher_id
         join "group" g on p.group_id = g.group_id
         join student s on g.group_id = s.group_id
group by t.teacher_id, t.name, t.surname
order by num_students desc
limit 1;

-- 9.	Посчитать количество студентов-однофамильцев. Вывести фамилию и кол-во. (Вывести однофамильцев).
select surname, count(*)
from student
group by surname
having count(*) > 1;

-- 10.	Вывести группы, в которых больше всего студентов.
select g.group_name, count(s.student_id) as num_students
from "group" g
         join student s on g.group_id = s.group_id
group by g.group_id, g.group_name
order by num_students desc;

