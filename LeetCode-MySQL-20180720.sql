-- 574. Winning Candidate (medium)
-- https://leetcode.com/articles/winning-candidate/
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.
-- MySQL
SELECT Name
FROM Candidate,
  (SELECT CandidateId, COUNT(id) Counts
    FROM Vote
    GROUP BY CandidateId
   ) VoteCount
WHERE Candidate.id = VoteCount.CandidateId
    AND VoteCount.Count in (
      SELECT MAX(Counts)
      FROM 
        (SELECT CandidateId, COUNT(id) Counts
        FROM Vote
        GROUP BY CandidateId
        ) VoteCount
     )
 
 -- TeraData
WITH VoteCount AS(
    SELECT CandidateId, COUNT(id) cnt
    FROM Vote
    GROUP BY CandidateId
), Winner AS (
    SELECT CandidataId, cnt
    FROM VoteCount
    ORDER BY cnt DESC
    LIMIT 1
)
SELECT Name
FROM Candidate, Winner
WHERE Candidate.id = Winner.CandidateId
 
 
 -- 610. Triangle Judgement (easy)
 -- https://leetcode.com/articles/triangle-judgement/
 
 SELECT x, y, z, 
    CASE 
        WHEN (x+y)>z AND (y+z)>x AND (x+z)>y THEN 'Yes'
        ELSE 'No'
    END
    AS triangle
 FROM triangle
 
 -- 612.Shortest Distance in a Plane (medium)
 -- https://leetcode.com/articles/shortest-distance-in-a-plane/
-- MySQL 
SELECT  MIN(distance) AS shortest
FROM (SELECT SQRT((p1.x-p2.x)**2 + (p1.y-p2.y)**2) distance
     FROM point_2d p1, point_2d p2
     WHERE (p1.x = p2.x AND p1.y = p2.y) IS NOT TRUE
     ) Distance
 
 -- TeraData , if there are some entries have the some values
 WITH Ranked_p AS (
    SELECT x,y, RANK() OVER (ORDER BY x) AS rnk
    FROM point_2d
 ), Distance AS (
    SELECT SQRT((p1.x-p2.x)**2+(p1.y-p2.y)**2) distance
    FROM Ranked_p p1, Ranked_p p2
    WHERE p1.rnk > p2.rnk
 )
 SELECT MIN(distance) AS shortest
 FROM Distance
 
 -- 608.Tree Node
 -- https://leetcode.com/articles/tree-node/
 SELECT t1.id
    CASE
        WHEN t1.p_id IS NULL THEN 'Root'
        WHEN t1.id NOT IN (SELECT t2.p_id
                           FROM tree t2
                           ) THEN 'Leaf'
        ELSE Inner    
    END AS 'Type'
 FROM tree t1
 

