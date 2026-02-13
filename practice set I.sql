-- Question 1
-- Create the tables below in the database. Use foreign keys and primary keys as required. 
-- a. Create a table called as student with the following columns student_id, first_name,  
-- last_name ,birthdate , department_id  ,address_id .  
-- b. Create Address table with following columns address_id , street_address, city, State, 
-- postal_code  
-- c. Create department table department_id, department name. Make sure you are using 
-- the right data type against all the columns.
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    department_id INT REFERENCES department(department_id),
    address_id INT REFERENCES address(address_id)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY,
    street_address VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT
);

CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Question 2 Use Sample data from sampledata.txt to insert data into the database
INSERT INTO STUDENT VALUES
(1,'John','Doe','1995-04-15',1,1),
(2,'Jane','Smith','1996-07-22',2,2),
(3,'Alice','Johnson','1994-11-30',3,3),
(4,'Michael','Brown','1997-02-19',4,4),
(5,'Sophia','Davis','1998-01-05',5,5),
(6,'Daniel','Wilson','1995-06-10',6,6),
(7,'Olivia','Martinez','1997-11-25',1,7),
(8,'Ethan','Miller','1996-03-30',2,8);

SELECT * FROM STUDENT;

INSERT INTO ADDRESS VALUES
(1,'123 Elm St','Springfield','C',62701),
(2,'C','Decatur','IL',62521),
(3,'789 Pine St','Champaign','IL',61820),
(4,'102 Birch Rd','Peoria','IL',61602),
(5,'205 Cedar Ave','Chicago','IL',60601),
(6,'310 Maple Dr','Urbana','IL',61801),
(7,'415 Oak Blvd','Champaign','IL',61821),
(8,'520 Pine Rd','Carbondale','IL',62901);

SELECT * FROM ADDRESS;


INSERT INTO DEPARTMENT VALUES
(1,'Computer Science'),
(2,'Mechanical Engineering'),
(3,'Electrical Engineering'),
(4,'Mechanical Engineering'),
(5,'Mathematics'),
(6,'Biology');

SELECT * FROM DEPARTMENT;

-- Question 3 Write a query to find the total number of students. 
SELECT COUNT(*) FROM STUDENT ;

-- Question 4 Write a query to find which department john belongs to. 
SELECT d.department_id, department_name FROM department d JOIN student s on d.department_id=s.department_id where s.first_name='John';

-- Question 5 List All Departments with Their Number of Students (Including Departments with No Students) 
SELECT d.department_name , COUNT(s.student_id) FROM department d LEFT JOIN student s ON d.department_id=s.department_id GROUP BY d.department_name;

-- Question 6 Select all students with their department and address. 
SELECT d.department_name,a.street_address,a.city,a.state FROM student s JOIN department d ON d.department_id=s.department_id JOIN address a ON a.address_id=s.address_id;

-- Question 7 Find all students who are in the 'Computer Science' department  
SELECT s.first_name,s.last_name,d.department_name FROM student s JOIN department d ON s.department_id=d.department_id WHERE d.department_name='Computer Science';

-- Question 8 Update Jane’s city name to New York.
UPDATE address a
SET city = 'New York'
FROM student s
WHERE s.address_id = a.address_id
AND s.first_name = 'Jane';

-- Question 9 Delete a student from the student table. 
DELETE FROM student WHERE first_name='John';

-- Question 10 Select all students with their department and address in New York. 
SELECT s.student_id,s.first_name,s.last_name,s.birthdate, d.department_name,a.city FROM student s JOIN department d ON s.department_id=d.department_id 
JOIN address a ON a.address_id=s.address_id
WHERE a.city='New York';

-- Question 11  Count how many students are in each department
SELECT department_id,COUNT(*) FROM student GROUP BY department_id ;

