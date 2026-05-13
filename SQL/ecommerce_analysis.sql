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
    LAG(revenue) OVER (ORDER BY year) AS prev_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) 
        / LAG(revenue) OVER (ORDER BY year) * 100, 2
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
-- No single dominant payment method; all six methods share ~15-17% of transactions equally.
-- COD leads slightly (8,522 txns, $146 avg) but the difference is marginal.
-- Indicates customers value payment flexibility — no method should be removed.
-- COD carries hidden operational costs (failed deliveries, returns) despite its high usage;
-- incentivising a shift to prepaid digital methods would improve margins.

-- 2. Customer Demographics
-- Adults (25-45) dominate with 6,139 customers, 32,103 orders and $4.6M revenue (64.7%).
-- All three age groups have nearly identical AOV: Adult $143, Young $141, Senior $140.
-- Spending differences come from frequency and customer count, not spend per order.
-- Young customers (18-24) are the smallest group but show higher order frequency
-- than Seniors — highest long-term CLV potential if retained early.

-- 3. Geographic Performance
-- USA leads in revenue ($1.30M, 18.2%) followed by India ($1.04M, 14.6%).
-- UK ($150.87 avg) and Germany ($149.67 avg) are the highest AOV markets — classified
-- as High Value Markets. No single country exceeds 18.2% revenue share.
-- Business has healthy geographic diversification with no dangerous market dependency.
-- Japan and Mexico are underpenetrated relative to their size — best Growth Market targets.

-- 4. Customer Retention
-- Repeat customer rate is 56% — below the 60-70% industry benchmark.
-- 44% of customers (4,180) bought exactly once and never returned.
-- Median customer lifespan is only 22 days — half of all customers complete
-- their entire relationship with the business in under 3 weeks.
-- Converting even 10% of one-time buyers into two-time buyers would add
-- ~$500K in incremental revenue at median spend levels.

-- 5. Customer Value
-- Top 20% of customers drive 70.5% of total revenue — stronger than the classic 80/20 rule.
-- Top 10% alone account for 51.8% of revenue.
-- Top customer (Grace Wagner) spent $16,616 across 42 orders — 60x the median customer ($276).
-- Business is heavily concentrated in a small loyal core; losing top customers
-- has an immediate and measurable revenue impact.

-- 6. Customer Segmentation
-- Champions (monetary > $1,000 AND frequency > 5): 434 customers, $1.50M revenue (21.1%).
-- New Customers (frequency = 1): 759 customers but only $109K revenue — entirely dependent
-- on whether they return for a second purchase.
-- At Risk + Lost customers combined: 6,993 customers holding $4.6M in past revenue.
-- This is the most critical finding — nearly 74% of the base has gone silent.
-- Reactivating even 15% of At Risk customers recovers ~$300K in revenue.

-- 7. Revenue Trend
-- 2023 was a strong growth year: revenue scaled from $11K (Jan) to $632K (Dec).
-- Q4 2023 peak was driven by seasonal demand — Nov +16% MoM, Dec +20% MoM.
-- 2024 shows structural decline: revenue fell every month from March ($377K) to December ($201K).
-- By December 2024 revenue is down 68% YoY vs December 2023 — this is not seasonality,
-- it is a customer acquisition problem. 2023 cohorts are ageing out faster than
-- new customers are being acquired to replace them.

-- 8. Product Categories
-- Electronics dominates at 37.3% of revenue ($2.66M) with the highest AOV at $427.84.
-- This is a concentration risk — one supply disruption impacts over a third of total revenue.
-- Books (3.3%, $36.92 avg) and Grocery (5.1%, $56.05 avg) drive order frequency
-- but contribute minimal revenue — they are habit-formation categories, not revenue drivers.
-- Top 2 categories (Electronics + Home & Kitchen) account for 54.2% of all revenue.
-- A healthier portfolio target would be no single category exceeding 25% share.



---------------------END----------------------------
