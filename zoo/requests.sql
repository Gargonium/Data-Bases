-- 1.	Ввод и редактирование хранимой информации
insert into animals (name, animal_species, weight, length, admission_date, cage_number)
values ('Tiger', 1, 250, 300, '2024-08-20', 1101);

update animals
set weight = 275,
    length = 310
where name = 'Tiger';

-- 2.	Поиск животных по виду, типу питания, типу климата, ареалу обитания, континенту
select a.name, s.name, s.diet, h.climate, h.continent, a.cage_number, a.admission_date
from animals a
         join species s on a.animal_species = s.species_id
         join habitats h on s.habitat = h.habitat_id
where s.name = 'Lion';

select a.name, s.name, s.diet, h.climate, h.continent, a.cage_number, a.admission_date
from animals a
         join species s on a.animal_species = s.species_id
         join habitats h on s.habitat = h.habitat_id
where s.diet = 'predator';

select a.name, s.name, s.diet, h.climate, h.continent, a.cage_number, a.admission_date
from animals a
         join species s on a.animal_species = s.species_id
         join habitats h on s.habitat = h.habitat_id
where h.climate = 'Tropical';

select a.name, s.name, s.diet, h.climate, h.continent, a.cage_number, a.admission_date
from animals a
         join species s on a.animal_species = s.species_id
         join habitats h on s.habitat = h.habitat_id
where h.continent = 'Africa';


-- 3.	Поиск всех животных, поступивших в зоопарк за указанный период
select a.name, s.name, a.admission_date, a.cage_number
from animals a
         join species s on a.animal_species = s.species_id
where a.admission_date between '2024-01-01' and '2024-06-30';


-- 4.	Вывод всей информации о животном по его кличке
select a.animal_id,
       a.name,
       s.name,
       s.diet,
       a.weight,
       a.length,
       a.admission_date,
       a.cage_number,
       h.climate,
       h.continent
from animals a
         join species s on a.animal_species = s.species_id
         join habitats h on s.habitat = h.habitat_id
where a.name = 'Simba';
