-- 1.	Найти всех С++ программистов работающих у менеджера Иванов Петр Сергеевич. Данные вывести в формате: полное имя программиста. Отсортировать по фамилии, имени, отчеству.
select concat(p.surname, ' ', p.name, ' ', p.patronymic) as "Программист"
from programmer p
         join assignment a on p.id = a.programmer_id
         join task t on a.task_id = t.id
         join project pr on t.parent_project_id = pr.id
         join manager m on pr.project_manager_id = m.id
where p.specialization = 'С++'
  and m.surname = 'Иванов'
  and m.name = 'Петр'
  and m.patronymic = 'Сергеевич'
order by p.surname, p.name, p.patronymic;

-- 2.	Вывести список всех задач программиста Сидоров Павел Семенович на 20.12.2002 число, с указанием проекта, к которому относится задача и загруженности данного программиста по каждой задаче в процентах. Данные вывести в формате: название проекта, название задачи, загруженность. Отсортировать по имени проекта, имени задачи, загруженности по убыванию.
select pr.project_name as "Название проекта",
       t.task_name     as "Название задачи",
       a.workload      as "Загруженность (в %)"
from programmer p
         join assignment a on p.id = a.programmer_id
         join task t on a.task_id = t.id
         join project pr on t.parent_project_id = pr.id
where p.surname = 'Сидоров'
  and p.name = 'Павел'
  and p.patronymic = 'Семенович'
  and t.start_date <= '2002-12-20'
  and t.end_date >= '2002-12-20'
order by pr.project_name, t.task_name, a.workload desc;

-- 3.	Найти все законченные проекты, выполненные под руководством менеджера Оракулов Николай Иванович за 2002 год. Проект считать законченным, если все его задачи выполнены на 100%. Данные вывести в формате: имя проекта, запланированное начало проекта, запланированное окончание проекта, запланированная продолжительность в часах, фактически потраченное время на данный проект в часах (по задачам). Отсортировать по запланированной продолжительности проекта в часах, по убыванию.
select pr.project_name       as "Имя проекта",
       pr.planned_start_date as "Запланированное начало проекта",
       pr.planned_end_date   as "Запланированное окончание проекта",
       extract(epoch from (pr.planned_end_date::timestamp - pr.planned_start_date::timestamp)) /
       3600                  as "Запланированная продолжительность (в часах)",
       sum(extract(epoch from (t.end_date::timestamp - t.start_date::timestamp)) /
           3600)             as "Фактически потраченное время (в часах)"
from project pr
         join manager m on m.id = pr.project_manager_id
         join task t on pr.id = t.parent_project_id
where m.surname = 'Оракулов'
  and m.name = 'Николай'
  and m.patronymic = 'Иванович'
  and pr.planned_end_date between '2002-01-01' and '2002-12-31'
group by pr.id, pr.project_name, pr.planned_start_date, pr.planned_end_date
having count(*) = sum(case when t.completion_percentage = 100 then 1 else 0 end)
order by "Запланированная продолжительность (в часах)" desc;

-- 4.	Вывести сводную информацию по компании о всех проектах. Данные вывести в формате: имя проекта, запланированный объем в часах, полное имя ответственного менеджера, количество занятых программистов в проекте. Отсортировать по названию проекта.
select pr.project_name                                   as "Название проекта",
       extract(epoch from (pr.planned_end_date::timestamp - pr.planned_start_date::timestamp)) /
       3600                                              as "Запланированный объём (в часах)",
       concat(m.surname, ' ', m.name, ' ', m.patronymic) as "Ответственный менеджер",
       count(distinct a.programmer_id)                   as "Количество занятых программистов"
from project pr
         join manager m on m.id = pr.project_manager_id
         left join task t on pr.id = t.parent_project_id
         left join assignment a on t.id = a.task_id
group by pr.id, pr.project_name, "Запланированный объём (в часах)", "Ответственный менеджер"
order by pr.project_name;

-- 5.	Перевести все проекты, у которых истекла на момент 31.12.2003, запланированная дата окончания в состояние – окончен (то есть выставить процент завершенности в 100% для всех задач данных проектов).
update task
set completion_percentage = 100
where parent_project_id in (select id
                            from project
                            where planned_end_date <= '2003-12-31');