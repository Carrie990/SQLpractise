-- 262. Trips and Users
-- Write a SQL query to find the cancellation rate of requests made by unbanned users between Oct 1, 2013 and Oct 3, 2013. 
-- For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

SELECT Request_at AS Day, ROUND(COUNT(IF(Status != 'completed',True,NULL))/COUNT(*),2) AS 'Cancellation Rate'
FROM Trips
WHERE Request_at IN ('2013-10-01','2013-10-02','2013-10-03')
    AND Client_Id NOT IN(
        SELECT Users_Id
        FROM Users
        WHERE Banned = 'Yes'
    ) 
GROUP BY Day

--185. Department Top Three Salaries
-- Write a SQL query to find employees who earn the top three salaries in each of the department.
-- Id | Name  | Salary | DepartmentId  -- Id | Name     |  --Department | Employee | Salary 

SELECT d.Name AS Department, e1.Name AS Employee, e1.Salary
FROM Department d, Employee e1
WHERE d.Id = e1.DepartmentId
  AND 3>(
    SELECT COUNT(DISTINCT e2.Salary)
    FROM Employee e2
    WHERE e1.DepartmentId = e2.DepartmentId
        AND e2.Salary > e1.Salary
  )
ORDER BY Department,e1.Salary DESC



