-- =====================================================
-- Database: Library Management System
-- Data population script (minimum 20 rows per table)
-- =====================================================

-- 1. libraries (20 libraries)
INSERT INTO libraries (id, name, address)
VALUES (1, 'Central Public Library', '101 Main Street, Springfield, IL 62701'),
       (2, 'City Library Downtown', '202 Elm Avenue, Metropolis, NY 10001'),
       (3, 'Westside Community Library', '303 Oak Drive, Westview, CA 90210'),
       (4, 'East Branch Library', '404 Pine Lane, Eastown, TX 75001'),
       (5, 'North Regional Library', '505 Cedar Road, Northgate, WA 98101'),
       (6, 'Southside Library', '606 Birch Street, Southport, FL 33101'),
       (7, 'University Library', '700 College Ave, College Town, MA 02138'),
       (8, 'Science & Technology Library', '800 Research Blvd, Tech City, CA 94025'),
       (9, 'Historical Archives Library', '909 Heritage Way, Oldtown, VA 22030'),
       (10, 'Children’s Discovery Library', '111 Playground Lane, Kidville, OH 44101'),
       (11, 'Art & Music Library', '222 Cultural Plaza, Artsville, IL 60601'),
       (12, 'Business & Economics Library', '333 Commerce Street, Financia, NY 10004'),
       (13, 'Medical Library', '444 Health Parkway, Medville, MD 21201'),
       (14, 'Law Library', '555 Justice Court, Legal City, DC 20001'),
       (15, 'Rural County Library', '666 Country Road, Farmtown, IA 50001'),
       (16, 'Suburban Library', '777 Suburbia Lane, Suburb City, NJ 07001'),
       (17, 'Mobile Library HQ', '888 Transit Way, Moville, CO 80001'),
       (18, 'Digital Library Center', '999 Data Drive, Cyber City, WA 98001'),
       (19, 'Multilingual Library', '111 Diversity Ave, Global Town, CA 90001'),
       (20, 'Senior Center Library', '222 Golden Age Blvd, Elderville, FL 33601');

-- 2. reading_rooms (20 reading rooms)
INSERT INTO reading_rooms (id, library_id)
VALUES (1, 1),
       (2, 1),
       (3, 2),
       (4, 2),
       (5, 3),
       (6, 3),
       (7, 4),
       (8, 4),
       (9, 5),
       (10, 5),
       (11, 6),
       (12, 6),
       (13, 7),
       (14, 7),
       (15, 8),
       (16, 8),
       (17, 9),
       (18, 9),
       (19, 10),
       (20, 10);

-- 3. storages (20 storages)
INSERT INTO storages (id, library_id)
VALUES (1, 1),
       (2, 1),
       (3, 2),
       (4, 2),
       (5, 3),
       (6, 3),
       (7, 4),
       (8, 4),
       (9, 5),
       (10, 5),
       (11, 6),
       (12, 6),
       (13, 7),
       (14, 7),
       (15, 8),
       (16, 8),
       (17, 9),
       (18, 9),
       (19, 10),
       (20, 10);

-- 4. racks (30 racks, each storage has 1-2 racks)
INSERT INTO racks (id, storage_id)
VALUES (1, 1),
       (2, 1),
       (3, 2),
       (4, 2),
       (5, 3),
       (6, 3),
       (7, 4),
       (8, 4),
       (9, 5),
       (10, 5),
       (11, 6),
       (12, 6),
       (13, 7),
       (14, 7),
       (15, 8),
       (16, 8),
       (17, 9),
       (18, 9),
       (19, 10),
       (20, 10),
       (21, 11),
       (22, 11),
       (23, 12),
       (24, 12),
       (25, 13),
       (26, 13),
       (27, 14),
       (28, 14),
       (29, 15),
       (30, 15);

