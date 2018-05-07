# Exercise 6:  SQL Social-Network Modification Exercises

-- Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
delete from Highschooler
where grade = 12

-- Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

delete from Likes
where ID1 in (
  select ID1 
  from Friend
  where Likes.ID1 = Friend.ID1
    and Likes.ID2 = Friend.ID2
  )
  and ID1 not in(
  select L2.ID2
  from Likes L2
  where Likes.ID2 = L2.ID1
  )

-- Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
INSERT INTO Friend
	SELECT A, C
	FROM 
	(SELECT F1.ID1 A, F2.ID2 C
	FROM Friend F1, Friend F2
	WHERE F1.ID2 = F2.ID1
		AND F1.ID1 <> F2.ID2
    GROUP BY F1.ID1, F2.ID2
	) AC
	WHERE A not in (
	SELECT ID1
	FROM Friend
	WHERE C = ID2
	)
