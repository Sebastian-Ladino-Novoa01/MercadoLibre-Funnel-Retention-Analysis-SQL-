/* ============================================================
   Project : MercadoLibre Funnel & Retention Analysis
   Step    : 01 — Schema exploration
   Purpose : Inspect both source tables and list the distinct
             events available before defining the funnel stages.
   Engine  : PostgreSQL
   Author  : Sebastian Ladino Novoa
   ============================================================ */

-- 1.1 Funnel event log
SELECT *
FROM mercadolibre_funnel
LIMIT 5;

-- 1.2 Retention activity table
SELECT *
FROM mercadolibre_retention
LIMIT 5;

-- 1.3 Distinct events, to decide which ones map to each funnel stage.
SELECT DISTINCT event_name
FROM mercadolibre_funnel
ORDER BY event_name;