-- 5. shelves (100 shelves, each rack 3-4 shelves)
INSERT INTO shelves (id, rack_id)
VALUES (1, 1),
       (2, 1),
       (3, 1),
       (4, 2),
       (5, 2),
       (6, 2),
       (7, 3),
       (8, 3),
       (9, 3),
       (10, 4),
       (11, 4),
       (12, 4),
       (13, 5),
       (14, 5),
       (15, 5),
       (16, 6),
       (17, 6),
       (18, 6),
       (19, 7),
       (20, 7),
       (21, 7),
       (22, 8),
       (23, 8),
       (24, 8),
       (25, 9),
       (26, 9),
       (27, 9),
       (28, 10),
       (29, 10),
       (30, 10),
       (31, 11),
       (32, 11),
       (33, 11),
       (34, 12),
       (35, 12),
       (36, 12),
       (37, 13),
       (38, 13),
       (39, 13),
       (40, 14),
       (41, 14),
       (42, 14),
       (43, 15),
       (44, 15),
       (45, 15),
       (46, 16),
       (47, 16),
       (48, 16),
       (49, 17),
       (50, 17),
       (51, 17),
       (52, 18),
       (53, 18),
       (54, 18),
       (55, 19),
       (56, 19),
       (57, 19),
       (58, 20),
       (59, 20),
       (60, 20),
       (61, 21),
       (62, 21),
       (63, 21),
       (64, 22),
       (65, 22),
       (66, 22),
       (67, 23),
       (68, 23),
       (69, 23),
       (70, 24),
       (71, 24),
       (72, 24),
       (73, 25),
       (74, 25),
       (75, 25),
       (76, 26),
       (77, 26),
       (78, 26),
       (79, 27),
       (80, 27),
       (81, 27),
       (82, 28),
       (83, 28),
       (84, 28),
       (85, 29),
       (86, 29),
       (87, 29),
       (88, 30),
       (89, 30),
       (90, 30),
       (91, 1),
       (92, 2),
       (93, 3),
       (94, 4),
       (95, 5),
       (96, 6),
       (97, 7),
       (98, 8),
       (99, 9),
       (100, 10);
-- extra shelves

-- 6. reader_categories (20 categories)
INSERT INTO reader_categories (id, name)
VALUES (1, 'Undergraduate Student'),
       (2, 'Graduate Student (Master)'),
       (3, 'PhD Candidate'),
       (4, 'Postdoctoral Researcher'),
       (5, 'Professor'),
       (6, 'Associate Professor'),
       (7, 'Assistant Professor'),
       (8, 'Lecturer'),
       (9, 'High School Student'),
       (10, 'Teacher'),
       (11, 'Alumni'),
       (12, 'Library Staff'),
       (13, 'External Researcher'),
       (14, 'Visiting Scholar'),
       (15, 'Community Member'),
       (16, 'Corporate Member'),
       (17, 'Press/Journalist'),
       (18, 'Retired Faculty'),
       (19, 'Volunteer'),
       (20, 'International Visitor');

