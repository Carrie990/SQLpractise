-- 613. Shortest Distance in a Line 
-- https://leetcode.com/articles/shortest-distance-in-a-line/
-- Write a query to find the shortest distance between two points in these points.

SELECT MIN(ABS(p1.x-p2.x)) shortest
FROM point p1, point p2
WHERE p1.x != p2.x

-- 607.Sales Person 
-- https://leetcode.com/articles/sales-person/
-- Given three tables: salesperson, company, orders.
-- Output all the names in the table salesperson, who didn’t have sales to company 'RED'.
-- TeraData

WITH salesid AS(
    SELECT sales_id
    FROM company,orders
    WHERE company.com_id= orders.com_id
        AND name = 'RED'
)
SELECT name
FROM salesperson
WHERE sales_id NOT IN(
    SELECT sales_id
    FROM salesid
    )

-- 597. Friend Requests I: Overall Acceptance Rate 
-- https://leetcode.com/articles/friend-requests-i-overall-acceptance-rate/
-- Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divide the number of requests.

WITH send AS(
    SELECT DISTINCT sender_id, send_to_id
    FROM friend_request
),accept AS(
    SELECT DISTINCT requester_id, accepter_id
    FROM friend_request, request_accepted
    WHERE sender_id = requester_id
        AND send_to_id = accepter_id
)
SELECT ROUND((SELECT COUNT(*) FROM accept)/(SELECT COUNT(*) FROM send),2) AS accept_rate


-- 584. Find Customer Referee
-- https://leetcode.com/articles/find-customer-referee/
SELECT name
FROM customer
WHERE referee_id != 2 
    OR referee_id is NULL
ORDER BY id

-- 577.	Employee Bonus
-- https://leetcode.com/articles/employee-bonus/
SELECT name, bonus
FROM Employee, Bonus
WHERE Employee.empId = Bonus.empId
    AND (bonus < 1000
         OR bonus is NULL)

-- 603.Consecutive Available Seats 
-- https://leetcode.com/articles/consecutive-available-seats/
-- Solution 1
SELECT c1.seat_id AS seat_id
FROM cinema c1, cinema c2
WHERE c2.seat_id = c1.seat_id+1
    AND c1.free = 1
    AND c2.free = 1
UNION
SELECT c2.seat_id AS seat_id
FROM cinema c1, cinema c2
WHERE c2.seat_id = c1.seat_id+1
    AND c1.free = 1
    AND c2.free = 1

-- Solution 2
select distinct a.seat_id
from cinema a join cinema b
  on abs(a.seat_id - b.seat_id) = 1
  and a.free = true and b.free = true
order by a.seat_id

-- 619. Biggest Single Number 
-- https://leetcode.com/articles/biggest-single-number/
SELECT
    IFNULL((SELECT max(num) AS num
           FROM
               (SELECT num
               FROM number
               GROUP BY num
               HAVING COUNT(num) = 1
               ) t
           ), NULL)