-- Question 12 Find students who live in 'Springfield'  
SELECT s.student_id,s.first_name,s.last_name,s.birthdate FROM student s JOIN address a ON s.address_id=a.address_id
WHERE a.city='Springfield';

-- Question 13 Select students whose birthday falls in February
SELECT * FROM student
WHERE EXTRACT(MONTH FROM birthdate) = 2;

-- Question 14 Get the department and address details for a specific student, example john 
SELECT s.first_name,d.department_id,d.department_name,a.address_id,a.street_address,a.city,a.state FROM student s JOIN address a ON s.address_id=a.address_id 
JOIN department d ON d.department_id =s.department_id WHERE s.first_name='Jane';

-- Question 15 Find all students who are born within 1995 to 1998
SELECT * FROM student WHERE EXTRACT(YEAR FROM birthdate) BETWEEN 1995 AND 1998;

-- Question 16 List all students and their corresponding department names, sorted by department 
SELECT s.first_name,s.last_name,d.department_name FROM student s 
JOIN department d ON s.department_id=d.department_id 
ORDER BY d.department_name;

-- Question 17  Find the number of students in each department who are living in 'Champaign'.
SELECT s.department_id, COUNT(*) FROM student s
JOIN address a ON s.address_id = a.address_id
WHERE a.city = 'Champaign'
GROUP BY s.department_id;

-- Question 18 Retrieve the names of students who live on 'Pine' street.
SELECT s.first_name,s.last_name,a.street_address FROM student s 
JOIN address a ON s.address_id=a.address_id 
WHERE a.street_address LIKE '%Pine%';

-- Question 19 Update the department of a student with student_id = 6 to 'Mechanical Engineering' 
UPDATE department d
SET department_name='Mechanical Engineering'
FROM student s
WHERE s.department_id=d.department_id
AND s.student_id=6;

-- Question 20 Find the student(s) who live in the city 'Chicago' and are in the 'Mathematics' department 
SELECT s.first_name,s.last_name,a.city,d.department_name FROM student s
JOIN department d ON d.department_id=s.department_id
JOIN address a ON a.address_id=s.address_id
WHERE a.city='Chicago' AND d.department_name='Mathematics';

-- Question 21  List all students who have an address in 'Urbana' or 'Peoria'  
SELECT s.first_name,s.last_name,a.city FROM student s 
JOIN address a ON s.address_id=a.address_id
WHERE a.city='Urbana' OR a.city='Peoria';

-- Question 22 Find the student with the highest student_id 
SELECT student_id,first_name,last_name FROM student WHERE student_id=(SELECT MAX(student_id) FROM student); 

-- Question 23  Find all students who are not in the 'Computer Science' department  
SELECT s.first_name,s.last_name,d.department_name FROM student s 
JOIN department d ON d.department_id=s.department_id
WHERE d.department_name<>'Computer Science';

-- Question 24 Count the total number of addresses in the 'Champaign' city.
SELECT COUNT(*) FROM address WHERE city='Champaign';

-- Question 25 Find the name of the student who lives at '520 Pine Rd'  
SELECT s.first_name,s.last_name,a.street_address FROM student s 
JOIN address a ON s.address_id=a.address_id
WHERE a.street_address='520 Pine Rd';

-- Question 26 Get the average age of students in the 'Electrical Engineering' department  
SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.birthdate)))
FROM student s
JOIN department d ON s.department_id = d.department_id
WHERE d.department_name = 'Electrical Engineering';

-- Question 27 List the students, their department, and the city where they live, but only for those in departments starting with 'M'  
SELECT s.first_name,s.last_name,d.department_name,a.city FROM student s 
JOIN department d ON d.department_id=s.department_id 
JOIN address a ON s.address_id=a.address_id
WHERE d.department_name LIKE 'M%';

-- Question 28 Delete a student from the 'Mechanical Engineering' department 
DELETE FROM student WHERE department_id IN (SELECT department_id FROM department
WHERE department_name='Mechanical Engineering');







