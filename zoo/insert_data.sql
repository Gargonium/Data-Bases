INSERT INTO habitats (climate, continent)
VALUES ('Tropical', 'Africa'),
       ('Arctic', 'Antarctica'),
       ('Desert', 'Asia'),
       ('Temperate', 'Europe'),
       ('Rainforest', 'South America'),
       ('Savannah', 'Africa'),
       ('Temperate', 'North America'),
       ('Mountainous', 'Asia'),
       ('Coastal', 'Australia'),
       ('Wetland', 'Europe');

INSERT INTO species (name, habitat, diet)
VALUES ('Lion', 1, 'predator'),
       ('Penguin', 2, 'herbivore'),
       ('Camel', 3, 'herbivore'),
       ('Wolf', 4, 'predator'),
       ('Toucan', 5, 'omnivorous'),
       ('Orca', 2, 'predator'),
       ('Elephant', 6, 'herbivore'),
       ('Grizzly Bear', 7, 'omnivorous'),
       ('Snow Leopard', 8, 'predator'),
       ('Kangaroo', 9, 'herbivore'),
       ('Otter', 10, 'omnivorous');

INSERT INTO animals (name, animal_species, weight, length, admission_date, cage_number)
VALUES ('Simba', 1, 190, 250, '2024-02-15', 101),
       ('Pingu', 2, 25, 60, '2024-05-20', 202),
       ('Sandy', 3, 400, 230, '2024-03-10', 303),
       ('Ghost', 4, 45, 120, '2024-06-01', 404),
       ('Tiki', 5, 1, 40, '2024-07-07', 505),
       ('Marina', 6, 3666, 68, '2024-09-27', 1488),
       ('Dumbo', 6, 5000, 350, '2024-02-25', 606),
       ('Grizzly', 7, 400, 220, '2024-05-30', 707),
       ('Snowy', 8, 55, 130, '2024-04-01', 808),
       ('Joey', 9, 85, 160, '2024-06-15', 909),
       ('Otto', 10, 15, 70, '2024-07-20', 1010),
       ('Nala', 1, 180, 245, '2024-02-28', 102),
       ('Tux', 2, 30, 65, '2024-06-10', 203),
       ('Bactrian', 3, 600, 250, '2024-03-25', 304),
       ('Luna', 4, 50, 130, '2024-06-18', 405),
       ('Rio', 5, 2, 35, '2024-08-01', 506);
