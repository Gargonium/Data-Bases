--Сотрудники станции, начальники, по стажу, полу, возрасту, детям, зарплате
SELECT
    e.id,
    e.full_name,
    d.department_name,
    e.date_of_employment,
    e.salary,
    e.gender,
    EXTRACT(YEAR FROM AGE(current_date, e.birthday)) AS age,
    EXTRACT(YEAR FROM AGE(current_date, e.date_of_employment)) AS years_of_service,
    e.children,
    CASE WHEN e.children::int > 0 THEN 'Да' ELSE 'Нет' END AS has_children,
    CASE WHEN dh.headmaster_id IS NOT NULL THEN 'Начальник отдела' ELSE 'Сотрудник' END AS role
FROM employee e
         LEFT JOIN departments d ON d.id = e.department_id
         LEFT JOIN departments_headmasters dh ON e.id = dh.headmaster_id
WHERE (:department_id IS NULL OR e.department_id = :department_id);


--Работники бригады, по отделам, обслуживающих локомотив, по возрасту, зарплате
SELECT
    b.id AS brigade_id,
    d.department_name,
    COUNT(e.id) AS employee_count,
    AVG((av.value)::numeric) FILTER (WHERE pa.attribute_name = 'salary') AS avg_salary,
    AVG((av.value)::numeric) FILTER (WHERE pa.attribute_name = 'age') AS avg_age
FROM brigades b
         JOIN employee e ON b.id = e.brigade_id
         LEFT JOIN departments d ON e.department_id = d.id
         LEFT JOIN employee_professions ep ON e.id = ep.employee_id
         LEFT JOIN professions_attributes pa ON ep.profession_id = pa.profession_id
         LEFT JOIN attributes_values av ON e.id = av.employee_id AND pa.id = av.profession_attribute_id
WHERE b.id IN (
    SELECT brigade_id FROM locomotive_tech_brigades WHERE locomotive_id = :locomotive_id
)
GROUP BY b.id, d.department_name;

--Водители, прошедшие/не прошедшие медосмотр в указанном году
SELECT e.id,
       e.full_name,
       MAX(CASE WHEN pa.attribute_name = 'gender' THEN av.value END)          AS gender,
       MAX(CASE WHEN pa.attribute_name = 'age' THEN av.value END)             AS age,
       MAX(CASE WHEN pa.attribute_name = 'salary' THEN av.value END)::numeric AS salary,
       CASE WHEN mc.status = 'пройден' THEN 'Пройден' ELSE 'Не пройден' END   AS med_status
FROM employee e
         JOIN employee_professions ep ON e.id = ep.employee_id
         JOIN professions p ON ep.profession_id = p.id
         LEFT JOIN med_check mc ON mc.employee_id = e.id AND EXTRACT(YEAR FROM mc.med_check_date) = :year
         LEFT JOIN professions_attributes pa ON pa.profession_id = p.id
         LEFT JOIN attributes_values av ON av.employee_id = e.id AND av.profession_attribute_id = pa.id
WHERE p.profession_name ILIKE 'Машинист'
GROUP BY e.id, mc.status;


--Локомотивы, приписанные к станции, находящиеся на ней в указанное время, по прибытиям, количеству маршрутов
SELECT l.id,
       l.locomotive_number,
       COUNT(ts.id)                                                 AS total_routes,
       MAX(ts.arrival_time) FILTER (WHERE ts.arrival_time <= :time) AS last_arrival_time
FROM locomotives l
         LEFT JOIN train_schedule ts ON l.id = ts.train_id
WHERE ts.arrival_time <= :time
GROUP BY l.id;

--Локомотивы, прошедшие техосмотр, отправленные в ремонт, число ремонтов, рейсы до ремонта, возраст
SELECT l.id,
       l.locomotive_number,
       COUNT(DISTINCT tm.id) FILTER (WHERE tm.description ILIKE '%техосмотр%' AND
                                           tm.maintenance_date BETWEEN :start_date AND :end_date)                   AS inspections_count,
       COUNT(DISTINCT tm.id) FILTER (WHERE tm.description ILIKE '%ремонт%' AND
                                           tm.maintenance_date BETWEEN :repair_start AND :repair_end)               AS repairs_count,
       COUNT(ts.id)
       FILTER (WHERE ts.departure_time < MIN(tm.maintenance_date))                                                  AS trips_before_first_repair,
       MIN(ts.departure_time)                                                                                       AS first_departure_time
FROM locomotives l
         LEFT JOIN locomotives_tech_maintenance ltm ON l.id = ltm.locomotive_id
         LEFT JOIN tech_maintenance tm ON ltm.tech_id = tm.id
         LEFT JOIN train_schedule ts ON l.id = ts.train_id
GROUP BY l.id;

--Поезда на указанном маршруте, по длительности, цене, и всем критериям
SELECT ts.id,
       l.locomotive_number,
       ts.departure_time,
       ts.arrival_time,
       EXTRACT(EPOCH FROM (ts.arrival_time - ts.departure_time)) / 3600 AS duration_hours,
       ts.ticket_price
