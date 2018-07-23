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
FROM (SELECT name AS America
     FROM student
     WHERE continent = 'America'
     ORDER BY name
     ) T1,
     (SELECT name AS Asia
      FROM student
      WHERE continent = 'Asia'
      ORDER BY name
     ) T2,
     (SELECT name AS Europe
      FROM student
      WHERE continent = 'Europe'
      ORDER BY name
     ) T3

-- FOLLOW UP
WITH stucnt AS(
    SELECT continent, COUNT(name) AS cnt, @rank:=rank+1 AS rank
    FROM student, 
        (SELECT @rank:=0) r    
    GROUP BY continent
    ORDER BY cnt DESC
)
SELECT (SELECT name 
        FROM student,stucnt
        WHERE rank = 1
        ORDER BY name
    ) AS (SELECT continent
         FROM stucnt
         LIMIT 1),
        (SELECT name 
        FROM student,stucnt
        WHERE rank = 2
        ORDER BY name
    ) AS (SELECT continent
         FROM stucnt
         LIMIT 1,1),
         (SELECT name 
        FROM student,stucnt
        WHERE rank = 3
        ORDER BY name
    ) AS (SELECT continent
         FROM stucnt
         LIMIT 2,1)
         
       



