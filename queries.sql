-- ============================================================
-- DecodeLabs | Data Analytics | Project 3: SQL Data Analysis
-- Table: orders (1,200 rows) loaded from Dataset_for_Data_Analytics.xlsx
-- Dialect: SQLite (also valid in MySQL/PostgreSQL unless noted)
-- ============================================================

-- Q1. SELECT: preview the data
SELECT OrderID, Date, Product, Quantity, UnitPrice, TotalPrice, OrderStatus
FROM orders
LIMIT 10;

-- Q2. COUNT/SUM/AVG: overall KPIs
SELECT COUNT(*) AS total_orders,
       ROUND(SUM(TotalPrice),2) AS total_revenue,
       ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders;

-- Q3. WHERE + ORDER BY: high-value delivered orders (>= 3000; only 6 qualify)
SELECT OrderID, Product, Quantity, TotalPrice
FROM orders
WHERE OrderStatus = 'Delivered' AND TotalPrice >= 3000
ORDER BY TotalPrice DESC
LIMIT 10;

-- Q4. GROUP BY: orders by status
SELECT OrderStatus, COUNT(*) AS orders,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM orders),1) AS pct_of_orders
FROM orders
GROUP BY OrderStatus
ORDER BY orders DESC;

-- Q5. GROUP BY + SUM/AVG: product performance
SELECT Product, COUNT(*) AS orders, SUM(Quantity) AS units_sold,
       ROUND(SUM(TotalPrice),2) AS revenue,
       ROUND(AVG(UnitPrice),2) AS avg_unit_price
FROM orders
GROUP BY Product
ORDER BY revenue DESC;

-- Q6. Percentage contribution of each product to total revenue
SELECT Product, ROUND(SUM(TotalPrice),2) AS revenue,
       ROUND(100.0*SUM(TotalPrice)/(SELECT SUM(TotalPrice) FROM orders),2) AS pct_revenue
FROM orders
GROUP BY Product
ORDER BY pct_revenue DESC;

-- Q7. Payment method usage
SELECT PaymentMethod, COUNT(*) AS orders,
       ROUND(SUM(TotalPrice),2) AS revenue,
       ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders
GROUP BY PaymentMethod
ORDER BY revenue DESC;

-- Q8. Yearly revenue trend
SELECT strftime('%Y', Date) AS year, COUNT(*) AS orders,
       ROUND(SUM(TotalPrice),2) AS revenue
FROM orders
GROUP BY year
ORDER BY year;     -- MySQL/Postgres: use YEAR(Date) / EXTRACT(YEAR FROM Date)

-- Q9. Referral source effectiveness
SELECT ReferralSource, COUNT(*) AS orders,
       ROUND(SUM(TotalPrice),2) AS revenue,
       ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders
GROUP BY ReferralSource
ORDER BY revenue DESC;

-- Q10. Coupon impact (NULL = no coupon) - NULL handling with COALESCE
SELECT COALESCE(CouponCode,'NO COUPON') AS coupon, COUNT(*) AS orders,
       ROUND(AVG(TotalPrice),2) AS avg_order_value,
       ROUND(AVG(ItemsInCart),2) AS avg_items_in_cart
FROM orders
GROUP BY COALESCE(CouponCode,'NO COUPON')
ORDER BY orders DESC;

-- Q11. HAVING: products with cancel+return rate above 40%
SELECT Product, COUNT(*) AS orders,
       SUM(CASE WHEN OrderStatus IN ('Cancelled','Returned') THEN 1 ELSE 0 END) AS lost_orders,
       ROUND(100.0*SUM(CASE WHEN OrderStatus IN ('Cancelled','Returned') THEN 1 ELSE 0 END)/COUNT(*),1) AS lost_pct
FROM orders
GROUP BY Product
HAVING lost_pct > 40      -- portable form: HAVING 100.0*SUM(...)/COUNT(*) > 40
ORDER BY lost_pct DESC;

-- Q12. HAVING: repeat customers (more than 1 order)
SELECT CustomerID, COUNT(*) AS orders, ROUND(SUM(TotalPrice),2) AS spend
FROM orders
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY orders DESC, spend DESC
LIMIT 10;

-- Q13. WHERE with LIKE: pattern match on shipping address (street numbers starting with 9)
SELECT COUNT(*) AS orders_addr_starting_9, ROUND(SUM(TotalPrice),2) AS revenue
FROM orders
WHERE ShippingAddress LIKE '9%';

-- Q14. Revenue lost to Cancelled/Returned orders
SELECT OrderStatus, COUNT(*) AS orders, ROUND(SUM(TotalPrice),2) AS revenue_at_risk
FROM orders
WHERE OrderStatus IN ('Cancelled','Returned')
GROUP BY OrderStatus;

-- Q15. Data-quality check: TotalPrice should equal Quantity * UnitPrice
SELECT COUNT(*) AS mismatched_rows
FROM orders
WHERE ABS(TotalPrice - Quantity*UnitPrice) > 0.01;

-- Q16. Data-quality check: duplicate OrderIDs
SELECT OrderID, COUNT(*) FROM orders GROUP BY OrderID HAVING COUNT(*) > 1;
