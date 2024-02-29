CREATE SCHEMA starcompany;
SET SCHEMA 'starcompany';

-- create a table
CREATE TABLE employee(
    firstname varchar(15),
    lastname varchar(15),
    department varchar(3),
    salary bigint,
    employid smallint
);

-- insert into the table
INSERT INTO employee (firstname, lastname, department, salary, employid)
Values ('Anders', 'Hansen', 'A2', 18900, 24),
('Jakub', 'Kuka', 'A1', 23000, 1),
('Denitsa', 'Miteva', 'A3', 45000, 456),
('August', 'Kazlaukas', 'A1', 20500, 5),
('Oskar', 'Kabaliuk', 'A2', 15000, 23),
('Alexandru', 'Ghitun', 'A3', 5000, 90);

-- verifying
SELECT *
FROM employee;

-- altering the table
ALTER TABLE employee add age smallint;

UPDATE employee
SET age = '6'
WHERE employid = 24;

-- increasing the salary
UPDATE employee
SET salary = salary * 1.1
WHERE department='A1';

-- all employees from department A3
SELECT *
FROM employee
WHERE department = 'A3';

SELECT *
FROM employee
WHERE salary > 19000;

SELECT COUNT(*)
FROM employee
WHERE salary > 19000;

-- average salary from employee
SELECT AVG(salary)
FROM employee;

-- deleting the data
DELETE FROM employee
WHERE salary * 12 > 300000;

DELETE FROM employee
WHERE department = 'A3';

select * from employee;

delete from employee where firstname = 'Jakub';

DROP TABLE employee;

DROP SCHEMA starcompany;
