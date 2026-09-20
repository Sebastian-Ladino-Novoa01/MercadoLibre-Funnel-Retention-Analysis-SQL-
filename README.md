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

## Key Findings

### Funnel

- The largest drop-off is between **select_item (76.9%)** and **add_to_cart (11.0%)**: **86% of users who viewed a product never added it to the cart.** Every later stage loses comparatively little.
- End-to-end conversion to purchase is **1.25%**.
- Stage by stage, as % of first visit: select_item 76.9% → add_to_cart 11.0% → begin_checkout 4.0% → add_shipping_info 2.4% → add_payment_info 2.1% → purchase 1.25%.

### Retention

- D7 retention is strong across all markets (**79–87%**) but collapses to **1.6–3.2% by D28**.
- The steepest loss happens between D21 (~22%) and D28 (~2%).
- Monthly cohorts from January to July are stable (D7 ranges 85.9%–87.7%), which indicates the decay is structural to the product, not a recent regression.

### Caveats

- Country-level purchase rates rest on **10 purchases across roughly 850 users**. Three markets (Colombia, Ecuador, Paraguay) recorded zero purchases, and Uruguay's leading 4.5% rate is a single purchase out of 22 users. These gaps are not statistically meaningful and should not drive market decisions on their own.
- The **August 2025 cohort is truncated**: the observation window ends 2025-08-31, so those users could not reach D28. Its low figures reflect incomplete observation, not worse retention.
## Tools Used

- SQL
- PostgreSQL
- Git / GitHub

## Project Files

- [Executive summary workbook (.xlsx)](Proyecto%204_%20An%C3%A1lisis%20de%20embudo%20y%20retenci%C3%B3n%20para%20MercadoLibre%20-%20Resumen%20ejecutivo%20(1).xlsx)

## Author

**Sebastian Ladino Novoa** — Data Analytics Portfolio
