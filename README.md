# 🛒 E-Commerce Revenue Intelligence Dashboard

**SQL · Power BI · DAX**

An end-to-end data analytics project that transforms raw e-commerce
transaction data into actionable business insights using PostgreSQL
and Power BI.

---

## 🚀 Project Overview

This project simulates a real-world retail analytics scenario where
transaction data is analyzed to uncover customer behavior, revenue
trends, and growth opportunities.

- **PostgreSQL** → Data extraction & advanced analysis (12 sections)
- **Power BI + DAX** → Interactive 2-page dashboard
- **Python** → Realistic dataset generation (power-law distribution,
  seasonal patterns, natural churn)

---

## 🎯 Problem Statement

E-commerce businesses generate large volumes of data but often lack
clear insights into:

- Why revenue is declining despite a large customer base
- Which customers are at risk of churning
- Which categories and markets drive the most value
- How to prioritize retention vs acquisition spend

---

## 🎯 Business Questions Solved

1. What is the overall performance of the business?
2. Who are the most valuable customers?
3. Are customers loyal, at risk, or already lost?
4. Is the business growing or declining — and why?
5. Which categories and markets drive the most revenue?
6. How does customer behavior vary across demographics?

---

## 🧰 Tools & Technologies

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Querying, aggregation, advanced analysis |
| **Power BI** | Interactive dashboard & storytelling |
| **DAX** | KPI and segment calculations |
| **Python** | Realistic dataset generation |

---

## 📁 Dataset

- **50,000** transaction records
- **9,500** unique customers
- **Date range:** January 2023 – December 2024
- **10 countries:** USA, India, UK, Germany, Canada, France,
  Australia, Japan, Mexico, Brazil
- **8 product categories:** Electronics, Clothing, Books, Beauty,
  Sports, Home & Kitchen, Grocery, Toys
- **6 payment methods:** Credit Card, Debit Card, UPI,
  Cash on Delivery, PayPal, Net Banking

### Why this dataset is realistic:
- Power-law frequency: 37% one-time buyers → 5% champions
- Natural Q4 seasonal spikes (Nov–Dec)
- Customer churn built in — median lifespan of 22 days
- 2024 revenue decline reflecting real acquisition slowdown
- Top 20% of customers drive 70.5% of revenue

---

## 🗄️ SQL Analysis (PostgreSQL)

12 analytical sections covering the full business picture:

| Section | Business Question |
|---------|------------------|
| A — Core KPIs | What is the overall business performance? |
| B — CLV Proxy | Which customers generate the most revenue? |
| C — RFM Analysis | How can we segment customers by behavior? |
| D — Segmentation | Who are Champions, Loyal, At Risk, Lost? |
| E — Cohort Analysis | How well do we retain customers over time? |
| F — Monthly Growth | Is the business growing or declining? |
| G — Category Contribution | Which categories drive revenue? |
| H — Pareto Analysis | Do top customers drive majority of revenue? |
| I — Payment Analysis | How do payment methods impact revenue? |
| J — Age Group Analysis | How does spending vary across age groups? |
| K — Country Analysis | Which markets offer the best opportunities? |
| L — Customer Retention | What percentage of customers return? |

**Key SQL techniques used:**
- Window Functions: `LAG`, `NTILE`, `RANK`, `FIRST_VALUE`
- CTEs (Common Table Expressions)
- `PERCENTILE_CONT` for median calculations
- `NULLIF` to prevent divide-by-zero errors
- `DATE_TRUNC` for cohort logic


---

## 📊 Power BI Dashboard

### 🔹 Page 1 — Business Performance

<<<<<<< HEAD
![Page 1]

**KPI Cards**
- Total Revenue: **$7.12M**
- Total Orders: **50K**
- Total Customers: **9,500**

**Visuals**
- Revenue by Payment Method (horizontal bar)
  → All 6 methods nearly equal ($1.14M–$1.25M)
- Revenue Contribution by Month (line chart, 2023–2024)
  → Clear 2023 growth peak and 2024 decline visible
- Revenue by Age Group (bar chart)
  → Adult $4.6M · Senior $1.4M · Young $1.1M
- Revenue by Product Category (donut chart)
  → Electronics $2.66M · Home & Kitchen $1.2M · Sports $0.97M

**Slicers:** Year · Country · Product Category

---

### 🔹 Page 2 — Customer Intelligence

<<<<<<< HEAD
![Page 2]

**KPI Cards**
- Repeat Customer Rate: **56.02%**
- Average Order Value: **$142.47**
- Customer Lifetime Value: **$749.85**

**Visuals**
- Revenue Contribution by Countries (bar chart)
  → USA $1.3M · India $1.04M · UK $0.84M · Germany $0.75M
- Top Customer Table
  → user_name · Total Orders · Revenue per Customer
  → Top: Grace Wagner (42 orders, $16,615)
- Insights text panel
- Recommendations text panel

---

## 📊 DAX Measures Used

| Measure | Formula Logic |
|---------|--------------|
| Total Revenue | SUM(purchase_amount) |
| Total Orders | COUNTROWS() |
| Total Customers | DISTINCTCOUNT(user_name) |
| Avg Order Value | Revenue / Total Orders |
| Revenue per Customer (CLV) | Revenue / Total Customers |
| Repeat Customers | SUMMARIZE + FILTER orders > 1 |
| Repeat Customer Rate % | Repeat Customers / Total Customers |

---

## 📊 Key Insights

1. Revenue grew from $11K (Jan 2023) to $632K (Dec 2023) but
   collapsed 68% YoY by Dec 2024. Not seasonality — it's a
   customer acquisition problem.

2. 44% of customers bought only once and never returned. Median
   lifespan is just 22 days. Half the base is essentially
   one-time visitors.

3. Electronics alone = 37.3% of revenue ($2.66M, AOV $427).
   Top 2 categories drive 54.2% of all revenue —
   heavy concentration risk.

4. Top 20% of customers generate 70.5% of revenue. Top customer
   spent $16,616 vs median of $276 — a 60x gap.

5. 74% of customers are At Risk or Lost — bought before, now
   silent. They hold $4.6M in historical revenue no longer active.

---

## 🚀 Recommendations

1. Trigger a second-purchase email 14 days after first order.
   Converting 10% of one-time buyers adds ~$500K in revenue.
   Highest ROI action available.

2. Investigate 2024 acquisition drop. Compare new customers
   month-by-month 2023 vs 2024. Fix the pipeline before
   2025 decline continues.

3. Create a VIP tier for top 200 customers. No discounts —
   reward with free shipping and early access. Losing 50 of
   them has immediate revenue impact.

4. Reduce Electronics dependency from 37.3% to under 25% by
   growing Sports and Clothing categories.

5. Win-back At Risk customers (180–365 days silent) with a
   personalised offer. 15% reactivation = ~$300K recovered.

---

## 📈 Business Impact

- Diagnosed 2024 revenue decline as an acquisition problem,
  not a product or retention issue
- Quantified $4.6M dormant revenue opportunity in At Risk
  and Lost segments
- Proved top 20% of customers drive 70.5% of revenue
- Identified Electronics concentration as the #1 business risk
- Delivered clear action plan with estimated revenue impact
  per recommendation

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `ecommerce_realistic.csv` | Realistic dataset (50K rows, 9.5K customers) |
| `ecommerce_analysis_v2.sql` | Full SQL analysis (12 sections + insights) |
| `E-Commerce_Dashboard.pbix` | Power BI dashboard file |
| `page_1.png` | Dashboard — Business Performance |
| `page_2.png` | Dashboard — Customer Intelligence |

---

*Project by Harsh Singh Tomar — Data Analyst*