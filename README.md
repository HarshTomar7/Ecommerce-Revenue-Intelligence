🛒 E-Commerce Revenue Intelligence Dashboard

SQL · Python · Power BI

An end-to-end data analytics project that analyzes e-commerce transaction data to uncover customer behavior, revenue trends, and business growth opportunities.

🚀 Project Overview

This project simulates a real-world retail analytics scenario where raw transaction data is transformed into actionable insights using:

PostgreSQL → Data extraction & analysis

Python (Pandas, NumPy) → Data processing & advanced analytics

Power BI → Interactive dashboard & business storytelling

The focus is on solving real business problems such as customer retention, segmentation, and revenue optimization.

🎯 Problem Statement

E-commerce businesses generate large volumes of data but often lack clear insights into:

Customer behavior

Retention patterns

Revenue drivers

This project analyzes transaction data to identify high-value customers, improve retention strategies, and support data-driven decision-making.

🎯 Business Questions Solved

What is the overall performance of the business?

Who are the most valuable customers?

Are customers loyal or at risk?

What factors drive revenue growth?

How does customer behavior vary across segments?

Which markets and categories contribute most to revenue?

🧰 Tools & Technologies

Tool	Purpose

PostgreSQL	Data cleaning, querying, aggregation

Python (Pandas, NumPy)	Data analysis & transformation

Matplotlib & Seaborn	Data visualization

Power BI	Dashboard & storytelling

DAX	KPI calculations

📁 Dataset

~50,000 transaction records

Includes:

Customer details

Product categories

Payment methods

Purchase amounts

Key metrics:

Revenue

Order frequency

Customer spend

📊 Dashboard

🔹 Page 1 — Business Performance
<img width="1282" height="674" alt="Page 1" src="https://github.com/user-attachments/assets/73f25564-eb1b-41ce-b5ad-c6f8b585f26f" />


Total Revenue, Orders, Customers

Monthly Revenue Trend

Revenue by Payment Method

Revenue by Age Group

Revenue by Product Category


👉 High-level business overview

🔹 Page 2 — Customer Intelligence
<img width="1281" height="716" alt="Page 2" src="https://github.com/user-attachments/assets/16ee6ea3-2055-4cd4-922b-cca537d99e87" />



Average Order Value (AOV)

Customer Lifetime Value (CLV)

Repeat Customer Rate

Top Customers

Revenue by Country


👉 Deep dive into customer behavior

🐍 Python Analysis

RFM Customer Segmentation


Implemented RFM analysis to classify customers based on behavior:

Recency → Days since last purchase

Frequency → Number of orders

Monetary → Total spend

Techniques Used

groupby() for aggregation

pd.qcut() for scoring

rank(method="first") to handle duplicate values

Rule-based segmentation using .apply()

Customer Segments

Champions

Loyal Customers

New Customers

At Risk

High Spenders

Regular Customers

📊 Key Insights

Very high repeat customer rate → strong retention, weak acquisition

Revenue evenly distributed across categories and countries

Senior customers contribute the highest revenue

Younger customers have higher order values

Monthly revenue fluctuations indicate seasonality

Small group of customers drives majority of revenue (Pareto effect)

🚀 Recommendations

Improve customer segmentation for targeted marketing

Focus on acquiring new customers

Promote digital payments with incentives

Run campaigns based on age group behavior

Optimize marketing during low-revenue months

Use product bundling to increase AOV

📊 Key Metrics

Revenue = Total purchase amount

AOV = Revenue / Total Orders

CLV = Revenue / Total Customers

Retention Rate = Repeat Customers / Total Customers

📈 Business Impact

Identified high-value customers and revenue drivers

Improved understanding of customer retention patterns

Highlighted gaps in acquisition strategy

Enabled data-driven decision-making
