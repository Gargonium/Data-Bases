-- departments
insert into departments (department_name) values ('Биохимик');
insert into departments (department_name) values ('Мусоропроводчик');
insert into departments (department_name) values ('Сапожник');
insert into departments (department_name) values ('Кузнец');
insert into departments (department_name) values ('Парикмахер');

-- brigade_types
insert into brigade_types (type_name) values ('локомотивная');
insert into brigade_types (type_name) values ('техническая');
insert into brigade_types (type_name) values ('пожарная');
insert into brigade_types (type_name) values ('медицинская');
insert into brigade_types (type_name) values ('инженерная');

-- professions
insert into professions (profession_name) values ('Инженер-механик');
insert into professions (profession_name) values ('Электромонтажник');
insert into professions (profession_name) values ('Техник');
insert into professions (profession_name) values ('Машинист');
insert into professions (profession_name) values ('Контролёр');

-- professions_attributes
insert into professions_attributes (profession_id, attribute_name, data_type) values (1, 'стаж', 'integer');
insert into professions_attributes (profession_id, attribute_name, data_type) values (1, 'квалификация', 'varchar(255)');
insert into professions_attributes (profession_id, attribute_name, data_type) values (2, 'стаж', 'integer');
insert into professions_attributes (profession_id, attribute_name, data_type) values (2, 'сертификация', 'varchar(255)');
insert into professions_attributes (profession_id, attribute_name, data_type) values (3, 'уровень риска', 'integer');
insert into professions_attributes (profession_id, attribute_name, data_type) values (3, 'разрешение на управление', 'boolean');
insert into professions_attributes (profession_id, attribute_name, data_type) values (4, 'стаж', 'integer');
insert into professions_attributes (profession_id, attribute_name, data_type) values (4, 'сертификация', 'varchar(255)');
insert into professions_attributes (profession_id, attribute_name, data_type) values (5, 'квалификация', 'varchar(255)');
insert into professions_attributes (profession_id, attribute_name, data_type) values (5, 'уровень риска', 'integer');

-- brigades
insert into brigades (brigade_number, brigade_type) values (1000, 1);
insert into brigades (brigade_number, brigade_type) values (1001, 2);
insert into brigades (brigade_number, brigade_type) values (1002, 3);
insert into brigades (brigade_number, brigade_type) values (1003, 4);
insert into brigades (brigade_number, brigade_type) values (1004, 5);

-- employees
insert into employee (full_name, department_id, brigade_id, date_of_employment, date_of_dismissal, salary, gender, birthday, children) values
                                                                                                                                           ('Алексей Смирнов', 1, 1, '2015-05-01', null, 60000, 'мужской', '1985-06-15', '2'),
                                                                                                                                           ('Мария Иванова', 2, 2, '2016-08-20', null, 72000, 'женский', '1990-03-22', '1'),
                                                                                                                                           ('Игорь Петров', 3, 3, '2017-11-10', '2023-02-15', 50000, 'мужской', '1980-01-12', '0'),
                                                                                                                                           ('Ольга Козлова', 4, 4, '2019-02-05', null, 65000, 'женский', '1992-07-18', '3+'),
                                                                                                                                           ('Николай Сидоров', 5, 5, '2020-06-12', null, 55000, 'мужской', '1988-10-30', '1');

-- employee_professions
insert into employee_professions (employee_id, profession_id, appointment_date) values (1, 1, '2015-06-01');
insert into employee_professions (employee_id, profession_id, appointment_date) values (2, 2, '2016-09-01');
insert into employee_professions (employee_id, profession_id, appointment_date) values (3, 3, '2018-01-01');
insert into employee_professions (employee_id, profession_id, appointment_date) values (4, 4, '2019-03-01');
insert into employee_professions (employee_id, profession_id, appointment_date) values (5, 5, '2020-07-01');

-- attributes_values
insert into attributes_values (employee_id, profession_attribute_id, value) values (1, 1, '5');
insert into attributes_values (employee_id, profession_attribute_id, value) values (2, 3, '3');
insert into attributes_values (employee_id, profession_attribute_id, value) values (3, 5, '2');
insert into attributes_values (employee_id, profession_attribute_id, value) values (4, 7, '6');
insert into attributes_values (employee_id, profession_attribute_id, value) values (5, 9, 'высшая');

-- departments_headmasters
insert into departments_headmasters (department_id, headmaster_id) values (1, 1);
insert into departments_headmasters (department_id, headmaster_id) values (2, 2);
insert into departments_headmasters (department_id, headmaster_id) values (3, 3);
insert into departments_headmasters (department_id, headmaster_id) values (4, 4);
insert into departments_headmasters (department_id, headmaster_id) values (5, 5);

