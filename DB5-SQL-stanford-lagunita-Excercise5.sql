# Exercise 5: SQL Movie-Rating Modification Exercises

-- Q1. Add the reviewer Roger Ebert to your database, with an rID of 209. 

INSERT INTO Reviewer values(209, 'Roger Ebert')

-- Q2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 

INSERT INTO Rating(rID, mID, stars,ratingDate)
SELECT rID, mID, 5, null
FROM Reviewer, Movie
WHERE name = 'James Cameron'

-- Q3.For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 

-- Solution 1:
update Movie
set year = year+25
where mID in
  (select mID
  from Rating
  group by mID
  having avg(stars) >= 4)

-- Solution 2:
UPDATE Movie SET year = year+25
WHERE mID in
	(SELECT mID
	FROM 
		(SELECT mID, avg(stars) avg
		from Rating 
		GROUP BY mID
		) Avgrating
	WHERE avg >= 4
	)

-- Q4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
DELETE FROM Rating
WHERE stars < 4
	AND mID in
		(SELECT mID
		FROM Movie
		WHERE year > 2000
			OR year < 1970	
		)
