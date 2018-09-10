-- Q1. how to select 10 records using Teradata
-- 1. any 10 records
  SELECT *
  FROM table
  SAMPLE 10;
-- 2. conditional N records
  SELECT column1, rank(colum2) AS rnk
  FROM table
  QUALIFY (rnk>10 and rnk<21)

  