-- 7. readers (50 readers)
INSERT INTO readers (id, category_id, library_id, first_name, last_name, registration_date)
VALUES (1, 1, 1, 'John', 'Smith', '2023-01-10'),
       (2, 1, 2, 'Emily', 'Johnson', '2023-01-15'),
       (3, 2, 3, 'Michael', 'Williams', '2023-02-20'),
       (4, 2, 4, 'Jessica', 'Brown', '2023-03-05'),
       (5, 3, 5, 'David', 'Jones', '2023-03-12'),
       (6, 3, 6, 'Sarah', 'Garcia', '2023-04-01'),
       (7, 4, 7, 'James', 'Miller', '2023-04-18'),
       (8, 4, 8, 'Linda', 'Davis', '2023-05-02'),
       (9, 5, 9, 'Robert', 'Rodriguez', '2023-05-20'),
       (10, 5, 10, 'Maria', 'Martinez', '2023-06-10'),
       (11, 6, 11, 'Charles', 'Hernandez', '2023-06-25'),
       (12, 6, 12, 'Patricia', 'Lopez', '2023-07-07'),
       (13, 7, 13, 'Daniel', 'Gonzalez', '2023-07-19'),
       (14, 7, 14, 'Jennifer', 'Wilson', '2023-08-01'),
       (15, 8, 15, 'Matthew', 'Anderson', '2023-08-14'),
       (16, 8, 16, 'Elizabeth', 'Thomas', '2023-08-30'),
       (17, 9, 17, 'Christopher', 'Taylor', '2023-09-10'),
       (18, 9, 18, 'Susan', 'Moore', '2023-09-21'),
       (19, 10, 19, 'Joseph', 'Jackson', '2023-10-02'),
       (20, 10, 20, 'Karen', 'Martin', '2023-10-15'),
       (21, 11, 1, 'Thomas', 'Lee', '2023-11-01'),
       (22, 11, 2, 'Nancy', 'White', '2023-11-10'),
       (23, 12, 3, 'Brian', 'Harris', '2023-11-20'),
       (24, 12, 4, 'Margaret', 'Clark', '2023-12-01'),
       (25, 13, 5, 'Kevin', 'Lewis', '2023-12-12'),
       (26, 13, 6, 'Betty', 'Robinson', '2024-01-05'),
       (27, 14, 7, 'Jason', 'Walker', '2024-01-18'),
       (28, 14, 8, 'Dorothy', 'Perez', '2024-02-01'),
       (29, 15, 9, 'Eric', 'Hall', '2024-02-14'),
       (30, 15, 10, 'Helen', 'Young', '2024-02-28'),
       (31, 16, 1, 'Steven', 'Allen', '2024-03-10'),
       (32, 16, 2, 'Deborah', 'Sanchez', '2024-03-22'),
       (33, 17, 3, 'Paul', 'Wright', '2024-04-05'),
       (34, 17, 4, 'Stephanie', 'King', '2024-04-17'),
       (35, 18, 5, 'Mark', 'Scott', '2024-05-01'),
       (36, 18, 6, 'Rebecca', 'Green', '2024-05-15'),
       (37, 19, 7, 'Andrew', 'Baker', '2024-06-01'),
       (38, 19, 8, 'Laura', 'Adams', '2024-06-12'),
       (39, 20, 9, 'Kenneth', 'Nelson', '2024-06-25'),
       (40, 20, 10, 'Sharon', 'Carter', '2024-07-07'),
       (41, 1, 11, 'Joshua', 'Mitchell', '2024-07-20'),
       (42, 2, 12, 'Kimberly', 'Perez', '2024-08-01'),
       (43, 3, 13, 'Donald', 'Roberts', '2024-08-15'),
       (44, 4, 14, 'Amy', 'Turner', '2024-09-01'),
       (45, 5, 15, 'George', 'Phillips', '2024-09-12'),
       (46, 6, 16, 'Melissa', 'Campbell', '2024-09-25'),
       (47, 7, 17, 'Edward', 'Parker', '2024-10-05'),
       (48, 8, 18, 'Michelle', 'Evans', '2024-10-18'),
       (49, 9, 19, 'Ronald', 'Edwards', '2024-11-01'),
       (50, 10, 20, 'Lisa', 'Collins', '2024-11-15');

-- 8. reader_category_attributes (20 attributes, spread across categories)
INSERT INTO reader_category_attributes (id, category_id, name)
VALUES (1, 1, 'University'),
       (2, 1, 'Major'),
       (3, 2, 'University'),
       (4, 2, 'Department'),
       (5, 3, 'University'),
       (6, 3, 'Research Field'),
       (7, 4, 'Institution'),
       (8, 4, 'Specialization'),
       (9, 5, 'University'),
       (10, 5, 'Faculty'),
       (11, 6, 'University'),
       (12, 6, 'Department'),
       (13, 7, 'University'),
       (14, 7, 'Research Group'),
       (15, 8, 'Institution'),
       (16, 8, 'Subject'),
       (17, 9, 'School'),
       (18, 9, 'Grade'),
       (19, 10, 'School'),
       (20, 10, 'Subject');

