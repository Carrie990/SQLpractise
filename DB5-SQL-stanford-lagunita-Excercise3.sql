# Excercise3: SQL Social-Network Query Exercises

-- Q1.Find the names of all students who are friends with someone named Gabriel. 
---
SELECT name
FROM Highschooler
WHERE ID in
	(SELECT ID2
	FROM Highschooler, Friend
	WHERE ID = ID1
		AND name = 'Gabriel')

-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
--Solution1
SELECT h1.name name1, h1.grade grade1, h2.name name2, h2.grade grade2
FROM Highschooler h1, Likes l, Highschooler h2
WHERE h1.ID = l.ID1
    AND h2.ID = l.ID2
    AND h1.grade - h2.grade >= 2

--Solution2
select name,grade,name2,grade2
from Highschooler,
  (select ID1, ID2,name name2, grade grade2
  from Highschooler,Likes
  where ID2 = ID) Likesgrade
where ID = ID1
    and (grade-grade2) >= 2

-- Q3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
---Solution 1
SELECT h1.name name1, h1.grade grade1, h2.name name2, h2.grade grade2 
FROM Likes L1, Likes L2, Highschooler h1, Highschooler h2
WHERE L1.ID2 = L2.ID1
    AND L2.ID2 = L1.ID1
    AND h1.name < h2.name
    AND h1.ID = L1.ID1
    AND h2.ID = L1.ID2
    
---Solution2
SELECT *
FROM
	(SELECT name1,grade1, name name2, grade grade2
	FROM Highschooler,(
		SELECT ID1, name name1, grade grade1, ID2
		FROM Highschooler,
			(SELECT L1.ID1, L1.ID2
			FROM Likes L1, Likes L2
			WHERE L1.ID1 = L2.ID2
				AND L1.ID2 = L2.ID1) L 
		WHERE ID = L.ID1
		) R
	WHERE ID = ID2) NL
WHERE name1 <= name2

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
---
select name, grade
from Highschooler
where ID not in
  (select ID1
  from Likes
  union
  select ID2
  from Likes
  )
order by grade,name

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
---
SELECT h1.name Aname, h1.grade Agrade, h2.name Bname, h2.grade Bgrade
FROM Likes, Highschooler h1, Highschooler h2
WHERE ID1 = h1.ID
    AND ID2 = h2.ID
    AND ID2 NOT IN
    (SELECT ID1
    FROM Likes
    )

-- Q6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
---
-- Solution1:
SELECT name, grade
FROM Highschooler,Friend
WHERE ID = ID1
    AND ID NOT IN(
    SELECT h1.ID
    FROM Friend f, Highschooler h1, Highschooler h2
    WHERE f.ID1 = h1.ID
        AND f.ID2 = h2.ID
        AND h1.grade != h2.grade
    )
GROUP BY name
ORDER BY grade, name
  
-- Solution2:
  select name,grade
  from Highschooler
  where ID not in
    (select ID1
    from
      (select ID1, gradeA, ID2, grade gradeB
      from Highschooler,
      (select ID1, grade gradeA,ID2
      from Friend,Highschooler
      where ID = ID1
      ) F1
      where ID = ID2
      ) Fgrade
    where gradeA <> gradeB
    )
  order by grade,name

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
--Solution 1
SELECT h1.name Aname, h1.grade Agrade, h2.name Bname, h2.grade Bgrade, h3.name Cname, h3.grade Cgrade
FROM Likes, Highschooler h1, Highschooler h2, Highschooler h3,
    (SELECT f1.ID1 A, f2.ID2 B, f1.ID2 C
    FROM Friend f1, Friend f2
    WHERE f1.ID2 = f2.ID1
        AND f1.ID1 != f2.ID2
        AND f2.ID2 NOT IN(
            SELECT ID2
            FROM Friend
            WHERE ID1 = f1.ID1
        )
    ) f
WHERE Likes.ID1 = A
    AND Likes.ID2 = B
    AND h1.ID = A
    AND h2.ID = B
    AND h3.ID = C

-- Solution 2
SELECT Aname, Agrade,Bname,Bgrade,name Cname, grade Cgrade
FROM Highschooler,
	(SELECT Aname, Agrade, name Bname, grade Bgrade,C
	FROM Highschooler,
		(SELECT name Aname,grade Agrade,B,C
		FROM Highschooler,
			(select A,B,C,Friend.ID1 D, Friend.ID2 E
			from 
			  (select A,B,C
			  from Likes,
				 (select F1.ID1 A,F1.ID2 C, F2.ID2 B
				 from Friend F1, Friend F2
				 where F1.ID2 = F2.ID1
				  and F1.ID1 <> F2.ID2
				 ) Fcommon
			   where Likes.ID1 = Fcommon.A
				and Likes.ID2 = Fcommon.B
			   ) AlikeB
			left join Friend
			on A = ID1
				and B = ID2
			) ABCD
		WHERE ID = A
			AND D is NULL
		) ABC
	WHERE ID = B
	) AB
WHERE ID = C

-- Q8. Find the difference between the number of students in the school and the number of different first names. 
---
select count(distinct ID)-count(distinct name) difference
from Highschooler

-- Q9. Find the name and grade of all students who are liked by more than one other student. 
-- Solution 1
SELECT name, grade
FROM Highschooler h, Likes l
WHERE h.ID = l.ID2
GROUP BY l.ID2
HAVING COUNT(l.ID2)>1
    
--Solution 2
SELECT name,grade
SELECT name,grade
FROM Highschooler
WHERE ID in
	(select ID2
	from Likes
	group by ID2
	having count(ID1) > 1
	) 

   


