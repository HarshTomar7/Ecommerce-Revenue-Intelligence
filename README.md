# 🛒 E-Commerce Sales Analysis
**SQL + Power BI &nbsp;|&nbsp; Harsh Singh Tomar**

---

## The Problem

An online store launched in January 2023 and had a great first year — revenue grew month after month.

Then 2024 arrived, and something went wrong. Revenue started falling. The business needed to know:

- **Why is revenue declining?**
- **Are customers coming back, or buying once and leaving?**
- **Who are the most valuable customers — and are we protecting them?**
- **Which products and markets are actually driving growth?**

I had 50,000 transactions from 9,500 customers across 10 countries, and tried to answer these questions with SQL and Power BI.

---

## The Data

Each row is one purchase. It tells us:
- Who bought, when, and how much they spent
- What category they bought from and which country they're in
- Their age group and payment method

**Dataset size:** 50,000 transactions · 9,500 customers · Jan 2023 – Dec 2024 · 10 countries · 8 product categories

---

## What I Did — Step by Step

### Step 1 — Headline numbers first
Before digging into problems, I established the baseline.

> **$7.12M revenue · 50K orders · 9,500 customers · $142 average order**

These look healthy. But when you split by year, the picture changes completely.

---

### Step 2 — Is the business growing or shrinking?
I used SQL's `LAG()` function to compare each month to the previous one.

> **2023:** Revenue grew from $11K in January to $632K in December — 57x growth in a year.
>
> **2024:** Revenue fell every single month. By December 2024, it was down 68% from the peak.

This is not a seasonal dip. This is a structural problem. My next question: why?

---

### Step 3 — Are customers coming back?
If customers return, revenue stays stable. If most buy once and leave, the business depends entirely on new customer acquisition.

> **44% of customers bought only once and never came back.**
> Repeat rate = 56%.

This explains 2024. When new customer acquisition slowed down, there wasn't enough repeat business to make up for it. The business had been papering over a retention problem with growth.

---

### Step 4 — Who are the most valuable customers?
I ranked customers by total spending to find the "champion" segment.

> Top customer: Grace Wagner — 42 orders, $16,615 spent.
> The top 20% of customers drive **70.5% of total revenue.**
> The top customer spent 60x more than the median customer.

This is the Pareto effect in action. The business is highly dependent on a small group of loyal buyers.

---

### Step 5 — What are people buying?
I looked at revenue share by product category.

> **Electronics = 37.3% of all revenue** ($2.66M, average order $427).
> Top 2 categories (Electronics + Home & Kitchen) = 54% of revenue.

This is concentration risk. If Electronics demand drops — due to economic conditions, a competitor, or supply issues — the whole business suffers. Books and Grocery drive repeat orders but contribute little revenue individually.

---

### Step 6 — Which countries are strongest?
I labelled markets based on both revenue and average order value.

| Country | Revenue | Market Type |
|---------|---------|-------------|
| USA | $1.3M | High value |
| India | $1.04M | High volume |
| UK | $0.84M | High value |
| Germany | $0.75M | High value |
| Japan | Low | Growth opportunity |
| Mexico | Low | Growth opportunity |

> UK and Germany have higher average order values than USA and India — quality buyers worth investing in.

---

## Dashboard

### Page 1 — Business Performance
<img width="1292" height="692" alt="page_1" src="https://github.com/user-attachments/assets/dc8d6f87-9307-40c9-8f23-802c691fc94b" />


Shows revenue totals, monthly trend (where the 2024 decline is clearly visible), breakdown by payment method, age group, and product category.

### Page 2 — Customer Intelligence
<img width="1271" height="719" alt="page_2" src="https://github.com/user-attachments/assets/98c16d73-3bd0-4564-b219-be60752b00c7" />


Shows repeat customer rate, average order value, CLV, revenue by country, top customers table, and the key insights + recommendations.

---

## What I Found

**The real problem is retention and acquisition — not the product.**

| Finding | What it means |
|---------|--------------|
| 2024 revenue fell 68% from peak | New customer acquisition dropped sharply |
| 44% of customers bought only once | Half the base never came back |
| Top 20% drive 70.5% of revenue | The business rests on a very small loyal base |
| Electronics = 37% of revenue | Heavy concentration in one category |
| UK & Germany have highest AOV | Underinvested high-value markets |

---

## What I'd Recommend

1. **Send a follow-up email 14 days after a first order.** Converting just 10% of one-time buyers into repeat buyers adds ~$500K in revenue. Easiest win available.

2. **Investigate why new customer acquisition dropped in 2024.** Compare new customers month by month — 2023 vs 2024. The problem started somewhere specific.

3. **Protect the top 200 customers.** Create a simple VIP list. No discounts needed — offer free shipping and early access. Losing 50 of them has immediate revenue impact.

4. **Grow Sports and Clothing to reduce Electronics dependency.** Target Electronics share under 30% over 12 months.

5. **Run a win-back campaign for customers silent for 180+ days.** Even a 15% reactivation rate recovers ~$300K in dormant revenue.

---

## What I Learned

- How to use `LAG()` to calculate month-over-month growth
- How to build customer segments using `CASE WHEN` and CTEs
- How `NTILE()` works for percentile-based segmentation (Pareto analysis)
- How RFM thinking works — and why it's used in real retail analytics
- How to frame data findings as a business story, not just numbers

---

## What I'd Do Next

- Build a proper cohort retention chart (month 0, month 1, month 2...) to see exactly when customers drop off
- Add a funnel analysis if browsing/cart data were available
- Try to predict which customers are "at risk" of churning using a simple score

---

## Tools

| Tool | Used For |
|---|---|
| PostgreSQL | All analysis — 10 queries covering the full story |
| Power BI | Dashboard, charts, KPI cards |
| DAX | Calculated measures (repeat rate, CLV, AOV) |

---

## Files

```
├── ecommerce_analysis.sql   → 10 queries that walk through the full story
├── README.md                → This file
├── page_1.png               → Dashboard page 1 — Business performance
└── page_2.png               → Dashboard page 2 — Customer intelligence
```

---

*Personal learning project by Harsh Singh Tomar*