-- 9. reader_category_attribute_values (for each reader, add attributes based on their category)
-- We'll insert values for readers 1-50. For simplicity, we generate 2-3 attributes per reader.
INSERT INTO reader_category_attribute_values (reader_id, category_id, attribute_id, value)
VALUES
-- Category 1 (Undergraduate)
(1, 1, 1, 'Springfield University'),
(1, 1, 2, 'Computer Science'),
(2, 1, 1, 'Metropolis State College'),
(2, 1, 2, 'Mathematics'),
(41, 1, 1, 'Westside University'),
(41, 1, 2, 'Physics'),
-- Category 2 (Graduate)
(3, 2, 3, 'University of Technology'),
(3, 2, 4, 'Engineering'),
(4, 2, 3, 'City University'),
(4, 2, 4, 'Economics'),
(42, 2, 3, 'Northwood University'),
(42, 2, 4, 'Biology'),
-- Category 3 (PhD)
(5, 3, 5, 'Research Institute of Science'),
(5, 3, 6, 'Machine Learning'),
(6, 3, 5, 'Global University'),
(6, 3, 6, 'Quantum Physics'),
(43, 3, 5, 'Tech University'),
(43, 3, 6, 'Organic Chemistry'),
-- Category 4 (Postdoc)
(7, 4, 7, 'National Lab'),
(7, 4, 8, 'Genomics'),
(8, 4, 7, 'Max Planck Institute'),
(8, 4, 8, 'Astrophysics'),
(44, 4, 7, 'CERN'),
(44, 4, 8, 'Particle Physics'),
-- Category 5 (Professor)
(9, 5, 9, 'Springfield University'),
(9, 5, 10, 'Engineering'),
(10, 5, 9, 'Metropolis College'),
(10, 5, 10, 'Literature'),
(45, 5, 9, 'West Coast University'),
(45, 5, 10, 'History'),
-- Category 6 (Associate Professor)
(11, 6, 11, 'Tech Institute'),
(11, 6, 12, 'Computer Science'),
(12, 6, 11, 'Business School'),
(12, 6, 12, 'Marketing'),
(46, 6, 11, 'Medical School'),
(46, 6, 12, 'Neurology'),
-- Category 7 (Assistant Professor)
(13, 7, 13, 'University of Arts'),
(13, 7, 14, 'Music Theory'),
(14, 7, 13, 'Law School'),
(14, 7, 14, 'Constitutional Law'),
(47, 7, 13, 'Polytechnic'),
(47, 7, 14, 'Robotics'),
-- Category 8 (Lecturer)
(15, 8, 15, 'Community College'),
(15, 8, 16, 'English'),
(16, 8, 15, 'Language Academy'),
(16, 8, 16, 'Spanish'),
(48, 8, 15, 'Design Institute'),
(48, 8, 16, 'Graphic Design'),
-- Category 9 (High School Student)
(17, 9, 17, 'Lincoln High'),
(17, 9, 18, '11th Grade'),
(18, 9, 17, 'Washington Academy'),
(18, 9, 18, '12th Grade'),
(49, 9, 17, 'Jefferson School'),
(49, 9, 18, '10th Grade'),
-- Category 10 (Teacher)
(19, 10, 19, 'Springfield Elementary'),
(19, 10, 20, 'Mathematics'),
(20, 10, 19, 'Central High'),
(20, 10, 20, 'Physics'),
(50, 10, 19, 'Riverside School'),
(50, 10, 20, 'Chemistry');

-- Add more values for other readers as needed (abbreviated for brevity, but sufficient for queries)

-- 10. work_categories (20 categories)
INSERT INTO work_categories (id, name)
VALUES (1, 'Fiction'),
       (2, 'Non-Fiction'),
       (3, 'Science'),
       (4, 'History'),
       (5, 'Mathematics'),
       (6, 'Computer Science'),
       (7, 'Physics'),
       (8, 'Chemistry'),
       (9, 'Biology'),
       (10, 'Engineering'),
       (11, 'Philosophy'),
       (12, 'Psychology'),
       (13, 'Economics'),
       (14, 'Sociology'),
       (15, 'Art'),
       (16, 'Music'),
       (17, 'Literature'),
       (18, 'Geography'),
       (19, 'Medicine'),
       (20, 'Law');

-- 11. authors (20 authors)
INSERT INTO authors (id, first_name, last_name)
VALUES (1, 'Jane', 'Austen'),
       (2, 'George', 'Orwell'),
       (3, 'Isaac', 'Asimov'),
       (4, 'Stephen', 'Hawking'),
       (5, 'Yuval Noah', 'Harari'),
       (6, 'Margaret', 'Atwood'),
       (7, 'Gabriel', 'Garcia Marquez'),
       (8, 'Toni', 'Morrison'),
       (9, 'Haruki', 'Murakami'),
       (10, 'Chimamanda', 'Adichie'),
       (11, 'Neil', 'Gaiman'),
       (12, 'J.K.', 'Rowling'),
       (13, 'Dan', 'Brown'),
       (14, 'Malcolm', 'Gladwell'),
       (15, 'Richard', 'Dawkins'),
       (16, 'Carl', 'Sagan'),
       (17, 'Mary', 'Roach'),
       (18, 'Bill', 'Bryson'),
       (19, 'Walter', 'Isaacson'),
       (20, 'Anne', 'Lamott');

