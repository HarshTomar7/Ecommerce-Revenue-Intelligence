-- ============================================
-- E-COMMERCE SALES ANALYSIS
-- Author : Harsh Singh Tomar
-- Tool   : PostgreSQL
-- Dataset: E-Commerce Transactions (50,000 records)
-- ============================================
--
-- THE STORY:
-- An online store has been running since Jan 2023.
-- Revenue grew well in 2023, then dropped in 2024.
-- The business wants to know — why did revenue fall?
-- Who are the best customers? Are people coming back?
--
-- I had 50,000 transactions across 9,500 customers
-- and tried to answer those questions.
-- ============================================


CREATE TABLE ecommerce (
    transaction_id   VARCHAR PRIMARY KEY,
    user_name        VARCHAR,
    age              INT,
    age_group        VARCHAR,       -- Young / Adult / Senior
    country          VARCHAR,
    product_category VARCHAR,
    purchase_amount  NUMERIC,
    payment_method   VARCHAR,
    transaction_date DATE,
    year             INT,
    month            VARCHAR
);


-- ============================================
-- STEP 1 — What does the overall business look like?
-- ============================================

-- Before anything else, I wanted the headline numbers.
-- Total revenue, orders, customers, and average spend per customer.

SELECT
    SUM(purchase_amount)                                        AS total_revenue,
    COUNT(*)                                                    AS total_orders,
    COUNT(DISTINCT LOWER(TRIM(user_name)))                      AS total_customers,
    ROUND(AVG(purchase_amount), 2)                             AS avg_order_value,
    ROUND(SUM(purchase_amount) /
          COUNT(DISTINCT LOWER(TRIM(user_name))), 2)           AS revenue_per_customer
FROM ecommerce;

-- Result: $7.12M revenue, 50K orders, 9,500 customers
-- AOV = $142. Revenue per customer = $749.
-- Looks healthy — but these totals hide the 2024 problem.


-- ============================================
-- STEP 2 — Is the business growing or shrinking?
-- ============================================

-- I looked at revenue month by month to spot the trend.
-- Used LAG() to compare each month to the previous one.

WITH monthly AS (
    SELECT
        year,
        month,
        SUM(purchase_amount) AS revenue
    FROM ecommerce
    GROUP BY year, month
)
SELECT
    year,
    month,
    ROUND(revenue, 0)                                           AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY year, month), 0)         AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month))
        / LAG(revenue) OVER (ORDER BY year, month) * 100, 1
    )                                                           AS growth_pct
FROM monthly
ORDER BY year, month;

-- 2023: Revenue grew from $11K → $632K. Strong growth.
-- 2024: Revenue collapsed month by month.
-- This is not normal seasonality — something structural broke.
-- My guess: new customer acquisition slowed down. Next query confirms.


-- ============================================
-- STEP 3 — Are customers coming back?
-- ============================================

-- If customers return, revenue stays healthy even without new ones.
-- If most buy once and leave, the business needs constant new customers.

WITH customer_orders AS (
    SELECT
        LOWER(TRIM(user_name)) AS customer_id,
        COUNT(*)               AS total_orders
    FROM ecommerce
    GROUP BY customer_id
)
SELECT
    COUNT(*)                                                          AS total_customers,
    COUNT(CASE WHEN total_orders = 1 THEN 1 END)                     AS one_time_buyers,
    COUNT(CASE WHEN total_orders > 1 THEN 1 END)                     AS repeat_buyers,
    ROUND(COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 100.0
          / COUNT(*), 2)                                             AS repeat_rate_pct
FROM customer_orders;

-- 44% of customers bought only once and never came back.
-- Repeat rate is 56% — sounds okay, but with 2024 new acquisition
-- dropping, there aren't enough new customers to replace the churned ones.


-- ============================================
-- STEP 4 — Who are the most valuable customers?
-- ============================================

-- I wanted to find the "champion" customers — the ones who buy often
-- and spend the most. These are the people the business can't afford to lose.

SELECT
    LOWER(TRIM(user_name))  AS customer,
    COUNT(*)                AS total_orders,
    ROUND(SUM(purchase_amount), 2)  AS total_spent,
    ROUND(AVG(purchase_amount), 2)  AS avg_order_value
FROM ecommerce
GROUP BY customer
ORDER BY total_spent DESC
LIMIT 20;

-- Top customer: Grace Wagner — 42 orders, $16,615 spent.
-- The top 20 customers each spent 20x the average customer.
-- Losing just 50 of these would have immediate revenue impact.


-- ============================================
-- STEP 5 — Can we segment customers by behaviour?
-- ============================================

