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
SELECT f1.ID1 A, f2.ID2 C
FROM Friend f1, Friend f2
WHERE f1.ID2 = f2.ID1
    AND f1.ID1 <> f2.ID2
    AND f2.ID2 NOT IN(
        SELECT f3.ID2
        FROM Friend f3
        WHERE f3.ID1 = f1.ID1
    )
GROUP BY A,C