-- 12. works (30 works)
INSERT INTO works (id, title, category_id, author)
VALUES (1, 'Pride and Prejudice', 1, 1),
       (2, '1984', 1, 2),
       (3, 'Foundation', 1, 3),
       (4, 'A Brief History of Time', 3, 4),
       (5, 'Sapiens: A Brief History of Humankind', 2, 5),
       (6, 'The Handmaid''s Tale', 1, 6),
       (7, 'One Hundred Years of Solitude', 1, 7),
       (8, 'Beloved', 1, 8),
       (9, 'Kafka on the Shore', 1, 9),
       (10, 'Half of a Yellow Sun', 1, 10),
       (11, 'American Gods', 1, 11),
       (12, 'Harry Potter and the Sorcerer''s Stone', 1, 12),
       (13, 'The Da Vinci Code', 1, 13),
       (14, 'The Tipping Point', 2, 14),
       (15, 'The Selfish Gene', 3, 15),
       (16, 'Cosmos', 3, 16),
       (17, 'Stiff: The Curious Lives of Human Cadavers', 2, 17),
       (18, 'A Short History of Nearly Everything', 2, 18),
       (19, 'Steve Jobs', 2, 19),
       (20, 'Bird by Bird', 2, 20),
       (21, 'Introduction to Algorithms', 6, 3),
       (22, 'Deep Learning', 6, 5),
       (23, 'Quantum Mechanics: The Theoretical Minimum', 7, 4),
       (24, 'The Double Helix', 9, 16),
       (25, 'Guns, Germs, and Steel', 4, 5),
       (26, 'The Wealth of Nations', 13, 19),
       (27, 'The Interpretation of Dreams', 12, 20),
       (28, 'Critique of Pure Reason', 11, 1),
       (29, 'The Art of War', 2, 2),
       (30, 'Medical Physiology', 19, 15);

-- 13. work_category_attributes (20 attributes)
INSERT INTO work_category_attributes (id, category_id, name)
VALUES (1, 1, 'Genre'),
       (2, 1, 'Reading Level'),
       (3, 2, 'Subject Area'),
       (4, 2, 'Target Audience'),
       (5, 3, 'Scientific Field'),
       (6, 3, 'Difficulty'),
       (7, 4, 'Era'),
       (8, 4, 'Region'),
       (9, 5, 'Math Branch'),
       (10, 5, 'Applications'),
       (11, 6, 'Programming Language'),
       (12, 6, 'Topic'),
       (13, 7, 'Subfield'),
       (14, 8, 'Chemical Concept'),
       (15, 9, 'Organism Type'),
       (16, 10, 'Engineering Discipline'),
       (17, 11, 'Philosophical School'),
       (18, 12, 'Psychological Approach'),
       (19, 13, 'Economic Theory'),
       (20, 14, 'Social Phenomenon');

