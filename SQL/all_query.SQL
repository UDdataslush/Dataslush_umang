CREATE DATABASE temp1;
CREATE DATABASE temp2;
CREATE DATABASE university;
CREATE DATABASE IF NOT EXISTS university;
DROP DATABASE temp1;
DROP DATABASE temp2;
DROP TABLE IF EXISTS institution;
USE university;
CREATE TABLE learner(
  rollno INT PRIMARY KEY,
  name VARCHAR(50)
);
SELECT * FROM learner;
INSERT INTO learner
(rollno, name)
VALUES
(201, "rohan"),
(202, "mohan"),
(203, "krishna");
INSERT INTO learner
(rollno, name)
VALUES
(204, "radha");
CREATE DATABASE abc_corp;
USE abc_corp;
CREATE TABLE staff(
 id INT PRIMARY KEY,
 name VARCHAR(100),
 salary INT
);
INSERT INTO staff
(id, name, salary)
VALUES
(1, "alex", 27000),
(2, "ben", 32000),
(3, "carla", 42000);
SELECT * FROM staff;
CREATE TABLE learner(
 rollno INT PRIMARY KEY,
 name VARCHAR(50),
 marks INT NOT NULL,
 grade VARCHAR(1),
 city VARCHAR(20)
);
INSERT INTO learner
(rollno, name, marks, grade, city)
VALUES
(201, "amit", 76, "C", "Chennai"),
(202, "bijal", 92, "A", "Bangalore"),
(203, "chirag", 84, "B", "Bangalore"),
(204, "deepa", 95, "A", "Hyderabad"),
(205, "edward", 18, "F", "Hyderabad"),
(206, "fatima", 81, "B", "Hyderabad");
SELECT * FROM learner;
SELECT DISTINCT city FROM learner;
SELECT * FROM learner WHERE marks > 80;
SELECT * FROM learner WHERE city = "Bangalore";
SELECT * FROM learner WHERE marks < 80 AND city = "Hyderabad";
SELECT * FROM learner WHERE marks BETWEEN 70 AND 80;
SELECT * FROM learner WHERE city NOT IN ("Hyderabad", "Bangalore");
SELECT * FROM learner LIMIT 3;
SELECT * FROM learner ORDER BY marks ASC;
SELECT * FROM learner ORDER BY marks DESC LIMIT 3;
SELECT MAX(marks) FROM learner;
SELECT MIN(marks) FROM learner;
SELECT SUM(marks) FROM learner;
SELECT AVG(marks) FROM learner;
SELECT city, COUNT(name) FROM learner GROUP BY city;
SELECT city FROM learner WHERE grade = "A" GROUP BY city;
UPDATE learner SET marks = 80 WHERE rollno = 201;
DELETE FROM learner WHERE marks < 30;
CREATE TABLE division(
 id INT PRIMARY KEY,
 name VARCHAR(50)
);
CREATE TABLE mentor(
 id INT PRIMARY KEY,
 name VARCHAR(50),
 division_id INT,
 FOREIGN KEY (division_id) REFERENCES division(id)
);
INSERT INTO division
VALUES
(201, "arts"),
(202, "technology");
INSERT INTO mentor
VALUES
(201, "alex", 201),
(202, "eva", 202);
USE university;
CREATE TABLE scholars(
 id INT PRIMARY KEY,
 name VARCHAR(50)
);
INSERT INTO scholars (id, name)
VALUES
(201, "alex"),
(202, "ben"),
(203, "carla");
CREATE TABLE module(
 id INT PRIMARY KEY,
 subject VARCHAR(50)
);
INSERT INTO module (id, subject)
VALUES
(202, "literature"),
(205, "mathematics"),
(203, "physics"),
(207, "computer science");
SELECT * FROM scholars;
SELECT * FROM module;
SELECT * FROM scholars INNER JOIN module ON scholars.id = module.id;
SELECT * FROM scholars LEFT JOIN module ON scholars.id = module.id;
SELECT * FROM scholars RIGHT JOIN module ON scholars.id = module.id;
SELECT *
FROM scholars
LEFT JOIN module
ON scholars.id = module.id;
UNION
SELECT *
FROM scholars
RIGHT JOIN module
ON scholars.id = module.id;