FROM train_schedule ts
         JOIN locomotives l ON ts.train_id = l.id
WHERE ts.route_id = :route_id
  AND ts.ticket_price BETWEEN :min_price AND :max_price
  AND (ts.arrival_time - ts.departure_time) BETWEEN (:min_dur * INTERVAL '1 hour') AND (:max_dur * INTERVAL '1 hour');

--Отменённые рейсы полностью, в направлении, маршруту
SELECT DISTINCT ts.id,
                r.departure_point,
                r.arrival_point,
                r.id AS route_id
FROM train_schedule ts
         JOIN routes r ON ts.route_id = r.id
         JOIN tickets t ON t.train_id = ts.train_id
         JOIN ticket_statuses s ON t.status = s.id
WHERE s.description ILIKE '%отменён%'
  AND (r.departure_point = :from OR :from IS NULL)
  AND (r.arrival_point = :to OR :to IS NULL)
  AND (r.id = :route_id OR :route_id IS NULL);


--Задержанные рейсы, по причине, маршруту, и числу сданных билетов
SELECT td.id                 AS delay_id,
       r.id                  AS route_id,
       dr.description        AS reason,
       COUNT(DISTINCT tr.id) AS refunded_tickets
FROM train_delays td
         JOIN train_schedule ts ON ts.id = td.train_schedule_id
         JOIN routes r ON ts.route_id = r.id
         JOIN delay_reasons dr ON td.delay_reason_id = dr.id
         LEFT JOIN tickets t ON t.train_id = ts.train_id
         LEFT JOIN ticket_refunds tr
                   ON tr.ticket_id = t.id AND tr.refund_date BETWEEN ts.departure_time AND ts.arrival_time + td.delay
WHERE (dr.id = :reason_id OR :reason_id IS NULL)
  AND (r.id = :route_id OR :route_id IS NULL)
GROUP BY td.id, r.id, dr.description;


--Среднее количество проданных билетов за период, по маршрутам, длительности, цене
SELECT r.id                                AS route_id,
       COUNT(t.id)                         AS total_tickets,
       ROUND(AVG(ticket_count_per_day), 2) AS avg_tickets_per_day
FROM (SELECT ts.id       AS schedule_id,
             ts.route_id,
             COUNT(t.id) AS ticket_count_per_day
      FROM train_schedule ts
               LEFT JOIN tickets t ON t.train_id = ts.train_id
      WHERE ts.departure_time BETWEEN :start_date AND :end_date
        AND ts.ticket_price BETWEEN :min_price AND :max_price
        AND (ts.arrival_time - ts.departure_time) BETWEEN (:min_dur * INTERVAL '1 hour') AND (:max_dur * INTERVAL '1 hour')
      GROUP BY ts.id) AS subq
         JOIN routes r ON r.id = subq.route_id
GROUP BY r.id;

--Маршруты указанной категории (route_type), в определённом направлении
SELECT
    r.id,
    r.departure_point,
    r.arrival_point,
    rt.description AS route_type
FROM routes r
         JOIN route_types rt ON r.route_type = rt.id
WHERE (r.departure_point = :from OR :from IS NULL)
  AND (r.arrival_point = :to OR :to IS NULL)
  AND rt.id = :route_type_id;

--Пассажиры на рейсе, уехавшие в день, с багажом, по полу, возрасту
-- Указывается: поезд, дата, заграничный признак, возрастной фильтр
SELECT
    p.id,
    p.full_name,
    p.birth_date,
    EXTRACT(YEAR FROM AGE(:travel_date, p.birth_date)) AS age,
    CASE WHEN l.id IS NOT NULL THEN 'Есть багаж' ELSE 'Без багажа' END AS luggage_status
FROM tickets t
         JOIN passengers p ON t.passenger_id = p.id
         JOIN train_schedule ts ON ts.train_id = t.train_id
         LEFT JOIN luggage l ON l.passenger_id = p.id
WHERE t.train_id = :train_id
  AND DATE(t.purchase_date) = :travel_date
  AND (:min_age IS NULL OR EXTRACT(YEAR FROM AGE(:travel_date, p.birth_date)) >= :min_age)
  AND (:max_age IS NULL OR EXTRACT(YEAR FROM AGE(:travel_date, p.birth_date)) <= :max_age)
  AND (:has_luggage IS NULL OR (:has_luggage = TRUE AND l.id IS NOT NULL) OR (:has_luggage = FALSE AND l.id IS NULL));


--Невыкупленные билеты на рейс, день, маршруn
SELECT
    t.id,
    p.full_name,
    ts.id AS train_schedule_id,
    s.description AS ticket_status
FROM tickets t
         JOIN passengers p ON p.id = t.passenger_id
         JOIN train_schedule ts ON t.train_id = ts.train_id
         JOIN ticket_statuses s ON t.status = s.id
WHERE (ts.train_id = :train_id OR :train_id IS NULL)
  AND (DATE(t.purchase_date) = :purchase_date OR :purchase_date IS NULL)
  AND (ts.route_id = :route_id OR :route_id IS NULL)
  AND s.description ILIKE '%невыкуп%';
