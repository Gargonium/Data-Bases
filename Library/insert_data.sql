-- =========================
-- LIBRARIES
-- =========================
insert into libraries (name, address)
select 'Library #' || g, 'Address ' || g
from generate_series(1,5) g;

-- =========================
-- READING ROOMS (5 * 3 = 15)
-- =========================
insert into reading_rooms (library_id)
select l.id
from libraries l, generate_series(1,3);

-- =========================
-- STORAGES (5 * 2 = 10)
-- =========================
insert into storages (library_id)
select l.id
from libraries l, generate_series(1,2);

-- =========================
-- RACKS (10 * 3 = 30)
-- =========================
insert into racks (storage_id)
select s.id
from storages s, generate_series(1,3);

-- =========================
-- SHELVES (30 * 4 = 120)
-- =========================
insert into shelves (rack_id)
select r.id
from racks r, generate_series(1,4);

-- =========================
-- READER CATEGORIES
-- =========================
insert into reader_categories (name) values
                                         ('Student'),('Researcher'),('Teacher');

-- =========================
-- READER ATTRIBUTES
-- =========================
insert into reader_category_attributes (category_id, name) values
                                                               (1,'University'),(1,'Faculty'),
                                                               (2,'Field'),
                                                               (3,'Department');

-- =========================
-- READERS (120)
-- =========================
insert into readers (category_id, library_id, first_name, last_name, registration_date)
select (random()*2+1)::int,
        (random()*4+1)::int,
        'Name' || g,
       'Surname' || g,
       current_date - (random()*365)::int
from generate_series(1,120) g;

-- =========================
-- READER ATTRIBUTE VALUES (correct FK usage)
-- =========================
insert into reader_category_attribute_values
select r.id, r.category_id, rca.id,
       case when r.category_id = 1 then 'University X'
            when r.category_id = 2 then 'Physics'
            else 'Dept Y' end
from readers r
         join reader_category_attributes rca
              on rca.category_id = r.category_id
where rca.id = (
    select min(rca2.id)
    from reader_category_attributes rca2
    where rca2.category_id = r.category_id
);

-- =========================
-- AUTHORS (50)
-- =========================
insert into authors (first_name, last_name)
select 'AuthorName' || g, 'AuthorSurname' || g
from generate_series(1,50) g;

-- =========================
-- WORK CATEGORIES
-- =========================
insert into work_categories (name) values ('Book'),('Article');

-- =========================
-- WORKS (200)
-- =========================
insert into works (title, category_id, author)
select 'Work #' || g,
       (random()*1+1)::int,
        (random()*49+1)::int
from generate_series(1,200) g;

-- =========================
-- PUBLICATIONS (300)
-- =========================
insert into publications (title, publish_date, publisher)
select 'Publication #' || g,
       current_date - (random()*5000)::int,
        'Publisher ' || (random()*10)::int
from generate_series(1,300) g;

-- =========================
-- PUBLICATION-WORK LINKS
-- =========================
insert into publications_works
select p.id, (random()*199+1)::int
from publications p;

-- =========================
-- PUBLICATION RULES
-- =========================
insert into publication_rules
select p.id,
       r.reading_room_only,
       case
           when r.reading_room_only then null
           else (random()*30+1)::int
           end
from publications p
         cross join lateral (
    select (random() < 0.2) as reading_room_only
    ) r;

-- =========================
-- EMPLOYEES (30)
-- =========================
insert into employee (library_id, reading_room_id, first_name, last_name)
select (random()*4+1)::int,
        (random()*14+1)::int,
        'EmpName' || g,
       'EmpSurname' || g
from generate_series(1,30) g;

-- =========================
-- COPIES (500, shelves <=120)
-- =========================
insert into publications_copy (inventory_number, publication_id, shelf_id, receipt_date, received_employee_id)
select g,
       (random()*299+1)::int,
        (random()*119+1)::int,
                current_date - (random()*1000)::int,
        (random()*29+1)::int
from generate_series(1000,1499) g;

-- =========================
-- LOANS (300)
-- =========================
insert into loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
select
    r.reader_id,
    r.copy_id,
    r.date_of_issue,
    case
        when random() < 0.5 then null
        else r.date_of_issue + (random()*30 + 1)::int
        end,
    r.date_of_issue + (random()*15 + 1)::int,
    r.employee_id
from (
         select
             (random()*119+1)::int as reader_id,
             (random()*499+1000)::int as copy_id,
             current_date - (random()*60)::int as date_of_issue,
             (random()*29+1)::int as employee_id
     ) r
         cross join generate_series(1,300);

-- =========================
-- READING PROCESS (200)
-- =========================
insert into reading_process (reader_id, copy_inventory_number, issued_employee_id, library_id, reading_room_id, issued_date, issued_time, return_date, return_time)
select (random()*119+1)::int,
        (random()*499+1000)::int,
        (random()*29+1)::int,
        (random()*4+1)::int,
        (random()*14+1)::int,
                current_date - (random()*30)::int,
        '10:00',
       current_date - (random()*30)::int,
        '12:00'
from generate_series(1,200);

-- =========================
-- WRITTEN OFF (100)
-- =========================
insert into written_off (inventory_number, publication_id, write_off_date, write_off_employee_id)
select 'W' || g,
       (random()*299+1)::int,
                current_date - (random()*2000)::int,
        (random()*29+1)::int
from generate_series(1,100) g;

-- =========================
-- TEST CASES
-- =========================
update loans
set expire_date = current_date - 5
where id in (select id from loans limit 5);

update loans
set return_date = null
where id in (select id from loans limit 10);

insert into loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
select 1, pc.inventory_number, current_date - 1, null, current_date + 5, 1
from publications_copy pc
    limit 20;

insert into readers (category_id, library_id, first_name, last_name, registration_date)
values (1, 1, 'Test', 'Reader', current_date);

insert into reader_category_attribute_values (reader_id, category_id, attribute_id, value)
select r.id, r.category_id, rca.id, 'University X'
from readers r
         join reader_category_attributes rca on rca.category_id = r.category_id
where r.first_name = 'Test';

insert into works (title, category_id, author) values ('Test Work', 1, 1);
insert into publications (title, publish_date, publisher) values ('Test Publication', current_date, 'Test Publisher');
insert into publications_works (publication_id, work_id)
select p.id, w.id
from publications p, works w
where p.title = 'Test Publication' and w.title = 'Test Work';

insert into publications_copy (inventory_number, publication_id, shelf_id, receipt_date, received_employee_id)
values (9999, (select id from publications where title='Test Publication'), 1, current_date, 1);

insert into loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
values ((select id from readers where first_name='Test'), 9999, current_date - 1, null, current_date + 5, 1);