-- locomotives
insert into locomotives (locomotive_number, locomotive_brigade_id) values ('loc-100', 1);
insert into locomotives (locomotive_number, locomotive_brigade_id) values ('loc-101', 1);
insert into locomotives (locomotive_number, locomotive_brigade_id) values ('loc-102', 1);
insert into locomotives (locomotive_number, locomotive_brigade_id) values ('loc-103', 1);
insert into locomotives (locomotive_number, locomotive_brigade_id) values ('loc-104', 1);

-- locomotive_tech_brigades
insert into locomotive_tech_brigades (locomotive_id, brigade_id) values (3, 2);
insert into locomotive_tech_brigades (locomotive_id, brigade_id) values (4, 3);
insert into locomotive_tech_brigades (locomotive_id, brigade_id) values (5, 4);
insert into locomotive_tech_brigades (locomotive_id, brigade_id) values (6, 5);
insert into locomotive_tech_brigades (locomotive_id, brigade_id) values (7, 1);

-- inspection_schedule
insert into inspection_schedule (inspection_date) values ('2024-01-10');
insert into inspection_schedule (inspection_date) values ('2024-02-15');
insert into inspection_schedule (inspection_date) values ('2024-03-20');
insert into inspection_schedule (inspection_date) values ('2024-04-25');
insert into inspection_schedule (inspection_date) values ('2024-05-30');

-- tech_maintenance
insert into tech_maintenance (maintenance_date, description, inspection_schedule_id) values ('2024-01-11', 'плановый осмотр', 1);
insert into tech_maintenance (maintenance_date, description, inspection_schedule_id) values ('2024-02-16', 'замена тормозной системы', 2);
insert into tech_maintenance (maintenance_date, description, inspection_schedule_id) values ('2024-03-21', 'проверка электрики', 3);
insert into tech_maintenance (maintenance_date, description, inspection_schedule_id) values ('2024-04-26', 'очистка двигателя', 4);
insert into tech_maintenance (maintenance_date, description, inspection_schedule_id) values ('2024-05-31', 'капитальный ремонт', 5);

-- locomotives_tech_maintenance
insert into locomotives_tech_maintenance (locomotive_id, tech_id) values (3, 1);
insert into locomotives_tech_maintenance (locomotive_id, tech_id) values (4, 2);
insert into locomotives_tech_maintenance (locomotive_id, tech_id) values (5, 3);
insert into locomotives_tech_maintenance (locomotive_id, tech_id) values (6, 4);
insert into locomotives_tech_maintenance (locomotive_id, tech_id) values (7, 5);

-- med_check
insert into med_check (employee_id, med_check_date, status) values (1, '2024-11-01', 'годен');
insert into med_check (employee_id, med_check_date, status) values (2, '2024-11-02', 'годен');
insert into med_check (employee_id, med_check_date, status) values (3, '2024-11-03', 'не годен');
insert into med_check (employee_id, med_check_date, status) values (4, '2024-11-04', 'годен');
insert into med_check (employee_id, med_check_date, status) values (5, '2024-11-05', 'годен');

-- train_types
insert into train_types (train_type) values ('пассажирский');
insert into train_types (train_type) values ('грузовой');
insert into train_types (train_type) values ('экспресс');
insert into train_types (train_type) values ('электричка');
insert into train_types (train_type) values ('скоростной');

-- route_types
insert into route_types (description) values ('прямой маршрут');
insert into route_types (description) values ('с пересадками');
insert into route_types (description) values ('международный');
insert into route_types (description) values ('внутренний');
insert into route_types (description) values ('сезонный');

-- routes
insert into routes (departure_point, arrival_point, route_type) values ('Москва', 'Сочи', 1);
insert into routes (departure_point, arrival_point, route_type) values ('Санкт-Петербург', 'Казань', 2);
insert into routes (departure_point, arrival_point, route_type) values ('Екатеринбург', 'Новосибирск', 3);
insert into routes (departure_point, arrival_point, route_type) values ('Омск', 'Красноярск', 4);
insert into routes (departure_point, arrival_point, route_type) values ('Владивосток', 'Хабаровск', 5);

-- stations
insert into stations (station_name) values ('Москва станция');
insert into stations (station_name) values ('Сочи станция');
insert into stations (station_name) values ('Казань станция');
insert into stations (station_name) values ('Новосибирск станция');
insert into stations (station_name) values ('Хабаровск станция');

