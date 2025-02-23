-- 1.	Покупатели, которые купили больше всего просроченных продуктов. При равенстве вывести всех. Формат вывода: ФИО, количество купленных просроченных продуктов.
select concat(c.last_name, ' ', c.first_name, ' ', coalesce(c.patronymic, '')) as full_name,
       count(*)                                                                as expired_count
from purchases p
         join customers c on p.customer_id = c.customers_id
         join goods g on p.good_id = g.goods_id
where g.expiration_date < p.purchase_date
group by c.customers_id
having count(*) = (select max(expired_count)
                   from (select count(*) as expired_count
                         from purchases
                                  join goods on purchases.good_id = goods.goods_id
                         where goods.expiration_date < purchase_date
                         group by customer_id) as subquery);

-- 2.	Статистика по общей сумме покупок для каждого продукта. 0 тоже выводить. Формат вывода: Название продукта, сумма покупок. Сортировка по сумме.
select p.name                    as product_name,
       coalesce(sum(g.price), 0) as total_sum
from products p
         left join goods g on p.products_id = g.product_id
         left join purchases pu on g.goods_id = pu.good_id
group by p.name
order by total_sum desc;

-- 3.	Продукты, ВСЕ соответствующие товары для которых были (или будут) просрочены в дату X. Формат вывода: Название продукта.
select distinct p.name as product_name
from products p
         join goods g on p.products_id = g.product_id
where g.expiration_date < '2024-12-12';

-- 4.	Дата последней покупки покупателя с именем X. Формат вывода: Дата.
select max(p.purchase_date) as last_purchase_date
from purchases p
         join customers c on p.customer_id = c.customers_id
where c.first_name = 'Dmitrij';

-- 5.	Средний возраст уникальных покупателей продукта X (название продукта). Формат вывода: средний возраст.
select avg(distinct c.age) as average_age
from customers c
join purchases p on c.customers_id = p.customer_id
join goods g on g.goods_id = p.good_id
join products pr on pr.products_id = g.product_id
where pr.name = 'Сыр';
