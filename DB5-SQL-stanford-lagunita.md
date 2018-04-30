# SQLpractise - the answer of lagunita stanford data

# SQL Movie-Rating Query Exercises

Q1. Find the titles of all movies directed by Steven Spielberg. 
  select title
  from Movie
  where director = 'Steven Spielberg'

Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
  SELECT DISTINCT year
  FROM Movie
  WHERE mID in 
  (select mID 
  from Rating
  WHERE stars IN (4,5)
  ) 
  ORDER BY year

Q3. Find the titles of all movies that have no ratings. 
  select title
  from Movie
  where mID not in
  (select mID
  from Rating
  )
