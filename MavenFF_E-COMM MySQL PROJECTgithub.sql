

/* 1. Pull monthly trends for gsearch sessions and orders 
so that the growth there can bed showcase */

SELECT 
    MONTH(website_sessions.created_at) AS months,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.website_session_id) AS orders,
    (COUNT(DISTINCT orders.website_session_id) 
    / COUNT(DISTINCT website_sessions.website_session_id)) * 100 AS session_to_order_conv_rate
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.utm_source = 'gsearch'
        AND website_sessions.created_at < '2012-11-27'
GROUP BY 1;

/* ANALYSIS: the query shows the upward trend of the conversion rates of sessions to orders
from March to December */


/* 2. Query to see a similar monthly trend for gsearch, but this time splitting out nonbrand
and brand campaigns separately to see if brand campaign is picking up at all. */

SELECT 
    MONTH(website_sessions.created_at) AS months,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id
            ELSE NULL END) AS nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.website_session_id
            ELSE NULL END) AS nonbrand_orders,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id
            ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.website_session_id
            ELSE NULL END) AS brand_orders
FROM
    website_sessions
        LEFT JOIN
    orders 
    ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.utm_source = 'gsearch'
	AND website_sessions.created_at < '2012-11-27'
GROUP BY 1;

/* ANALYSIS: brand utm_campaign sessions and orders have picked up steam since the early months of March and April */


/* 3. Let's dive into nonbrand, and pull monthly sessions and orders split by device type.*/

SELECT 
    MONTH(website_sessions.created_at) AS months,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id
            ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.website_session_id
            ELSE NULL END) AS desktop_orders,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id
            ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.website_session_id
            ELSE NULL END) AS mobile_orders
FROM
    website_sessions
        LEFT JOIN
    orders 
    ON website_sessions.website_session_id = orders.website_session_id
WHERE   website_sessions.utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND website_sessions.created_at < '2012-11-27'
GROUP BY 1;

/* ANALYSIS: desktop as a device type has been the platform getting most of the traffic which suggests
that the mobile interface isn't attracting traffic or the demographic of our clients make use of desktop computers
rather than mobile phones when visiting our website. */


/* 4. Pull monthly trends for gsearch, alongside monthly trends for each of the other channels? */

-- first, finding the various utm sources and referers to see the traffic been gotten

SELECT DISTINCT
    utm_source, 
    utm_campaign, 
    http_referer
FROM    website_sessions
WHERE   created_at < '2012-11-27';

-- use the above result gotten as parameters in the case statements below

SELECT 
    -- YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS months,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id
            ELSE NULL END) AS gsearch_paid_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id
            ELSE NULL END) AS bsearch_paid_sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id
            ELSE NULL END) AS organic_search_sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id
            ELSE NULL END) AS direct_type_in_sessions
FROM
    website_sessions
        LEFT JOIN
    orders 
    ON 
    orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-11-27'
GROUP BY 1
ORDER BY 1 ASC;

/* ANALYSIS: Amongst the other channels, bsearch makes up the majority of traffic followed by organic search and lastly direct type in. */



/* 5. Tell the story of our website performcance improvements over the course of the first 8 months.
Pull session to order conversion rates by month */

SELECT 
    MONTH(website_sessions.created_at) AS months,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.website_session_id) AS orders,
    (COUNT(DISTINCT orders.website_session_id) 
    / COUNT(DISTINCT website_sessions.website_session_id)) * 100 AS session_to_order_conv_rate
FROM
    website_sessions
        LEFT JOIN
    orders 
    ON 
    orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-11-27'
GROUP BY 1;

/* ANALYSIS: Website performance dipped after the first month and recorded low numbers in the succeeding month as well.alter
However, it picked up in the fourth month and took a positive jump in months 7 & 8. */
