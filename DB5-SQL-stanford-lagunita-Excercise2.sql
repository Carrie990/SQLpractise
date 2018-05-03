# Excercise2: SQL Movie-Rating Query Exercises Extras

-- Q1.Find the names of all reviewers who rated Gone with the Wind. 
select name
from Reviewer
where rID in 
  (select rID 
  from Movie, Rating
  where title = 'Gone with the Wind'
  and Movie.mID = Rating.mID)

-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from Movie,Reviewer,Rating
where Movie.mID = Rating.mID
  and Rating.rID = Reviewer.rID
  and name = director

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select name names
from Reviewer
Union
select title
from Movie names
order by names

-- Q4. Find the titles of all movies not reviewed by Chris Jackson. 
select title
from Movie
where mID not in
  (select mID
  from Rating, Reviewer
  where Rating.rID = Reviewer.rID
    and name = 'Chris Jackson'
  )
  
-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT R1.name reviewer1, R2.name reviewer2
FROM (SELECT name, mID
	FROM Reviewer Re, Rating Ra
	WHERE Re.rID = Ra.rID) R1,
	(SELECT name, mID
	FROM Reviewer Re, Rating Ra
	WHERE Re.rID = Ra.rID) R2
WHERE R1.name < R2.name
	AND R1.mID = R2.mID
group by reviewer1, reviewer2

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name,title,stars
from Reviewer,Movie,Rating
where Reviewer.rID = Rating.rID
  and Movie.mID = Rating.mID
  and stars in
    (select min(stars) minstar
    from Rating)
 
-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
  select title, avg(stars) star
  from Movie, Rating
  where Movie.mID = Rating.mID
  group by Movie.mID
  order by star desc, title

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

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, director
from Movie
where director in
  (select M1.director
  from Movie M1, Movie M2
  where M1.director = M2.director
    and M1.title > M2.title)
order by director,title

-- Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, star
FROM Movie,
	(SELECT mID, avg(stars) star
	FROM Rating
	GROUP BY mID) Ra,
	(select max(star) as mm
	FROM
		(SELECT mID, avg(stars) star
		FROM Rating
		GROUP BY mID) Ra
	) Max
WHERE Movie.mID = Ra.mID
	and Ra.star = Max.mm

-- Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, star
FROM Movie,
	(SELECT mID, avg(stars) star
	FROM Rating
	GROUP BY mID) Ra,
	(select min(star) as mm
	FROM
		(SELECT mID, avg(stars) star
		FROM Rating
		GROUP BY mID) Ra
	) Min
WHERE Movie.mID = Ra.mID
	and Ra.star = Min.mm

-- Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director,  title, max(stars)
FROM  
	(SELECT director, title, Movie.mID, stars
	FROM Movie, Rating
	WHERE Movie.mID = Rating.mID
		AND director is not NULL) R
GROUP BY director



