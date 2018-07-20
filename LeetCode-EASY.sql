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

