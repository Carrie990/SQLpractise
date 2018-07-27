-- 580. Count Student Number in Departments
-- Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).
-- MySQL
SELECT dept_name, COUNT(student_id) AS student_number
FROM department
LEFT JOIN student ON department.dept_id = student_dept_id
GROUP BY student.dept_id
ORDER BY student_number DESC, dept_name

-- TeraData
WITH stucnt AS (
    SELECT dept_id, COUNT(student_id) AS cnt      
    FROM student
    GROUP BY dept_id
)
SELECT dept_name, 
    IFNULL(cnt,0) AS student_number
FROM department
LEFT OUTER JOIN stucnt ON
department.dept_id = stucnt.dept_id
ORDER BY cnt DESC, dept_name

-- 618. Students Report By Geography 
-- https://leetcode.com/articles/students-report-by-geography/
-- 
-- TeraData 
SELECT America, Asia, Europe
FROM (SELECT name AS America, RANK() OVER(ORDER by name) AS amid
     FROM student
     WHERE continent = 'America'
     ) T1,
     (SELECT name AS Asia, RANK() OVER(ORDER BY name) AS asid
      FROM student
      WHERE continent = 'Asia'  
     ) T2,
     (SELECT name AS Europe, RANK() OVER(ORDER BY name) AS euid
      FROM student
      WHERE continent = 'Europe'
     ) T3
WHERE amid = asid
    AND asid = euid
ORDER BY amid

-- Solution 2
WITH America AS (
    SELECT name AS America, RANK() OVER(ORDER BY name) AS amid
    FROM student
    WHERE continent = 'America'
), Asia AS (
    SELECT name AS Asia, RANK() OVER(ORDER BY name) AS asid
    FROM student
    WHERE continent = 'Asia'
), Europe AS (
    SELECT name AS Europe, RANK() OVER(ORDER BY name) AS euid
    FROM student
    WHERE continent = 'Europe'
)
SELECT America, Asia, Europe
FROM America, Asia, Europe
WHERE amid = asid
    AND asid = euid

         
       
-- 571. Find Median Given Frequency of Numbers
-- https://jogchat.com/shuati/60%E5%A4%A9%E5%B8%A6%E4%BD%A0%E5%88%B7%E5%AE%8CLeetcode%E3%80%90%E7%AC%AC11%E5%A4%A9%E3%80%91574%20_%20564.php
WITH FreCnt AS(
    SELECT N1.Number, N1.Frequency, SUM(N2.Frequency)-N1.Frequency+1 AS StartFre, SUM(N2.Frequency) AS EndFre
    FROM Number N1, Number N2
    WHERE N1.Number >= N2.Number
    GROUP BY N1.Number    
    ORDER BY N1.Number
), NumSum AS(
    SELECT SUM(Frequency) numsum
    FROM Numbers
)
SELECT
    CASE
        WHEN MOD(numsum,2) = 1 THEN (SELECT Number
                                     FROM FreCnt
                                     WHERE StartFre <= (numsum/2+1) 
                                        AND EndFre >= (numsum/2+1))
        ELSE SELECT  AVG(Number) AS Number 
            FROM (SELECT Number 
                FROM FreCnt
                WHERE (StartFre <= numsum/2 AND EndFre >= numsum/2)
                    OR (StartFre <= (numsum/2+1) AND EndFre >= (numsum/2+1)) 
            ) Temp       
    END AS Median
 FROM NumSum

    

