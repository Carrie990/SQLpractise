# review the complex problems frequently


# Excercise2: SQL Movie-Rating Query Exercises Extras

-- Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name
FROM Reviewer
WHERE rID in 
	(SELECT R1.rID
 	FROM Rating R1, Rating R2, Rating R3
 	WHERE R1.rID = R2.rID
 		AND R2.rID = R3.rID
		AND ((R1.mID < R2.mID and R2.mID < R3.mID)
			 or( R1.ratingDate < R2.ratingDate AND R2.ratingDate < R3.ratingDate)))

-- Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director,  title, max(stars)
FROM  
	(SELECT director, title, Movie.mID, stars
	FROM Movie, Rating
	WHERE Movie.mID = Rating.mID
		AND director is not NULL) R
GROUP BY director


# Exercise 6

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

