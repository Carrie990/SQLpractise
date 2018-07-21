-- 177. Nth Highest Salary
-- Write a SQL query to get the nth highest salary from the Employee table.
-- Solution 1
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N=N-1;
  RETURN (
      # Write your MySQL query statement below.
    
      select IFNULL((select distinct salary from employee order by salary desc limit N,1),NULL)
     
  );
END

# Solution 2 - pass
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE M INT;
    SET M = N-1;
    RETURN (
        # Write your MySQL query statement below.
        SELECT 
        CASE
            WHEN COUNT(DISTINCT Salary) <= M THEN NULL
            ELSE (SELECT DISTINCT Salary 
                 FROM  Employee
                 ORDER BY Salary DESC
                 LIMIT M,1)
        END
        FROM Employee 
    );
END


-- 184. Department Highest Salary
-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
-- Solution 1
SELECT D.Name Department, E1.Name Employee, E1.Salary
FROM Employee E1, Department D
WHERE E1.DepartmentId = D.Id
    AND 1 > (SELECT COUNT(1)
           FROM Employee E2
           WHERE E2.Salary > E1.Salary
                AND E1.DepartmentId = E2.DepartmentId
  )
-- Solution 2
SELECT Department.Name AS Department, Employee.Name AS Employee, Employee.Salary
FROM Employee, Department,
    (SELECT DepartmentId, Max(Salary) AS Salary
    FROM Employee
    GROUP BY DepartmentId) Matching
WHERE Employee.DepartmentId = Department.Id
    AND Department.Id = Matching.DepartmentId
    AND Employee.Salary = Matching.Salary

-- 178. Rank Scores
-- Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.
-- Solution 1
SELECT Scores.Score, Rank
FROM Scores,
    (SELECT Score, @Rank := @Rank+1 AS Rank
    FROM
        (SELECT DISTINCT Score
        FROM Scores
        ORDER BY Score DESC
         ) DistinctScore,
         (select @Rank := 0) R
     ) Rank
WHERE Scores.Score = Rank.Score
ORDER BY Scores.Score DESC





