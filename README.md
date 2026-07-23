# 🛒 E-Commerce Sales Analysis
**Excel; Harsh Singh Tomar**

---

## The Problem

An online store launched in January 2023 and had a strong first year — revenue grew month after month. Then 2024 arrived and revenue started falling. I wanted to know why, using nothing but Excel:

- Why is revenue declining?
- Are customers coming back, or buying once and leaving?
- Who are the most valuable customers — and can the business afford to lose them?
- Which products and markets are actually driving growth?

50,000 transactions from 9,500 customers across 10 countries, all built and analysed inside one workbook.

---

## The Data

Each row is one purchase — who bought, when, how much, which category, which country, their age group, and payment method. Lives entirely in the `Data` tab as a proper Excel table. Came in clean — no missing values, no duplicate transaction IDs, no whitespace/casing issues on customer names.

**50,000 transactions · 9,500 customers · Jan 2023 – Dec 2024 · 10 countries · 8 product categories**

---

## How It's Built

No Power BI, no SQL — every number in this workbook is a live formula pulling from the `Data` tab, so it recalculates if the underlying data changes.

- **`SUMIFS` / `COUNTIFS` / `AVERAGEIFS`** for all the category, country, age group, and payment method breakdowns
- **`INDEX` / `MATCH`** to pull each customer's country and age group from their first transaction, and to resolve the top-spender table
- **`LARGE` + `SUMPRODUCT`** for ranking (Top 15 customers, and the top-20%-of-customers revenue share)
- **`MINIFS` / `MAXIFS`** for each customer's first and last purchase date, feeding a recency calculation
- **Nested `IF`** for customer segmentation (Champion / Loyal / Regular / At risk / One-time buyer) based on order count, spend, and recency
- **Native Excel charts** (line, pie, bar) on the Dashboard tab, all pointing at the summary tables — nothing pasted as an image

With 9,500 customers each pulling from a 50,000-row range, the Customer Summary tab alone is doing tens of millions of lookups — it's the one part of the workbook that visibly takes a moment to recalculate on open.

---

## What I Did — Step by Step

### Step 1 — Headline numbers first
> **$7.12M revenue · 50,000 orders · 9,500 customers · $142.47 average order · $749.85 revenue per customer**

Healthy on the surface — the monthly trend tells a different story.

### Step 2 — Is the business growing or shrinking?
The `Monthly Trend` tab compares every month to the one before it.

> **2023:** revenue grew from $11.1K in January to $632K in December.
> **2024:** dropped 48% in January alone, and kept falling most months after, ending the year at $201K.

Not seasonality — something changed right at the start of 2024.

### Step 3 — Are customers coming back?
> **43.98% of customers bought only once.** Repeat rate = 56.02%.

Decent on paper, but four in ten customers never return — so revenue depends heavily on a steady stream of new customers. When that stream slows, as it did in 2024, there's nothing to backfill it.

### Step 4 — Who are the most valuable customers?
The `Top Customers` tab ranks by total spend using `LARGE` + `INDEX/MATCH`.

> Top customer: Grace Wagner — 42 orders, $16,615.52 spent.
> **The top 20% of customers drive 70.5% of total revenue.**

Classic Pareto pattern — losing a small slice of this group would hurt immediately.

### Step 5 — What are people buying?
> **Electronics = 37.3% of all revenue** ($2.66M, average order $427.84).
> Home & Kitchen is next at 16.9%. Books is the smallest category at 3.3%.

Electronics alone carries more than a third of the business — real concentration risk if demand there softens.

### Step 6 — Which countries are strongest?
| Country | Revenue | Market Type |
|---|---|---|
| USA | $1.30M | High volume |
| India | $1.04M | High value |
| UK | $845K | High value |
| Germany | $754K | High value |
| Canada | $584K | Growth opportunity |

USA leads on volume; India, UK, and Germany combine solid revenue with a higher average order value. Everywhere past the top four is still building.

---

## What I Found

**Retention looks fine in aggregate, but the business leans hard on a small core — and 2024 is what happens when new customers stop showing up to refill it.**

| Finding | What it means |
|---|---|
| Revenue grew through 2023, cratered in Jan 2024, kept falling | Not seasonal — acquisition or demand broke early in 2024 |
| 43.98% of customers never return | Retention has real room to improve, not just a footnote |
| Top 20% of customers = 70.5% of revenue | High exposure to losing a small group |
| Electronics = 37.3% of revenue | Heavy single-category concentration |
| USA, India, UK, Germany carry most of the revenue | Everywhere else is still an open opportunity |

---

## What I'd Recommend

1. **Fix the first-purchase-to-second-purchase gap.** With ~44% of customers buying once and vanishing, a follow-up offer in the two weeks after a first order is the highest-leverage single fix available.
2. **Build a real VIP program for the top spenders.** No discounts needed — early access and free shipping for the ~800 "Champion" customers protects the revenue that's already concentrated there.
3. **Diversify away from Electronics.** Push Home & Kitchen and Sports specifically — both already have solid AOV and room to grow without competing head-on with Electronics.
4. **Investigate what changed right at the start of 2024.** A 48% single-month drop in January points to something specific — a channel, a campaign, or a market that stopped performing — worth tracing rather than treating as a slow decline.
5. **Run a win-back campaign for the ~3,100 customers flagged "At risk"** in the Customer Summary tab — they've bought before, they've just gone quiet for 180+ days.

---

## What I Learned

- How far `SUMIFS`/`COUNTIFS`/`AVERAGEIFS` alone can carry a full sales analysis without ever touching a database
- Using `LARGE` and `SUMPRODUCT` together to rank and to compute a Pareto share, entirely in-formula
- Building customer-level recency/frequency/monetary logic with nested `IF` instead of a coded RFM script — same idea, spreadsheet-native
- Structuring a workbook so every summary tab stays a live formula off the raw data, instead of a one-time calculated snapshot
- At real scale (9,500 customers × 50,000 rows), formula-heavy workbooks have a genuine performance cost — worth knowing before promising "instant" recalculation to a stakeholder

---

## What I'd Do Next

- Add a Power Query step to handle messier real-world exports before the formulas ever see the data
- Build a proper cohort table (month 0, month 1, month 2...) to see exactly when customers drop off
- Try `XLOOKUP`-based segmentation once I'm working in a newer Excel version, to simplify the nested `IF` logic

---

## Files

```
├── ecommerce_sales_analysis.xlsx   → Full workbook: raw data, formulas, summary tabs, dashboard + charts
└── ecommerce_README.md             → This file
```

---

*Personal learning project by Harsh Singh Tomar*
