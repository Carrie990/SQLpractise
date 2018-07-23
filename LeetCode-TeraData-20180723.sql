-- 569.Median Employee Salary 
-- https://leetcode.com/articles/median-employee-salary/
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.
-- |Id   | Company    | Salary |
-- MySQL

SELECT 
    Id, Company, Salary
FROM
    (SELECT 
        e.Id,
            e.Salary,
            e.Company,
            IF(@prev = e.Company, @Rank:=@Rank + 1, @Rank:=1) AS rank,
            @prev:=e.Company
    FROM
        Employee e, (SELECT @Rank:=0, @prev:=0) AS temp
    ORDER BY e.Company , e.Salary , e.Id) Ranking
        INNER JOIN
    (SELECT 
        COUNT(*) AS totalcount, Company AS name
    FROM
        Employee e2
    GROUP BY e2.Company) companycount ON companycount.name = Ranking.Company
WHERE
    Rank = FLOOR((totalcount + 1) / 2)
        OR Rank = FLOOR((totalcount + 2) / 2)
;

-- TeraData (?)
WITH EmployeeRank AS (
    SELECT Company,RANK() OVER(ORDER BY Salary) AS rank
    FROM Employee
    GROUP BY Company
)
SELECT Company,
    CASE
        WHEN MOD(COUNT(Employee),2) = 1 THEN (SELECT Salary
             FROM Employee
             WHERE rank = COUNT(Employee)/2+1
             )
        ELSE SELECT AVG(Salary)
             FROM (SELECT Salary
                   FROM Employee
                   WHERE rank = COUNT(Employee)/2
                        OR rank = COUNT(Employee)/2+1
             ) temp
    END AS Median
FROM Employee
GROUP BY Company

-- 579. Find Cumulative Salary of an Employee 
-- https://leetcode.com/articles/find-cumulative-salary-of-an-employee/
-- | Id | Month | Salary |
-- TeraData
WITH Ranking AS(
    SELECT Id, Month, Salary, RANK() OVER (ORDER BY Month DESC) AS rnk
    FROM Employee
    WHERE rnk in (2,3,4)
    ORDER BY ID, rnk
)
SELECT Id, Month,
    CASE
        WHEN rnk = 2 THEN (SELECT SUM(Salary)
                          FROM (SELECT Salary
                                FROM Ranking) t1
                           )
        WHEN rnk = 3 THEN (SELECT SUM(Salary)
                          FROM (SELECT Salary
                                FROM Ranking
                                WHERE rnk in (3,4)) t2
        ELSE (SELECT Salary
              FROM Ranking
              WHERE rnk = 4             
              )
    END
FROM Ranking
ORDER BY Id, Month DESC
