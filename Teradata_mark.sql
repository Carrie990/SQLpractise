-- Q1. how to select 10 records using Teradata
-- 1. any 10 records
  SELECT *
  FROM table
  SAMPLE 10;
-- 2. conditional N records
  SELECT column1, rank(colum2) AS rnk
  FROM table
  QUALIFY (rnk>10 and rnk<21)

-- Q2. CREATE TABLE
CREATE SET TABLE EMPLOYEE,FALLBACK ( 
   EmployeeNo INTEGER, 
   FirstName VARCHAR(30), 
   LastName VARCHAR(30), 
   DOB DATE FORMAT 'YYYY-MM-DD', 
   JoinedDate DATE FORMAT 'YYYY-MM-DD', 
   DepartmentNo BYTEINT 
) 
UNIQUE PRIMARY INDEX ( EmployeeNo );

-- Q3. sets manipulation
-- intersect
SELECT col1, col2, col3… 
FROM  
<table 1>
[WHERE condition] 
INTERSECT 

SELECT col1, col2, col3… 
FROM  
<table 2> 
[WHERE condition];

-- MINUS/EXCEPT
SELECT EmployeeNo 
FROM  
Employee 
MINUS 

SELECT EmployeeNo 
FROM  
Salary;

-- SUBSTRING/||
String Function	Result
SELECT SUBSTRING(‘warehouse’ FROM 1 FOR 4)	ware
SELECT SUBSTR(‘warehouse’,1,4)	ware
SELECT ‘data’ || ‘ ‘ || ‘warehouse’	data warehouse
SELECT UPPER(‘data’)	DATA
SELECT LOWER(‘DATA’)	data

--  EXTRACT
SELECT EXTRACT(YEAR FROM CURRENT_DATE);  

-- DATE
SELECT CURRENT_DATE, CURRENT_DATE + INTERVAL '03' YEAR; 


