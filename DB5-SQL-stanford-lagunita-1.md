# SQLpractise - the answer of lagunita stanford data

# Excercise1: SQL Movie-Rating Query Exercises

Q1. Find the titles of all movies directed by Steven Spielberg. 
---
  select title
  from Movie
  where director = 'Steven Spielberg'

Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
---
  SELECT DISTINCT year
  FROM Movie
  WHERE mID in 
  (select mID 
  from Rating
  WHERE stars IN (4,5)
  ) 
  ORDER BY year

Q3. Find the titles of all movies that have no ratings. 
---
  select title
  from Movie
  where mID not in
  (select mID
  from Rating
  )

Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
---
  SELECT DISTINCT name
  FROM Reviewer
  WHERE Reviewer.rID in
    (SELECT rID
     FROM Rating
     WHERE ratingDate is NULL
    )

Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
---
  SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate 
  FROM Reviewer, Movie, Rating
  WHERE Reviewer.rID = Rating.rID 
  AND Rating.mID = Movie.mID
  GROUP BY Reviewer.name, Movie.title, Rating.stars

Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
---
  select name, title
  from Movie, Reviewer,
      (select R1.mID, R1.rID
      from Rating R1, Rating R2
      where R1.mID = R2.mID
          and R1.rID = R2.rID
          and R2.stars > R1.stars
          and R2.ratingDate > R1.ratingDate
       ) MR
  where Movie.mID = MR.mID
      and Reviewer.rID = MR.rID

Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
---
  select title, star
  from Movie,
    (select mID, max(stars) star
    from Rating
    group by mID
    ) Ra
  where Movie.mID = Ra.mID
  order by title
  
Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
---
  select title,ratingspread
  from Movie,
    (select mID, max(stars)-min(stars) ratingspread
    from Rating
    group by mID
    ) RS
   where Movie.mID = RS.mID
   order by ratingspread desc,title
   
Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
---
  select avgold-avgnew difference
  from
    (select avg(star) avgold
    from Movie,
      (select mID,avg(stars) star
      from Rating
      group by mID
      ) avgRating
     where Movie.mID = avgRating.mID
      and year<1980
     ) OldMovie,
    (select avg(star) avgnew
    from Movie,
      (select mID,avg(stars) star
      from Rating
      group by mID
      ) avgRating
     where Movie.mID = avgRating.mID
      and year>1980
     ) NewMovie
