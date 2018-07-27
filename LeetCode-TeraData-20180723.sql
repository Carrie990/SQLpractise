-- 569.Median Employee Salary 
-- https://leetcode.com/articles/median-employee-salary/
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.
-- |Id   | Company    | Salary |
-- MySQL

SELECT
    Employee.Id, Employee.Company, Employee.Salary
FROM
    Employee,
    Employee alias
WHERE
    Employee.Company = alias.Company
GROUP BY Employee.Company , Employee.Salary
HAVING SUM(CASE
    WHEN Employee.Salary = alias.Salary THEN 1
    ELSE 0
END) >= ABS(SUM(SIGN(Employee.Salary - alias.Salary)))
ORDER BY Employee.Id

-- TeraData (?)
WITH rank AS (
    SELECT Id, Company, Salary, RANK() OVER(PARTITION BY Company ORDER BY Salary) AS rank
    FROM Employee
), cnt AS(
    SELECT Company, COUNT(*) AS num
    FROM Employee
    GROUP BY Company
)
SELECT Id, rank.Company, Salary
FROM rank,cnt 
WHERE rank.Company = cnt.Company
    AND (rank = (cnt+1)/2
         OR rank = (cnt+2)/2)


-- 579. Find Cumulative Salary of an Employee 
-- https://leetcode.com/articles/find-cumulative-salary-of-an-employee/
-- | Id | Month | Salary |
                           
-- MySQL
SELECT r1.ID, r1.Month, SUM(r2.Salary) AS Salary
FROM
    (SELECT Id, Month, Salary, @rnk := @rnk+1
    FROM Employee,
        (SELECT @rnk := 0) r
    GROUP BY Id
    ) r1, 
    (SELECT Id, Month, Salary, @rnk := @rnk+1
    FROM Employee,
        (SELECT @rnk := 0) r
    GROUP BY Id
    ) r2
WHERE r1.rnk in (2,3,4)
    AND r2.rnk IN (2,3,4)
    AND r2.rnk >= r1.rnk
GROUP BY r1.ID
ORDER BY Id, Month DESC

-- TeraData
WITH Ranking AS(
    SELECT Id, Month, Salary, RANK() OVER (PARTITION BY Id ORDER BY Month DESC) AS rnk
    FROM Employee
    ORDER BY ID, rnk
)
SELECT Id, Month, SUM(r2.Salary) AS Salary
FROM Ranking r1,Ranking r2
WHERE r1.rnk in (2,3,4)
    AND r2.rnk in (2,3,4)
    AND r2.rnk >= r1.rnk
GROUP BY Id
ORDER BY Id, Month DESC                         

-- 615. Average Salary: Departments VS Company
-- https://leetcode.com/articles/average-salary-departments-vs-company/
-- | id | employee_id | amount | pay_date   |,| employee_id | department_id |,| pay_month | department_id | comparison  |
-- TeraData
WITH JoinSalary AS(
    SELECT id, salary.employee_id, amount, SUBSTR(pay_date,1,7) AS pay_month, department_id
    FROM salary,employee
    WHERE salary.employee_id = employee.employee_id
), AvgCom AS(
    SELECT pay_month, AVG(amount) AS avgcom
    FROM JoinSalary
    GROUP BY pay_month
), AvgDept AS(
    SELECT department_id,pay_month, AVG(amount) AS avgdept
    FROM JoinSalary
    GROUP BY department_id, pay_month
)
SELECT AvgDept.pay_month, department_id, 
    CASE
        WHEN avgdept > avgcom THEN 'higher'
        WHEN avgdept < avgcom THEN 'lower'
        ELSE 'same'
    END AS comparison
FROM AvgDept,AvgCom
WHERE AvgDept.pay_month = AvgCom.pay_month
ORDER BY AvgDept.pay_month DESC, department_id
