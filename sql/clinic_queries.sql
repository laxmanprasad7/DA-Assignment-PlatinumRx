-- 1. Revenue per sales channel (2021)
SELECT 
  sales_channel,
  SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- 2. Top 10 customers
SELECT 
  uid,
  SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Month-wise revenue, expense, profit
SELECT 
  MONTH(cs.datetime) AS month,
  SUM(cs.amount) AS revenue,
  SUM(e.amount) AS expense,
  (SUM(cs.amount) - SUM(e.amount)) AS profit
FROM clinic_sales cs
LEFT JOIN expenses e 
  ON cs.cid = e.cid
  AND MONTH(cs.datetime) = MONTH(e.datetime)
WHERE YEAR(cs.datetime) = 2021
GROUP BY MONTH(cs.datetime);


-- 4. Most profitable clinic per city (basic)
SELECT 
  c.city,
  cs.cid,
  SUM(cs.amount) - IFNULL(SUM(e.amount),0) AS profit
FROM clinic_sales cs
JOIN clinics c ON cs.cid = c.cid
LEFT JOIN expenses e ON cs.cid = e.cid
WHERE MONTH(cs.datetime) = 9
GROUP BY c.city, cs.cid
ORDER BY profit DESC;
-- top per city can be picked manually


-- 5. Second least profitable clinic per state
SELECT *
FROM (
  SELECT 
      c.state,
      cs.cid,
      SUM(cs.amount) - IFNULL(SUM(e.amount),0) AS profit,
      DENSE_RANK() OVER (
          PARTITION BY c.state
          ORDER BY SUM(cs.amount) - IFNULL(SUM(e.amount),0)
      ) rnk
  FROM clinic_sales cs
  JOIN clinics c ON cs.cid = c.cid
  LEFT JOIN expenses e ON cs.cid = e.cid
  WHERE MONTH(cs.datetime) = 9
  GROUP BY c.state, cs.cid
) t
WHERE rnk = 2;
