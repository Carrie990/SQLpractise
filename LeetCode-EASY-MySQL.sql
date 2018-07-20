-- 176. Second Highest Salary
-- Write a SQL query to get the second highest salary from the Employee table.
-- Hints: for question that require to find the nth data, make sure if there is any
-- Solution 1
SELECT 
(CASE
    WHEN COUNT(DISTINCT Salary) <= 1 THEN NULL
    ELSE (SELECT max(Salary) 
         FROM Employee
         WHERE Salary not in
            (SELECT max(Salary)
             FROM Employee
            ))
END) AS SecondHighestSalary
FROM Employee

-- Solution 2
SELECT 
    IFNULL((SELECT max(Salary) 
          FROM Employee
          WHERE Salary not in
             (SELECT max(Salary)
              FROM Employee
             )),NULL) AS SecondHighestSalary
             
-- Solution 3
SELECT 
    CASE
        WHEN COUNT(DISTINCT Salary) <=1 THEN NULL
        ELSE (SELECT Salary
             FROM (SELECT DISTINCT Salary
                  FROM Employee
                  ORDER BY Salary DESC) OrderSalary
             LIMIT 1,1)
    END AS SecondHighestSalary
FROM Employee

-- 196. Delete Duplicate Emails
-- Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.
-- Solution 1
DELETE P1
FROM Person P1, Person P2
WHERE P1.Email = P2.Email
  AND P1.Id > P2.Id

-- Solution 2
DELETE 
FROM Person 
WHERE Id NOT IN(
  SELECT a.Id
  FROM (SELECT Email, min(Id) AS Id
        FROM Person
        GROUP BY Email
    )a
  )

-- 197. Rising Temperature
-- Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
SELECT W1.Id
FROM Weather W1, Weather W2
WHERE W1.Temperature > W2.Temperature
    AND W1.RecordDate = ADDDATE(W2.RecordDate,INTERVAL 1 DAY)

-- 596. Classes More Than 5 Students
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5

-- 183. Customers Who Never Order
-- Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.
SELECT Name AS Customers
FROM Customers
WHERE Id not in
    (SELECT CustomerId
     FROM Orders
    )

-- 175. Combine Two Tables
-- Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
ON Person.PersonId = Address.PersonId

-- 627. Swap Salary
-- Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.
UPDATE salary
SET sex = (
    CASE 
        WHEN sex = 'm' THEN  'f'
        ELSE 'm'
    END
    )
 
 


 
