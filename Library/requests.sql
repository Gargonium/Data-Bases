-- 1. Получить список читателей с заданными характеристиками: студентов указанного
--    учебного заведения, факультета, научных работников по определенной тематике и т.д.

select r.*
from readers r
         join reader_category_attribute_values rcav
              on r.id = rcav.reader_id
         join reader_category_attributes rca
              on rcav.attribute_id = rca.id
where r.category_id = :category_id -- 1
  and rca.name = :attribute_name -- 'University'
  and rcav.value = :attribute_value; -- 'University X'

-- 2. Выдать перечень читателей, на руках у которых находится указанное произведение.

select distinct r.*
from readers r
         join loans l on r.id = l.reader_id
         join publications_copy pc on l.copy_inventory_number = pc.inventory_number
         join publications_works pw on pc.publication_id = pw.publication_id
where pw.work_id = :work_id -- 201
  and l.return_date is null;

-- 3. Получить список читателей, на руках у которых находится указанное издание.

select r.*
from readers r
         join loans l on r.id = l.reader_id
         join publications_copy pc on l.copy_inventory_number = pc.inventory_number
where pc.publication_id = :publication_id -- 301
  and l.return_date is null;

-- 4. Получить перечень читателей, которые в течение указанного промежутка времени
--    получали издание с некоторым произведением, и название этого издания.

select distinct r.*, p.title
from readers r
         join loans l on r.id = l.reader_id
         join publications_copy pc on l.copy_inventory_number = pc.inventory_number
         join publications p on pc.publication_id = p.id
         join publications_works pw on p.id = pw.publication_id
where pw.work_id = :work_id -- 201
  and l.date_of_issue between :date_from and :date_to;

-- 5. Выдать список изданий, которые в течение некоторого времени получал указанный
--    читатель из фонда библиотеки, где он зарегистрирован.
select distinct p.*
from loans l
         join readers r on l.reader_id = r.id
         join publications_copy pc on l.copy_inventory_number = pc.inventory_number
         join publications p on pc.publication_id = p.id
where r.id = :reader_id -- 1
  and r.library_id = (
    select library_id from readers where id = :reader_id
)
  and l.date_of_issue between :date_from and :date_to;

-- 6. Получить перечень изданий, которыми в течение некоторого времени пользовался
--    указанный читатель из фонда библиотеки, где он не зарегистрирован.

select distinct p.*
from reading_process rp
         join readers r on rp.reader_id = r.id
         join publications_copy pc on rp.copy_inventory_number = pc.inventory_number
         join publications p on pc.publication_id = p.id
where r.id = :reader_id -- 2
  and rp.library_id <> r.library_id
  and rp.issued_date between :date_from and :date_to;

-- 7. Получить список литературы, которая в настоящий момент выдана с определенной полки
--    некоторой библиотеки.

select p.*
from publications_copy pc
         join publications p on pc.publication_id = p.id
         join loans l on pc.inventory_number = l.copy_inventory_number
where pc.shelf_id = :shelf_id -- 1
  and l.return_date is null;

-- 8. Выдать список читателей, которые в течение обозначенного периода были обслужены
--    указанным библиотекарем.
select distinct r.*
from readers r
         join loans l on r.id = l.reader_id
where l.issued_employee_id = :employee_id -- 1
  and l.date_of_issue between :date_from and :date_to;

-- 9. Получить данные о выработке библиотекарей (число обслуженных читателей в указанный
--    период времени).

select e.id, e.first_name, e.last_name, count(distinct l.reader_id) as readers_served
from employee e
         left join loans l on e.id = l.issued_employee_id
    and l.date_of_issue between :date_from and :date_to
group by e.id;

-- 10. Получить список читателей с просроченным сроком литературы.

select distinct r.*
from readers r
         join loans l on r.id = l.reader_id
where l.expire_date < current_date
  and l.return_date is null;


-- 11. Получить перечень указанной литературы, которая поступила (была списана) в течение
--     некоторого периода.

select *
from publications_copy
where receipt_date between :date_from and :date_to;

select *
from written_off
where write_off_date between :date_from and :date_to;


-- 12. Выдать список библиотекарей, работающих в указанном читальном зале некоторой
--     библиотеки.

select *
from employee
where library_id = :library_id -- 2
  and reading_room_id = :reading_room_id; -- 5


-- 13. Получить список читателей, не посещавших библиотеку в течение указанного времени.

select r.*
from readers r
where r.id not in (
    select reader_id from loans
    where date_of_issue between :date_from and :date_to
    union
    select reader_id from reading_process
    where issued_date between :date_from and :date_to
);


-- 14. Получить список инвентарных номеров и названий из библиотечного фонда, в которых
--     содержится указанное произведение.

select pc.inventory_number, p.title
from publications_copy pc
         join publications p on pc.publication_id = p.id
         join publications_works pw on p.id = pw.publication_id
where pw.work_id = :work_id; -- 10


-- 15. Выдать список инвентарных номеров и названий из библиотечного фонда, в которых
--     содержатся произведения указанного автора.

select pc.inventory_number, p.title
from publications_copy pc
         join publications p on pc.publication_id = p.id
         join publications_works pw on p.id = pw.publication_id
         join works w on pw.work_id = w.id
where w.author = :author_id; -- 5


-- 16. Получить список самых популярных произведений.

select w.id, w.title, count(*) as usage_count
from works w
         join publications_works pw on w.id = pw.work_id
         join publications_copy pc on pw.publication_id = pc.publication_id
         join loans l on pc.inventory_number = l.copy_inventory_number
group by w.id
order by usage_count desc
limit 10;