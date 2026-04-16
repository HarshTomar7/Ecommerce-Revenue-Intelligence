CREATE TABLE ecommerce (
    transaction_id VARCHAR PRIMARY KEY,
    user_name VARCHAR,
    age INT,
    age_group VARCHAR,
    country VARCHAR,
    product_category VARCHAR,
    purchase_amount NUMERIC,
    purchase_bucket VARCHAR,
    payment_method VARCHAR,
    transaction_date DATE,
    year INT,
    month varchar
);



-- =========================================
-- E-COMMERCE REVENUE INTELLIGENCE PROJECT
-- =========================================
-- Tool: PostgreSQL
-- Dataset: E-commerce Transactions
-- Author: Harsh Singh Tomar
--
-- Objective:
-- Perform advanced business analysis to understand
-- customer behavior, revenue trends, and growth opportunities.
-- =========================================



-- =========================
-- SECTION A: CORE KPIs
-- BUSINESS QUESTION:
-- What is the overall business performance?
-- =========================

SELECT 
    SUM(purchase_amount) AS total_revenue,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT LOWER(TRIM(user_name))) AS total_customers,
    ROUND(
        SUM(purchase_amount) / COUNT(DISTINCT LOWER(TRIM(user_name))), 2
    ) AS revenue_per_customer
FROM ecommerce;



-- =========================
-- SECTION B: CUSTOMER LIFETIME VALUE (CLV PROXY)
-- BUSINESS QUESTION:
-- Which customers generate the most revenue?
-- =========================

SELECT 
    LOWER(TRIM(user_name)) AS customer_id,
    COUNT(*) AS total_orders,
    SUM(purchase_amount) AS total_spent,
    AVG(purchase_amount) AS avg_order_value
FROM ecommerce
GROUP BY customer_id
ORDER BY total_spent DESC;



-- =========================
-- SECTION C: RFM ANALYSIS
-- BUSINESS QUESTION:
-- How can we segment customers based on behavior?
-- =========================

WITH rfm AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id,
        MAX(transaction_date) AS last_purchase,
        COUNT(*) AS frequency,
        SUM(purchase_amount) AS monetary
    FROM ecommerce
    GROUP BY customer_id
),
rfm_score AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY last_purchase DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM rfm
)
SELECT *,
    (recency_score + frequency_score + monetary_score) AS total_score
FROM rfm_score;



-- =========================
-- SECTION D: CUSTOMER SEGMENTATION
-- BUSINESS QUESTION:
-- Who are our most valuable customers?
-- =========================

WITH rfm AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id,
        COUNT(*) AS frequency,
        SUM(purchase_amount) AS monetary
    FROM ecommerce
    GROUP BY customer_id
)
SELECT *,
    CASE 
        WHEN monetary > 1000 AND frequency > 5 THEN 'Champions'
        WHEN monetary > 800 THEN 'Loyal Customers'
        WHEN frequency = 1 THEN 'New Customers'
        ELSE 'Regular'
    END AS segment
FROM rfm;



-- =========================
-- SECTION E: COHORT ANALYSIS
-- BUSINESS QUESTION:
-- How well do we retain customers over time?
-- =========================

WITH first_purchase AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id,
        MIN(transaction_date) AS first_date
    FROM ecommerce
    GROUP BY customer_id
),
cohort_data AS (
    SELECT 
        LOWER(TRIM(e.user_name)) AS customer_id,
        DATE_TRUNC('month', f.first_date) AS cohort_month,
        DATE_TRUNC('month', e.transaction_date) AS order_month
    FROM ecommerce e
    JOIN first_purchase f 
    ON LOWER(TRIM(e.user_name)) = f.customer_id
)
SELECT 
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_data
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;



-- =========================
-- SECTION F: MONTHLY GROWTH TREND
-- BUSINESS QUESTION:
-- Is the business growing over time?
-- =========================

WITH monthly AS (
    SELECT 
        year,
        month,
        SUM(purchase_amount) AS revenue
    FROM ecommerce
    GROUP BY year, month
)
SELECT *,
    LAG(revenue) OVER (ORDER BY year, month) AS prev_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month)) 
        / LAG(revenue) OVER (ORDER BY year, month) * 100, 2
    ) AS growth_pct
FROM monthly;