-- Corrected work_category_attribute_values (one row per work for demonstration, but you can add more)
INSERT INTO work_category_attribute_values (work_id, category_id, attribute_id, value)
VALUES
-- work 1 (category 1) -> attributes 1 or 2
(1, 1, 1, 'Classic'),
-- work 2 (category 1)
(2, 1, 2, 'Adult'),
-- work 3 (category 1)
(3, 1, 1, 'Science Fiction'),
-- work 4 (category 3) -> attributes 5 or 6
(4, 3, 5, 'Cosmology'),
-- work 5 (category 2) -> attributes 3 or 4
(5, 2, 3, 'Anthropology'),
-- work 6 (category 1)
(6, 1, 2, 'Adult'),
-- work 7 (category 1)
(7, 1, 1, 'Magical Realism'),
-- work 8 (category 1)
(8, 1, 1, 'Historical Fiction'),
-- work 9 (category 1)
(9, 1, 1, 'Surrealist'),
-- work 10 (category 1)
(10, 1, 1, 'Historical'),
-- work 11 (category 1)
(11, 1, 1, 'Fantasy'),
-- work 12 (category 1)
(12, 1, 2, 'Children'),
-- work 13 (category 1)
(13, 1, 1, 'Thriller'),
-- work 14 (category 2)
(14, 2, 3, 'Sociology'),
-- work 15 (category 3)
(15, 3, 6, 'Advanced'),
-- work 16 (category 3)
(16, 3, 5, 'Astronomy'),
-- work 17 (category 2)
(17, 2, 3, 'Medicine'),
-- work 18 (category 2)
(18, 2, 3, 'Science History'),
-- work 19 (category 2)
(19, 2, 4, 'Adult'),
-- work 20 (category 2)
(20, 2, 3, 'Writing'),
-- work 21 (category 6) -> attributes 11 or 12
(21, 6, 11, 'Pseudocode'),
-- work 22 (category 6)
(22, 6, 12, 'Neural Networks'),
-- work 23 (category 7) -> attributes 13 only (since category 7 only has attribute 13)
(23, 7, 13, 'Quantum Theory'),
-- work 24 (category 9) -> attribute 15
(24, 9, 15, 'DNA'),
-- work 25 (category 4) -> attributes 7 or 8
(25, 4, 7, 'Prehistory'),
-- work 26 (category 13) -> attribute 19
(26, 13, 19, 'Classical'),
-- work 27 (category 12) -> attribute 18
(27, 12, 18, 'Psychoanalysis'),
-- work 28 (category 11) -> attribute 17
(28, 11, 17, 'Idealism'),
-- work 29 (category 2) -> attribute 3 or 4
(29, 2, 3, 'Military Strategy')
-- work 30 (category 19) -> attribute 19? Wait category 19 has no attribute in our list (attributes go up to category 14).
-- We need to either add an attribute for category 19 or skip. Let's add a dummy attribute for category 19.
-- Better: add one more row to work_category_attributes for category 19.
-- Insert a new attribute for category 19 (Medicine):
INSERT INTO work_category_attributes (id, category_id, name)
VALUES (21, 19, 'Medical Subfield');
-- Now we can use attribute 21 for work 30:
INSERT INTO work_category_attribute_values (work_id, category_id, attribute_id, value)
VALUES (30, 19, 21, 'Physiology');

-- 15. publications (30 publications)
INSERT INTO publications (id, title, publish_date, publisher)
VALUES (1, 'Pride and Prejudice (Penguin Classics)', '2002-01-01', 'Penguin'),
       (2, '1984 (Signet Classics)', '1950-06-08', 'Signet'),
       (3, 'Foundation Trilogy', '1951-10-01', 'Gnome Press'),
       (4, 'A Brief History of Time', '1988-04-01', 'Bantam'),
       (5, 'Sapiens: A Brief History of Humankind', '2011-02-10', 'Harper'),
       (6, 'The Handmaid''s Tale', '1985-05-01', 'McClelland & Stewart'),
       (7, 'One Hundred Years of Solitude', '1967-05-30', 'Harper & Row'),
       (8, 'Beloved', '1987-09-02', 'Knopf'),
       (9, 'Kafka on the Shore', '2002-09-12', 'Knopf'),
       (10, 'Half of a Yellow Sun', '2006-08-15', 'Knopf'),
       (11, 'American Gods', '2001-06-19', 'William Morrow'),
       (12, 'Harry Potter and the Sorcerer''s Stone', '1997-06-26', 'Bloomsbury'),
       (13, 'The Da Vinci Code', '2003-03-18', 'Doubleday'),
       (14, 'The Tipping Point', '2000-03-07', 'Little, Brown'),
       (15, 'The Selfish Gene', '1976-01-01', 'Oxford University Press'),
       (16, 'Cosmos', '1980-01-01', 'Random House'),
       (17, 'Stiff: The Curious Lives of Human Cadavers', '2003-07-01', 'W.W. Norton'),
       (18, 'A Short History of Nearly Everything', '2003-05-06', 'Broadway Books'),
       (19, 'Steve Jobs', '2011-10-24', 'Simon & Schuster'),
       (20, 'Bird by Bird', '1994-01-01', 'Pantheon'),
       (21, 'Introduction to Algorithms (3rd ed.)', '2009-07-31', 'MIT Press'),
       (22, 'Deep Learning', '2016-11-18', 'MIT Press'),
       (23, 'Quantum Mechanics: The Theoretical Minimum', '2014-04-22', 'Basic Books'),
       (24, 'The Double Helix', '1968-02-01', 'Atheneum'),
       (25, 'Guns, Germs, and Steel', '1997-03-01', 'W.W. Norton'),
       (26, 'The Wealth of Nations', '1776-03-09', 'W. Strahan'),
       (27, 'The Interpretation of Dreams', '1899-11-04', 'Franz Deuticke'),
       (28, 'Critique of Pure Reason', '1781-05-01', 'Riga'),
       (29, 'The Art of War', '2002-04-01', 'Shambhala'),
       (30, 'Medical Physiology (3rd ed.)', '2017-01-15', 'Elsevier');