-- I used a simple RFM approach:
-- R = Recency (how recently they bought)
-- F = Frequency (how often they buy)
-- M = Monetary (how much they spent)
-- Then labelled them into segments.

WITH rfm_base AS (
    SELECT 
        LOWER(TRIM(user_name)) AS customer_id, 
        MAX(transaction_date) AS last_purchase, 
        COUNT(*) AS frequency, 
        SUM(purchase_amount) AS monetary 
    FROM ecommerce 
    GROUP BY customer_id 
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY last_purchase ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT 
    *,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
        WHEN f_score >= 4 AND m_score >= 4 THEN 'Loyal'
        WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'At risk'
        WHEN f_score = 1 THEN 'One-time buyer'
        ELSE 'Regular' 
    END AS segment
FROM rfm_scores
ORDER BY monetary DESC;

-- Champions = high value, high frequency → protect at all costs
-- One-time buyers = 44% of base → biggest opportunity if converted
-- At risk = bought before, now silent → win-back campaigns needed


-- ============================================
-- STEP 6 — Which product categories drive revenue?
-- ============================================

select product_category,count(*) as total_orders,sum(purchase_amount) as revenue,
avg(purchase_amount) as average_order_value,sum(purchase_amount) / (select sum(purchase_amount) from ecommerce) * 100 as
perc from ecommerce group by product_category order by revenue desc

-- Electronics = 37.3% of all revenue ($2.66M, AOV $427).
-- Top 2 categories (Electronics + Home & Kitchen) = 54% of revenue.
-- This is concentration risk — if Electronics demand drops, the whole
-- business suffers. Books and Grocery drive repeat orders but low revenue.


-- ============================================
-- STEP 7 — Which countries are the best markets?
-- ============================================

SELECT
    country,
    COUNT(DISTINCT LOWER(TRIM(user_name)))  AS customers,
    ROUND(SUM(purchase_amount), 0)          AS total_revenue,
    ROUND(AVG(purchase_amount), 2)          AS avg_order_value,
    CASE
        WHEN SUM(purchase_amount) > 1000000
         AND AVG(purchase_amount) > 150     THEN 'High value'
        WHEN SUM(purchase_amount) > 1000000 THEN 'High volume'
        ELSE                                     'Growth opportunity'
    END AS market_type
FROM ecommerce
GROUP BY country
ORDER BY total_revenue DESC;

-- USA and India = highest revenue.
-- UK and Germany = highest AOV (quality buyers, fewer orders).
-- Japan and Mexico = low volume today but worth targeting for growth.


-- ============================================
-- STEP 8 — Does age group affect spending?
-- ============================================

SELECT
    age_group,
    COUNT(*)                        AS orders,
    ROUND(AVG(purchase_amount), 2)  AS avg_spend,
    ROUND(SUM(purchase_amount), 0)  AS total_revenue
FROM ecommerce
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Adults (25–45) drive $4.6M of the $7.12M total.
-- AOV is similar across age groups — the difference is order volume.
-- Young customers have the most long-term potential.


-- ============================================
-- STEP 9 — Does payment method matter?
-- ============================================

SELECT
    payment_method,
    COUNT(*)                        AS transactions,
    ROUND(AVG(purchase_amount), 2)  AS avg_order_value,
    ROUND(SUM(purchase_amount), 0)  AS total_revenue
FROM ecommerce
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- All 6 payment methods are almost equal in revenue (~$1.14M–$1.25M each).
-- Cash on Delivery is slightly highest but carries delivery/return risk.
-- No single method dominates — the store should keep all options open.


-- ============================================
-- STEP 10 — The Pareto check: do top customers drive most revenue?
-- ============================================

WITH customer_spend AS (
    SELECT
        LOWER(TRIM(user_name))  AS customer_id,
        SUM(purchase_amount)    AS total_spent
    FROM ecommerce
    GROUP BY customer_id
),
ranked AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY total_spent DESC) AS quintile
    FROM customer_spend
)
SELECT
    quintile,
    COUNT(*)                            AS customers,
    ROUND(SUM(total_spent), 0)          AS revenue,
    ROUND(SUM(total_spent) * 100.0
          / (select sum(total_spent) from ranked), 1) AS revenue_share_pct
FROM ranked
GROUP BY quintile
ORDER BY quintile;


-- Quintile 1 (top 20%) drives 70.5% of revenue.
-- This confirms the Pareto effect — most revenue comes from very few customers.
-- Losing the top segment would be catastrophic for the business.


-- ============================================
-- END
-- ============================================
