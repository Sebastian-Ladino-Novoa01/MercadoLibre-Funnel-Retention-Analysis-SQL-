/* ============================================================
   Project : MercadoLibre Funnel & Retention Analysis
   Step    : 04 — Funnel segmented by country
   Purpose : Same conversion rates as step 03, broken down by
             country, to see which markets convert best.
   Engine  : PostgreSQL
   Author  : Sebastian Ladino Novoa
   ============================================================ */

WITH first_visits AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'first_visit'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name IN ('select_item', 'select_promotion')
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_to_cart'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'begin_checkout'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_shipping_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_payment_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'purchase'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
funnel_counts AS (
    -- Joining on user_id AND country keeps each user inside their
    -- own market, so a user is never counted in two countries.
    SELECT
        fv.country,
        COUNT(fv.user_id)  AS usuarios_first_visit,
        COUNT(si.user_id)  AS usuarios_select_item,
        COUNT(a.user_id)   AS usuarios_add_to_cart,
        COUNT(bc.user_id)  AS usuarios_begin_checkout,
        COUNT(asi.user_id) AS usuarios_add_shipping_info,
        COUNT(api.user_id) AS usuarios_add_payment_info,
        COUNT(p.user_id)   AS usuarios_purchase
    FROM first_visits AS fv
    LEFT JOIN select_item       AS si  ON fv.user_id = si.user_id  AND fv.country = si.country
    LEFT JOIN add_to_cart       AS a   ON fv.user_id = a.user_id   AND fv.country = a.country
    LEFT JOIN begin_checkout    AS bc  ON fv.user_id = bc.user_id  AND fv.country = bc.country
    LEFT JOIN add_shipping_info AS asi ON fv.user_id = asi.user_id AND fv.country = asi.country
    LEFT JOIN add_payment_info  AS api ON fv.user_id = api.user_id AND fv.country = api.country
    LEFT JOIN purchase          AS p   ON fv.user_id = p.user_id   AND fv.country = p.country
    GROUP BY fv.country
)

SELECT
    country,
    ROUND((usuarios_select_item       * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_select_item,
    ROUND((usuarios_add_to_cart       * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_to_cart,
    ROUND((usuarios_begin_checkout    * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_begin_checkout,
    ROUND((usuarios_add_shipping_info * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_shipping_info,
    ROUND((usuarios_add_payment_info  * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_payment_info,
    ROUND((usuarios_purchase          * 100.00) / NULLIF(usuarios_first_visit, 0), 2) AS conversion_purchase
FROM funnel_counts
ORDER BY conversion_purchase DESC;
