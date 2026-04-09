-- 1. Last booked room for each user
SELECT user_id, room_no
FROM bookings b
WHERE booking_date = (
  SELECT MAX(booking_date)
  FROM bookings b2
  WHERE b2.user_id = b.user_id
);


-- 2. Total billing per booking in Nov 2021
SELECT 
  bc.booking_id,
  SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON b.booking_id = bc.booking_id
WHERE b.booking_date BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY bc.booking_id;


-- 3. Bills in Oct 2021 with amount > 1000
SELECT 
  bill_id,
  SUM(item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bill_date BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bill_id
HAVING SUM(item_quantity * i.item_rate) > 1000;


-- 4. Most and least ordered item per month (simple version)
SELECT 
  MONTH(bill_date) AS month,
  item_id,
  SUM(item_quantity) AS total_qty
FROM booking_commercials
WHERE YEAR(bill_date) = 2021
GROUP BY MONTH(bill_date), item_id
ORDER BY month, total_qty DESC;
-- (manually we can pick top and bottom per month)


-- 5. Second highest bill per month (approx)
SELECT *
FROM (
  SELECT 
      MONTH(bc.bill_date) AS month,
      b.user_id,
      bc.bill_id,
      SUM(bc.item_quantity * i.item_rate) AS amount,
      DENSE_RANK() OVER (
          PARTITION BY MONTH(bc.bill_date)
          ORDER BY SUM(bc.item_quantity * i.item_rate) DESC
      ) rnk
  FROM booking_commercials bc
  JOIN bookings b ON bc.booking_id = b.booking_id
  JOIN items i ON bc.item_id = i.item_id
  GROUP BY MONTH(bc.bill_date), b.user_id, bc.bill_id
) t
WHERE rnk = 2;