-- =========================
-- SECTION G: CATEGORY CONTRIBUTION
-- BUSINESS QUESTION:
-- Which product categories drive revenue?
-- =========================

WITH total AS (
    SELECT SUM(purchase_amount) AS total_revenue FROM ecommerce
)
SELECT 
    product_category,
    SUM(purchase_amount) AS revenue,
    ROUND(
        SUM(purchase_amount) / (SELECT total_revenue FROM total) * 100, 2
    ) AS contribution_pct
FROM ecommerce
GROUP BY product_category;



-- =========================
-- SECTION H: TOP CUSTOMERS (PARETO ANALYSIS)
-- BUSINESS QUESTION:
-- Do top customers contribute majority of revenue?
-- =========================

WITH customer_spend AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id,
        SUM(purchase_amount) AS total_spent
    FROM ecommerce
    GROUP BY customer_id
),
ranked AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY total_spent DESC) AS percentile
    FROM customer_spend
)
SELECT *
FROM ranked
WHERE percentile = 1;



-- =========================
-- SECTION I: PAYMENT ANALYSIS
-- BUSINESS QUESTION:
-- How do payment methods impact revenue?
-- =========================

SELECT 
    payment_method,
    COUNT(*) AS transactions,
    AVG(purchase_amount) AS avg_value,
    SUM(purchase_amount) AS total_revenue,
    RANK() OVER (ORDER BY AVG(purchase_amount) DESC) AS value_rank
FROM ecommerce
GROUP BY payment_method;



-- =========================
-- SECTION J: AGE GROUP ANALYSIS
-- BUSINESS QUESTION:
-- How does spending vary across age groups?
-- =========================

SELECT 
    age_group,
    COUNT(*) AS orders,
    AVG(purchase_amount) AS avg_spend,
    SUM(purchase_amount) AS revenue
FROM ecommerce
GROUP BY age_group;



-- =========================
-- SECTION K: COUNTRY ANALYSIS
-- BUSINESS QUESTION:
-- Which markets offer the best opportunities?
-- =========================

SELECT 
    country,
    COUNT(DISTINCT LOWER(TRIM(user_name))) AS customers,
    SUM(purchase_amount) AS revenue,
    AVG(purchase_amount) AS avg_spend,
    CASE 
        WHEN SUM(purchase_amount) > 50000 AND AVG(purchase_amount) > 150 THEN 'High Value Market'
        WHEN SUM(purchase_amount) > 50000 THEN 'Volume Market'
        ELSE 'Growth Market'
    END AS market_type
FROM ecommerce
GROUP BY country;



-- =========================
-- SECTION L: CUSTOMER RETENTION
-- BUSINESS QUESTION:
-- Are customers coming back?
-- =========================

WITH customer_orders AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id,
        COUNT(*) AS orders
    FROM ecommerce
    GROUP BY customer_id
)
SELECT 
    COUNT(CASE WHEN orders > 1 THEN 1 END) * 100.0 / COUNT(*) AS repeat_customer_rate
FROM customer_orders;



-- =========================
-- INSIGHTS SUMMARY
-- =========================

-- 1. Payment Behavior
-- No single dominant method; COD leads but digital payments (UPI, cards, PayPal) are equally strong.
-- Indicates customers prefer flexibility rather than a shift to fully digital.

-- 2. Customer Demographics
-- Seniors generate the most revenue due to higher purchase frequency.
-- Younger customers spend slightly more per order.

-- 3. Geographic Performance
-- Revenue is evenly distributed across countries.
-- Business is not dependent on any single market.

-- 4. Customer Retention
-- Repeat customer rate is extremely high (~100%).
-- Cohort data shows strong retention but low indication of new customer growth.

-- 5. Customer Value
-- A small group of customers contributes a large share of revenue.
-- Business heavily depends on loyal repeat buyers.

-- 6. Customer Segmentation
-- Most customers fall into the same segment (Champions).
-- Current segmentation logic is too broad and needs refinement.

-- 7. Revenue Trend
-- Revenue fluctuates monthly with noticeable peaks and drops.
-- Sharp decline in March 2025 needs further investigation.

-- 8. Product Categories
-- All categories contribute almost equally (~12–13% each).
-- Indicates a well-diversified product portfolio.



---------------------END----------------------------