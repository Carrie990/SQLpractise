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
 
-- 570. Managers with at Least 5 Direct Reports  
-- https://leetcode.com/articles/managers-with-at-least-5-direct-reports/
-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. Id，Name，Department，ManagerId 
-- MySQL
SELECT Name
FROM Employee,(
    SELECT ManagerId, COUNT(Id) cnt
    FROM Employee
    GROUP BY ManagerId
    ) Counts
WHERE Employee.Id = Counts.ManagerId
    AND cnt >= 5

-- TeraData
WITH Counts AS (
    SELECT ManagerId, COUNT(Id) cnt
    FROM Employee
    GROUP BY ManagerId
), 
SELECT Name
FROM Employee, Counts
WHERE Employee.Id = Counts.ManagerId
    AND cnt >= 5

-- 585. Investments in 2016 
-- https://leetcode.com/articles/investments-in-2016/
-- Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria
-- PID,  TIV_2015, LAT ,LON   

-- TeraData
WITH Group2015 AS (
    SELECT TIV_2015, COUNT(PID) AS cnt2015
    FROM insurance
    GROUP BY TIV_2015
), SameLoc AS (
    SELECT I1.PID
    FROM insurance I1, insurance I2
    WHERE I1.PID != I2.PID
        AND I1.LAT = I2.LAT
        AND I1.LON = I2.LON       
)
SELECT ROUND(SUM(TIV_2016),2) AS TIV_2016
FROM insurance I
WHERE I.PID in ( SELECT PID
                FROM SameLoc
    ) AND I.TIV_2015 in (SELECT TIV_2015
                         FROM Group2015
                         WHERE cnt2015 >=2
    ) 

-- 578. Get Highest Answer Rate Question
-- https://leetcode.com/articles/get-highest-answer-rate-question/
-- Write a sql query to identify the question which has the highest answer rate.: uid, action, question_id, answer_id, q_num, timestamp.
-- TeraData
WITH AnswerNum AS (
    SELECT question_id, COUNT(1) AS ansnum
    FROM survey_log
    WHERE action = 'answer'
    GROUP BY question_id
), QuestionNum AS (
    SELECT question_id, COUNT(1) as quesnum
    FROM survey_log
    GROUP BY question_id
), AnswerRate AS (
    SELECT AnswerNum.question_id,ansnum/quesnum AS ansrate
    FROM AnswerNum, QuestionNum
    WHERE AnswerNum.question_id = QuestionNum.question.id
)
SELECT survey_log.question_id AS survey_log
FROM survey_log, AnswerRate
WHERE survey_log.question_id = AnswerRate.question_id
ORDER BY ansrate DESC
LIMIT 1

-- 602. Friend Requests II: Who Has Most Friend? 
-- https://leetcode.com/articles/friend-requests-ii-who-has-most-friend/
-- Write a query to find the the people who has most friends and the most friends number. 
-- requester_id | accepter_id | accept_date
-- TeraData
WITH AllId AS (
    SELECT requester_id AS id
    FROM request_accepted
    UNION ALL
    SELECT accepter_id AS id
    FROM request_accepted
), FriendCnt AS (
    SELECT id, COUNT(id) AS num
    FROM AllId
    GROUP BY id
)
SELECT id, num
FROM FriendCnt
ORDER BY num
LIMIT 1







