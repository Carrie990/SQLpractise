#  Exercise4: SQL Social-Network Query Exercises Extras

-- Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
-- Solution1: make sure that B like a different student C, but B can also like A

SELECT H1.name, H1.grade,H2.name, H2.grade,H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3,	
	(SELECT L1.ID1, L1.ID2, L2.ID2 ID3
	FROM Likes L1, Likes L2
	WHERE L1.ID2= L2.ID1
		AND L1.ID1 <> L2.ID2
	) ABC
WHERE H1.ID=ID1
	AND H2.ID=ID2
	AND H3.ID=ID3

-- Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

select name, grade
from Highschooler
where ID not in
  (select Friend.ID1
  from Highschooler H1, Highschooler H2, Friend
  where H1.ID = Friend.ID1
    and H2.ID = Friend.ID2
    and H1.grade = H2.grade
  )
  
-- Q3. What is the average number of friends per student? (Your result should be just one number.) 
-- in this problem, take care that there may be students who do not have friends

SELECT avg(num) avg
FROM
	(
	SELECT ID1, count(ID2) num
	FROM Friend
	GROUP BY ID1		
	UNION
	SELECT ID,0 num
	FROM Highschooler
	WHERE ID not in
		(SELECT ID1
		FROM Friend)
	) Fnum

-- Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 

-- Solution 1: 
select count(ID1)
from Highschooler H1, Highschooler H2,
  (select F1.ID1, F1.ID2, F2.ID2 ID3
  from Friend F1, Friend F2
  where F1.ID2 = F2. ID1
    and F1.ID1 <> F2.ID2
  ) ABC
where H1.ID = ID1
  and ((H2.ID = ID2 and H2.name = 'Cassandra')
      or (H2.ID = ID3 and H2.name = 'Cassandra'))

-- Solution 2: 
SELECT COUNT(friend) num
FROM
    (SELECT ID2  friend
    FROM Highschooler h, Friend f
    WHERE h.ID = f.ID1
        AND name = 'Cassandra'
    UNION
    SELECT f2.ID2 friend
    FROM Highschooler h, Friend f1, Friend f2
    WHERE ID = f1.ID1
        AND f1.ID2 = f2.ID1
        AND f1.ID1 <> f2.ID2
        AND name = 'Cassandra'
    ) num
 
-- Q5. Find the name and grade of the student(s) with the greatest number of friends. 

SELECT name, grade
FROM Highschooler,
	(SELECT ID1, count(ID2) num
	FROM Friend
	GROUP BY ID1
	) Fnum
WHERE ID = ID1
	AND num in
		(SELECT max(num)
		FROM (SELECT ID1, count(ID2) num
			FROM Friend
			GROUP BY ID1
			) Fnum
		)



  
