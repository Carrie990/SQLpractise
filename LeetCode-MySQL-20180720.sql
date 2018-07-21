-- 574. Winning Candidate (medium)
-- https://leetcode.com/articles/winning-candidate/
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.
SELECT Name
FROM Candidate,
  (SELECT CandidateId, COUNT(id) Count
    FROM Vote
    GROUP BY CandidateId
   ) VoteCount
 WHERE Candidate.id = VoteCount.id
  AND VoteCount.Count in (
    SELECT MAX(Count)
    FROM 
      (SELECT CandidateId, COUNT(id) Count
      FROM Vote
      GROUP BY CandidateId
      ) VoteCount
     )
 
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
 
SELECT  MIN(distance) AS shortest
FROM (SELECT SQRT((p1.x-p2.x)**2 + (p1.y-p2.y)**2) distance
     FROM point_2d p1, point_2d p2
     WHERE (p1.x = p2.x AND p1.y = p2.y) IS NOT TRUE
     ) Distance
 
 -- 608.Tree Node
 -- https://leetcode.com/articles/tree-node/
 SELECT t1.id
    CASE
        WHEN t1.p_id IS NULL THEN Root
        WHEN t1.id NOT IN (SELECT t2.p_id
                           FROM tree t2
                           ) THEN Leaf
        ELSE Inner    
    END AS Type
 FROM tree t1
 
-- 612. Shortest Distance in a Plane 
-- https://code.dennyzhang.com/second-degree-follower




 
