/* 1. Pull monthly trends for gsearch sessions and orders 
so that the growth there can bed showcase */

use mavenfuzzyfactory;

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
GROUP BY 1
;

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


/* 4. Pull monthly trends for gsearch, alongside monthly trends for each of our other channels? */

-- first, finding the various utm sources and referers to see the traffic we're getting

SELECT DISTINCT
    utm_source, 
    utm_campaign, 
    http_referer
FROM    website_sessions
WHERE   created_at < '2012-11-27';

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
    ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-11-27'
GROUP BY 1
ORDER BY 1 ASC;

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
    ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-11-27'
GROUP BY 1;