-- route_main_points
insert into route_main_points (route_id, station_id, station_ordinal_number) values (1, 1, 1);
insert into route_main_points (route_id, station_id, station_ordinal_number) values (2, 2, 1);
insert into route_main_points (route_id, station_id, station_ordinal_number) values (3, 3, 1);
insert into route_main_points (route_id, station_id, station_ordinal_number) values (4, 4, 1);
insert into route_main_points (route_id, station_id, station_ordinal_number) values (5, 5, 1);

-- train_schedule
insert into train_schedule (train_id, departure_time, arrival_time, route_id, train_type_id, ticket_price) values (3, '2025-04-01 08:00', '2025-04-01 20:00', 1, 1, 1500);
insert into train_schedule (train_id, departure_time, arrival_time, route_id, train_type_id, ticket_price) values (4, '2025-04-02 09:00', '2025-04-02 22:00', 2, 2, 1700);
insert into train_schedule (train_id, departure_time, arrival_time, route_id, train_type_id, ticket_price) values (5, '2025-04-03 10:00', '2025-04-03 21:00', 3, 3, 1600);
insert into train_schedule (train_id, departure_time, arrival_time, route_id, train_type_id, ticket_price) values (6, '2025-04-04 07:00', '2025-04-04 19:00', 4, 4, 1800);
insert into train_schedule (train_id, departure_time, arrival_time, route_id, train_type_id, ticket_price) values (7, '2025-04-05 06:00', '2025-04-05 18:00', 5, 5, 2000);

-- passengers
insert into passengers (full_name, birth_date) values ('Павел Волков', '1980-05-01');
insert into passengers (full_name, birth_date) values ('Елена Миронова', '1992-11-15');
insert into passengers (full_name, birth_date) values ('Сергей Кузьмин', '2000-06-30');
insert into passengers (full_name, birth_date) values ('Анастасия Тихонова', '1985-12-03');
insert into passengers (full_name, birth_date) values ('Виктор Орлов', '1975-09-25');

-- ticket_offices
insert into ticket_offices (ticket_office_number) values (1);
insert into ticket_offices (ticket_office_number) values (2);
insert into ticket_offices (ticket_office_number) values (3);
insert into ticket_offices (ticket_office_number) values (4);
insert into ticket_offices (ticket_office_number) values (5);

-- ticket_statuses
insert into ticket_statuses (description) values ('куплен');
insert into ticket_statuses (description) values ('забронирован');
insert into ticket_statuses (description) values ('возвращён');
insert into ticket_statuses (description) values ('использован');
insert into ticket_statuses (description) values ('аннулирован');

-- tickets
insert into tickets (train_id, passenger_id, ticket_office_id, purchase_date, status) values (6, 1, 1, '2025-03-01 10:00', 1);
insert into tickets (train_id, passenger_id, ticket_office_id, purchase_date, status) values (7, 2, 2, '2025-03-02 11:00', 2);
insert into tickets (train_id, passenger_id, ticket_office_id, purchase_date, status) values (3, 3, 3, '2025-03-03 12:00', 3);
insert into tickets (train_id, passenger_id, ticket_office_id, purchase_date, status) values (4, 4, 4, '2025-03-04 13:00', 4);
insert into tickets (train_id, passenger_id, ticket_office_id, purchase_date, status) values (5, 5, 5, '2025-03-05 14:00', 5);

-- luggage
insert into luggage (passenger_id) values (1);
insert into luggage (passenger_id) values (2);
insert into luggage (passenger_id) values (3);
insert into luggage (passenger_id) values (4);
insert into luggage (passenger_id) values (5);

-- ticket_refunds
insert into ticket_refunds (ticket_id, refund_date) values (5, '2025-03-07 11:00');
insert into ticket_refunds (ticket_id, refund_date) values (2, '2025-03-08 12:00');
insert into ticket_refunds (ticket_id, refund_date) values (3, '2025-03-09 13:00');
insert into ticket_refunds (ticket_id, refund_date) values (4, '2025-03-10 14:00');

-- delay_reasons
insert into delay_reasons (description) values ('поломка');
insert into delay_reasons (description) values ('погодные условия');
insert into delay_reasons (description) values ('опоздание поезда');
insert into delay_reasons (description) values ('технический осмотр');
insert into delay_reasons (description) values ('непредвиденные обстоятельства');

-- train_delays
insert into train_delays (train_schedule_id, delay_reason_id, delay) values (6, 1, '00:20:00');
insert into train_delays (train_schedule_id, delay_reason_id, delay) values (2, 2, '00:45:00');
insert into train_delays (train_schedule_id, delay_reason_id, delay) values (3, 3, '01:15:00');
insert into train_delays (train_schedule_id, delay_reason_id, delay) values (4, 4, '00:30:00');
insert into train_delays (train_schedule_id, delay_reason_id, delay) values (5, 5, '00:50:00');
