# 🛒 E-Commerce Revenue Intelligence Dashboard

**SQL · Excel · Power BI**

An end-to-end data analytics project that analyzes e-commerce transaction data to uncover customer behavior, revenue trends, and business growth opportunities.

---

## 🚀 Project Overview

This project simulates a real-world retail analytics scenario where raw transaction data is transformed into actionable insights using:

- **Excel** → Data cleaning & preparation
- **PostgreSQL** → Data extraction & advanced analysis
- **Power BI** → Interactive dashboard & business storytelling

The focus is on solving real business problems such as customer retention, segmentation, and revenue optimization.

---

## 🎯 Problem Statement

E-commerce businesses generate large volumes of data but often lack clear insights into:

- Customer behavior
- Retention patterns
- Revenue drivers

This project analyzes transaction data to identify high-value customers, improve retention strategies, and support data-driven decision-making.

---

## 🎯 Business Questions Solved

1. What is the overall performance of the business?
2. Who are the most valuable customers?
3. Are customers loyal or at risk?
4. What factors drive revenue growth?
5. How does customer behavior vary across segments?
6. Which markets and categories contribute most to revenue?

---

## 🧰 Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Excel** | Data cleaning, formatting, preparation |
| **PostgreSQL** | Querying, aggregation, advanced analysis |
| **Power BI** | Dashboard & business storytelling |
| **DAX** | KPI calculations |

---

## 📁 Dataset

- ~50,000 transaction records
- Includes:
  - Customer details
  - Product categories
  - Payment methods
  - Purchase amounts
- Key metrics:
  - Revenue
  - Order frequency
  - Customer spend

---

## 🧹 Data Cleaning (Excel)

Before analysis, the raw dataset was cleaned in Excel:

- Removed duplicate transaction records
- Standardized column formats (dates, amounts, text casing)
- Created derived columns: `age_group`, `purchase_bucket`, `year`, `month`
- Handled missing/null values
- Exported cleaned file for SQL import

---

## 🗄️ SQL Analysis (PostgreSQL)

13 analytical query sections covering the full business picture:

| Section | Business Question |
|---------|------------------|
| A — Core KPIs | What is the overall business performance? |
| B — CLV | Which customers generate the most revenue? |
| C — RFM Analysis | How can we segment customers based on behavior? |
| D — Segmentation | Who are our most valuable customers? |
| E — Cohort Analysis | How well do we retain customers over time? |
| F — Monthly Growth | Is the business growing over time? |
| G — Category Contribution | Which product categories drive revenue? |
| H — Pareto Analysis | Do top customers contribute majority of revenue? |
| I — Payment Analysis | How do payment methods impact revenue? |
| J — Age Group Analysis | How does spending vary across age groups? |
| K — Country Analysis | Which markets offer the best opportunities? |
| L — Customer Retention | Are customers coming back? |

**Key SQL techniques used:**
- Window Functions: `LAG`, `NTILE`, `RANK`
- CTEs (Common Table Expressions)
- Scalar Subqueries
- `NULLIF`, `CASE WHEN`
- Aggregations & Joins

---

## 📊 Dashboard (Power BI)

### 🔹 Page 1 — Business Performance

<img width="1282" height="674" alt="Page 1" src="https://github.com/user-attachments/assets/bd383244-603c-4307-acfd-645e5aec3eef" />


- Total Revenue, Orders, Customers
- Monthly Revenue Trend
- Revenue by Payment Method
- Revenue by Age Group
- Revenue by Product Category

> 👉 High-level business overview

---

### 🔹 Page 2 — Customer Intelligence

<img width="1281" height="716" alt="Page 2" src="https://github.com/user-attachments/assets/0795a462-3677-45a4-add7-bccd38a3c0e1" />


- Average Order Value (AOV)
- Customer Lifetime Value (CLV)
- Repeat Customer Rate
- Top Customers Table
- Revenue by Country
- Insights & Recommendations panels

> 👉 Deep dive into customer behavior

---

## 📊 Key Insights

- **Very high repeat customer rate** → strong retention, weak acquisition
- **Revenue evenly distributed** across categories and countries
- **Senior customers** contribute the highest total revenue
- **Younger customers** have higher average order values
- **Monthly revenue fluctuations** indicate seasonality
- **Small group of customers** drives majority of revenue (Pareto effect)
- **Sharp revenue dip in March 2025** identified as a critical anomaly

---

## 🚀 Recommendations

1. Focus on acquiring new customers to reduce over-reliance on repeat buyers
2. Encourage digital payments with small incentives to reduce COD dependency
3. Run targeted campaigns during low-revenue months (Feb, March)
4. Use product bundling to increase Average Order Value
5. Improve customer segmentation for more targeted marketing
6. Analyze March 2025 revenue dip — investigate root cause

---

## 📊 Key Metrics

| Metric | Formula |
|--------|---------|
| Revenue | Total purchase amount |
| AOV | Revenue / Total Orders |
| CLV | Revenue / Total Customers |
| Repeat Customer Rate | Repeat Customers / Total Customers × 100 |

---

## 📈 Business Impact

- Identified high-value customers and key revenue drivers
- Improved understanding of customer retention patterns
- Highlighted critical gaps in customer acquisition strategy
- Enabled data-driven decision-making across segments and markets

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `ecommerce_transactions_RAW_.csv` | Original raw dataset |
| `cleaned_ecommerce.csv` | Cleaned dataset (Excel) |
| `ecommerce_analysis.sql` | Full SQL analysis (13 sections) |
| `E-Commerce_Dashboard.pbix` | Power BI dashboard file |
| `Page_1.png` | Dashboard screenshot — Business Performance |
| `Page_2.png` | Dashboard screenshot — Customer Intelligence |

---

*Project by Harsh Singh Tomar — Data Analyst*
