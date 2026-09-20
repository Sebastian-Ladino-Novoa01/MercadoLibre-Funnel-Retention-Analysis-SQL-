/* ============================================================
   Project : MercadoLibre Funnel & Retention Analysis
   Step    : 05 — Retention by country
   Purpose : Count retained users at D7/D14/D21/D28 per country,
             then express them as retention rates.
   Engine  : PostgreSQL
   Author  : Sebastian Ladino Novoa
   ============================================================ */

-- 5.1 Retained user counts per country.
SELECT
    country,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) AS users_d7,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) AS users_d14,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) AS users_d21,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) AS users_d28
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;

-- 5.2 Same figures as retention rates, over all users in the market.
SELECT
    country,
    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) * 100.0
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d7_pct,
    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) * 100.0
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d14_pct,
    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) * 100.0
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d21_pct,
    ROUND(COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) * 100.0
          / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d28_pct
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;