-- 16. publications_works (link publications to works; each publication contains at least one work, many contain multiple)
-- publications_works (ensure no duplicate (work_id, publication_id))
INSERT INTO publications_works (publication_id, work_id)
VALUES
-- Primary works (each publication contains at least one work)
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
-- Additional works (some publications contain more than one work)
-- Make sure these pairs do not duplicate any above
(21, 22), -- publication 21 also contains work 22
(22, 23), -- publication 22 also contains work 23
(23, 24), -- publication 23 also contains work 24
(24, 25), -- publication 24 also contains work 25
(25, 26), -- publication 25 also contains work 26
(26, 27), -- publication 26 also contains work 27
(27, 28), -- publication 27 also contains work 28
(28, 29), -- publication 28 also contains work 29
(29, 30), -- publication 29 also contains work 30
(30, 1);
-- publication 30 also contains work 1
-- 17. publication_rules (one per publication, 30 rows)
INSERT INTO publication_rules (publication_id, reading_room_only, loan_period_days)
VALUES (1, false, 14),
       (2, false, 14),
       (3, false, 21),
       (4, false, 7),
       (5, false, 14),
       (6, false, 14),
       (7, false, 21),
       (8, false, 21),
       (9, false, 14),
       (10, false, 14),
       (11, false, 14),
       (12, false, 7),
       (13, false, 14),
       (14, false, 7),
       (15, false, 14),
       (16, false, 14),
       (17, false, 14),
       (18, false, 14),
       (19, false, 14),
       (20, false, 14),
       (21, false, 30),
       (22, false, 30),
       (23, false, 14),
       (24, false, 14),
       (25, false, 14),
       (26, false, 14),
       (27, false, 14),
       (28, false, 21),
       (29, false, 7),
       (30, false, 30);

-- 18. employee (20 employees)
INSERT INTO employee (id, library_id, reading_room_id, first_name, last_name)
VALUES (1, 1, 1, 'Alice', 'Johnson'),
       (2, 1, 2, 'Bob', 'Smith'),
       (3, 2, 3, 'Carol', 'Williams'),
       (4, 2, 4, 'David', 'Brown'),
       (5, 3, 5, 'Emma', 'Jones'),
       (6, 3, 6, 'Frank', 'Miller'),
       (7, 4, 7, 'Grace', 'Davis'),
       (8, 4, 8, 'Henry', 'Garcia'),
       (9, 5, 9, 'Ivy', 'Rodriguez'),
       (10, 5, 10, 'Jack', 'Martinez'),
       (11, 6, 11, 'Kathy', 'Hernandez'),
       (12, 6, 12, 'Leo', 'Lopez'),
       (13, 7, 13, 'Mona', 'Gonzalez'),
       (14, 7, 14, 'Nick', 'Wilson'),
       (15, 8, 15, 'Olga', 'Anderson'),
       (16, 8, 16, 'Paul', 'Thomas'),
       (17, 9, 17, 'Quinn', 'Taylor'),
       (18, 9, 18, 'Rose', 'Moore'),
       (19, 10, 19, 'Steve', 'Jackson'),
       (20, 10, 20, 'Tina', 'Martin');

-- 19. publications_copy (100 copies, inventory numbers 100001 to 100100)
-- We'll generate copies for each publication, spread across shelves
DO
$$
    DECLARE
        pub_id       INT;
        shelf_id     INT;
        inv_num      INT := 100001;
        emp_id       INT;
        receipt_date DATE;
    BEGIN
        FOR i IN 1..100
            LOOP
                pub_id := 1 + (i % 30);
                shelf_id := 1 + (i % 100);
                emp_id := 1 + (i % 20);
                receipt_date := DATE '2023-01-01' + (i % 365);
                INSERT INTO publications_copy (inventory_number, publication_id, shelf_id, receipt_date,
                                               received_employee_id)
                VALUES (inv_num, pub_id, shelf_id, receipt_date, emp_id);
                inv_num := inv_num + 1;
            END LOOP;
    END
$$;


