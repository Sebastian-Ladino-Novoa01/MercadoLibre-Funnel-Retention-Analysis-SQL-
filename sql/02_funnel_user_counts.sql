/* ============================================================
   Project : MercadoLibre Funnel & Retention Analysis
   Step    : 02 — Unique users per funnel stage
   Purpose : Count distinct users reaching each stage between
             2025-01-01 and 2025-08-31. One CTE per stage keeps
             each definition explicit and auditable.
   Engine  : PostgreSQL
   Author  : Sebastian Ladino Novoa
   ============================================================ */

WITH first_visit AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'first_visit'
),
select_item AS (
    -- select_item and select_promotion are treated as the same stage:
    -- both mean the user engaged with a product listing.
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name IN ('select_item', 'select_promotion')
),
add_to_cart AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'add_to_cart'
),
begin_checkout AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'begin_checkout'
),
add_shipping_info AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'add_shipping_info'
),
add_payment_info AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'add_payment_info'
),
purchase AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
      AND event_name = 'purchase'
)

-- Anchored on first_visit: every later stage is LEFT JOINed so a
-- user who dropped off still appears, counted as NULL downstream.
SELECT
    COUNT(DISTINCT f.user_id)   AS usuarios_first_visit,
    COUNT(DISTINCT s.user_id)   AS usuarios_select_item,
    COUNT(DISTINCT a2c.user_id) AS usuarios_add_to_cart,
    COUNT(DISTINCT b.user_id)   AS usuarios_begin_checkout,
    COUNT(DISTINCT a.user_id)   AS usuarios_add_shipping_info,
    COUNT(DISTINCT ap.user_id)  AS usuarios_add_payment_info,
    COUNT(DISTINCT p.user_id)   AS usuarios_purchase
FROM first_visit AS f
LEFT JOIN select_item       AS s   ON f.user_id = s.user_id
LEFT JOIN add_to_cart       AS a2c ON f.user_id = a2c.user_id
LEFT JOIN begin_checkout    AS b   ON f.user_id = b.user_id
LEFT JOIN add_shipping_info AS a   ON f.user_id = a.user_id
LEFT JOIN add_payment_info  AS ap  ON f.user_id = ap.user_id
LEFT JOIN purchase          AS p   ON f.user_id = p.user_id;
