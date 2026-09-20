# MercadoLibre Funnel & Retention Analysis (SQL)

SQL project analyzing the conversion funnel and user retention for MercadoLibre, covering January–August 2025.

## Business Objective

Analyze MercadoLibre's conversion funnel and user retention to identify where users abandon the purchasing process and evaluate long-term engagement.

The project answers two main business questions:

- Where are users dropping off during the purchase funnel?
- How well are users retained over time?

## Dataset

- **`mercadolibre_funnel`** — user events throughout the purchase process, from first visit to purchase.
- **`mercadolibre_retention`** — user activity after signup, used for cohort retention.

## Funnel Stages

1. First Visit
2. Select Item / Promotion
3. Add to Cart
4. Begin Checkout
5. Add Shipping Information
6. Add Payment Information
7. Purchase

## SQL Scripts

The analysis is split into six scripts, meant to be run in order:

| # | Script | What it does |
|---|--------|--------------|
| 01 | [`01_data_exploration.sql`](sql/01_data_exploration.sql) | Inspects both tables and lists the distinct events available |
| 02 | [`02_funnel_user_counts.sql`](sql/02_funnel_user_counts.sql) | Counts unique users reaching each funnel stage, one CTE per stage |
| 03 | [`03_funnel_conversion_rates.sql`](sql/03_funnel_conversion_rates.sql) | Converts those counts into conversion rates over `first_visit` |
| 04 | [`04_funnel_by_country.sql`](sql/04_funnel_by_country.sql) | Same conversion rates, segmented by country |
| 05 | [`05_retention_by_country.sql`](sql/05_retention_by_country.sql) | D7 / D14 / D21 / D28 retention counts and rates per country |
| 06 | [`06_cohort_retention.sql`](sql/06_cohort_retention.sql) | Assigns users to monthly signup cohorts and measures retention per cohort |

## SQL Skills Demonstrated

- Common Table Expressions (CTEs)
- LEFT JOINs across multiple derived tables
- Aggregations with `COUNT(DISTINCT ...)`
- Conditional aggregation with `CASE WHEN`
- Conversion rate calculation
- Cohort analysis with `DATE_TRUNC` and `TO_CHAR`
- Retention analysis (D7 / D14 / D21 / D28)
- Safe