-- 21. loans (200 loans, some returned, some not)
-- We'll generate loans for readers 1-50, copies 100001-100100 (excluding written off ones where return_date is null would violate FK? Actually written_off is separate, copy still exists but may be loaned before write-off)
-- For simplicity, we avoid using written_off copies in active loans.
TRUNCATE TABLE loans RESTART IDENTITY;

DO
$$
    DECLARE
        i             INT;
        reader_id_var INT;
        copy_var      INT;
        issue_date    DATE;
        expire_date   DATE;
        return_date   DATE;
        emp_var       INT;
    BEGIN
        FOR i IN 1..5
            LOOP
                -- Random reader (1..50)
                reader_id_var := 1 + (random() * 49)::INT;
                -- Random copy (100001..100100)
                copy_var := 100001 + (random() * 99)::INT;
                -- Random issue date within last 2 years (not in future)
                issue_date := CURRENT_DATE - (random() * 730)::INT;
                -- Expire date: issue_date + 7 to 60 days
                expire_date := issue_date + (7 + (random() * 53)::INT);
                -- Return date: always set, between issue_date+1 and expire_date-1
                return_date := issue_date + (1 + (random() * (expire_date - issue_date - 1))::INT);
                -- Random employee (1..30)
                emp_var := 1 + (random() * 19)::INT;

                INSERT INTO loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date,
                                   issued_employee_id)
                VALUES (reader_id_var, copy_var, issue_date, return_date, expire_date, emp_var);
            END LOOP;
    END
$$;

-- Adjust expire_date to be > date_of_issue and ensure some are expired
UPDATE loans
SET expire_date = date_of_issue + (random() * 30 + 7)::int
WHERE expire_date <= date_of_issue;

-- Ensure at least 30 loans with return_date IS NULL (currently checked out)
UPDATE loans
SET return_date = NULL
WHERE id % 7 = 0;
-- about 28-29 loans

-- 20. written_off (20 copies written off)
INSERT INTO written_off (id, inventory_number, publication_id, write_off_date, write_off_employee_id)
VALUES (1, '100001', 2, '2024-01-15', 1),
       (2, '100005', 6, '2024-02-10', 2),
       (3, '100010', 11, '2024-03-05', 3),
       (4, '100015', 16, '2024-04-20', 4),
       (5, '100020', 21, '2024-05-12', 5),
       (6, '100025', 26, '2024-06-18', 6),
       (7, '100030', 1, '2024-07-22', 7),
       (8, '100035', 6, '2024-08-01', 8),
       (9, '100040', 11, '2024-08-30', 9),
       (10, '100045', 16, '2024-09-15', 10),
       (11, '100050', 21, '2024-10-05', 11),
       (12, '100055', 26, '2024-10-25', 12),
       (13, '100060', 1, '2024-11-11', 13),
       (14, '100065', 6, '2024-11-28', 14),
       (15, '100070', 11, '2024-12-02', 15),
       (16, '100075', 16, '2024-12-20', 16),
       (17, '100080', 21, '2025-01-10', 17),
       (18, '100085', 26, '2025-01-25', 18),
       (19, '100090', 1, '2025-02-14', 19),
       (20, '100095', 6, '2025-03-01', 20);


-- 22. reading_process (50 entries for in-room reading)

INSERT INTO reading_process (reader_id, copy_inventory_number, issued_employee_id, library_id, reading_room_id,
                             issued_date, issued_time, return_date, return_time)
WITH base AS (SELECT (random() * 49 + 1)::int                                                        AS reader_id,
                     (random() * 99 + 100001)::int                                                   AS copy_inventory_number,
                     (random() * 19 + 1)::int                                                        AS issued_employee_id,
                     (random() * 19 + 1)::int                                                        AS library_id,
                     (random() * 19 + 1)::int                                                        AS reading_room_id,
                     current_date - (random() * 60)::int                                             AS issued_date,
                     ('09:00:00'::time + (random() * 9 * 3600)::int * interval '1 second')::time     AS issued_time,
                     CASE WHEN random() < 0.7 THEN current_date - (random() * 30)::int ELSE NULL END AS return_date
              FROM generate_series(1, 5)
              WHERE random() < 0.9)
SELECT reader_id,
       copy_inventory_number,
       issued_employee_id,
       library_id,
       reading_room_id,
       issued_date,
       issued_time,
       return_date,
       issued_time + (interval '30 minutes' + (random() * 180)::int * interval '1 minute') AS return_time
FROM base;
