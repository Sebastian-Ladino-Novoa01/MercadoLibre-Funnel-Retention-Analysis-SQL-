/* ============================================================
   Project : MercadoLibre Funnel & Retention Analysis
   Step    : 06 — Monthly cohort retention
   Purpose : Assign each user to their signup-month cohort and
             measure retention per cohort, to separate genuine
             product improvement from changes in acquisition mix.
   Engine  : PostgreSQL
   Author  : Sebastian Ladino Novoa
   ============================================================ */

-- 6.1 Cohort assignment preview: one row per user, first signup month.
SELECT
    user_id,
    MIN(signup_date) AS signup_date,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date::date)), 'YYYY-MM') AS cohort
FROM mercadolibre_retention
GROUP BY user_id
LIMIT 5;

-- 6.2 Retention by cohort and period.
WITH cohort AS (
    SELECT
        user_id,
        TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
    FROM mercadolibre_retention
    GROUP BY user_id
),
activity AS (
    SELECT
        mlr.user_id,
        mlr.day_after_signup,
        mlr.active,
        c.cohort
    FROM mercadolibre_retention AS mlr
    LEFT JOIN cohort AS c
      ON mlr.user_id = c.user_id
    WHERE mlr.activity_date BETWEEN '2025-01-01' AND '2025-08-31'
)

SELECT
    cohort,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END)
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d7_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END)
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d14_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END)
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d21_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END)
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d28_pct
FROM activity
GROUP BY cohort
ORDER BY cohort;
