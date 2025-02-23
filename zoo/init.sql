create type diet_type as enum ('predator', 'herbivore', 'omnivorous');

create table habitats
(
    habitat_id int primary key generated by default as identity,
    climate    varchar(100) not null,
    continent  varchar(100) not null,
    unique (climate, continent)
);

create table species
(
    species_id int primary key generated by default as identity,
    name       varchar(100) not null unique,
    habitat    int          not null references habitats (habitat_id),
    diet       diet_type    not null
);

create table animals
(
    animal_id      int primary key generated by default as identity,
    name           varchar(100) not null unique,
    animal_species int          not null references species (species_id),
    weight         int          not null check ( weight > 0 ),
    length         int          not null check ( length > 0 ),
    admission_date date         not null check ( admission_date > to_date('01 01 2024', 'DD MM YYYY')),
    cage_number    int          not null
);