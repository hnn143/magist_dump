USE magist;

-- tech categories
SELECT * FROM product_category_name_translation;
SELECT product_category_name_english AS cat
FROM products
LEFT JOIN product_category_name_translation
USING (product_category_name)
GROUP BY cat;
-- audio, cas_dvds_musicals, cine_photo, consoles_games, dvds_blu_ray, electronics, industry_commerce_and_business, computer_accssories, books_technical, pc_gamer, computers, tablets_printing_image, telephony, fixed_telephony

SELECT COUNT(DISTINCT product_id) FROM products;
-- 32951 different products
SELECT COUNT(DISTINCT product_id) FROM products LEFT JOIN product_category_name_translation USING (product_category_name)
	WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony');
-- 2451 different tech products
SELECT 2451/32951;
-- only 7.44 % of all offered items are in tech category

-- how many products of tech categoires were sold?
-- total products (incl duplicates)
SELECT product_category_name_english AS cat, COUNT(DISTINCT product_id)
FROM
	order_items
    LEFT JOIN products
    USING (product_id)
    LEFT JOIN product_category_name_translation
    USING (product_category_name)
GROUP BY cat
HAVING cat IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
ORDER BY cat;
-- summed up (total sales)
SELECT COUNT(order_item_id)
FROM
	order_items
    LEFT JOIN products
    USING (product_id)
    LEFT JOIN product_category_name_translation
    USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
;
-- 10043
SELECT COUNT(order_item_id)
FROM
	order_items;
-- 112650
SELECT 10043/112650;
-- 8.92 % -> tech products make up 8.92 % of all sold items

/*
-- distinct products
SELECT product_category_name_english AS cat, COUNT(DISTINCT product_id)
FROM
	order_items
    LEFT JOIN products
    USING (product_id)
    LEFT JOIN product_category_name_translation
    USING (product_category_name)
GROUP BY cat
HAVING cat IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
ORDER BY cat;
-- summed up
SELECT COUNT(DISTINCT product_id)
FROM
	order_items
    LEFT JOIN products
    USING (product_id)
    LEFT JOIN product_category_name_translation
    USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
;
-- 2451
SELECT COUNT(DISTINCT product_id)
FROM
	order_items;
-- 32951
SELECT 2451/32951;
-- 7.44 % -> tech products make up 7.44 % of (distinct) sold products
*/

-- average price of products being sold
SELECT ROUND(AVG(price),2) AS avg_price
from order_items;
-- the average price of all items sold is 120.65

-- are expensive tech products popular?
SELECT 
	CASE
		WHEN price >100 THEN 'expensive'
        WHEN price <50 THEN 'low price'
        ELSE 'medium'
    END AS price_cat
, COUNT(product_id) AS n_sales
FROM
	order_items
    LEFT JOIN products
    USING (product_id)
    LEFT JOIN product_category_name_translation
    USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
GROUP BY price_cat;
SELECT 2168/(1301+6574+2168);
-- among tech products 21.59 % cost more than 100
SELECT 2168/112650;
-- 1.92 % of all sold items are tech items that are more expensive than 100

-- How many months of data are included in the magist database?
SELECT COUNT(DISTINCT YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)) AS n_months
FROM orders;
-- 25 months are considered
/*
SELECT DISTINCT YEAR(order_purchase_timestamp) AS y_order, MONTH(order_purchase_timestamp) AS m_order
FROM orders
ORDER BY y_order, m_order;
*/

-- How many sellers are there?
SELECT COUNT(DISTINCT seller_id)
FROM sellers;
-- 3095 sellers
-- How many tech sellers?
SELECT COUNT(DISTINCT seller_id)
FROM sellers
LEFT JOIN order_items
USING (seller_id)
LEFT JOIN products
USING (product_id)
LEFT JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
 ;
-- 388 sellers have products in the tech category
SELECT 388/3095;
-- 12.54 % of all sellers are tech sellers

-- total amount earned by all sellers?
SELECT SUM(price)
FROM order_items;
-- 13591643.70 is the total value of all orders

-- toatl amount earned by tech sellers?
SELECT SUM(price)
FROM order_items
LEFT JOIN products
USING (product_id)
LEFT JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
;
-- 1055387.00 is the total value of all orders in the tech category

-- average monthly income of seller?
SELECT (13591643.70/25)/3095;
-- average monthly income per seller over the considered 25 months is 175.66
SELECT (1055387.00/25)/388;
-- average monthly income per tech seller over the considered 25 months is 108.80

-- average time between order and delivery
SELECT count(*) 	
FROM orders
WHERE order_status = 'delivered';
-- 96478 orders already delivered
/*SELECT order_purchase_timestamp, order_delivered_customer_date, DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp)) AS days_diff
FROM orders
WHERE order_status = 'delivered'
LIMIT 10;
*/
SELECT AVG(DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp))) AS avg_days_diff_cust
FROM orders
WHERE order_status = 'delivered';
-- average difference between purchase and delivered to customer is 12.5 days

SELECT COUNT(*) AS n_intime_cust
FROM orders
WHERE order_status = 'delivered' AND DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp)) <= 3;
-- 16777 of the 96478 delivered orders were delivered to customer in <= 5 days
SELECT 16777/96478; -- 17.39% in 5 days
-- 6928 of the 96478 delivered orders were delivered to customer in <= 5 days
SELECT 6928/96478; -- 7.18 % in 3 days
SELECT COUNT(*) AS n_delay_cust
FROM orders
WHERE order_status = 'delivered' AND DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp)) > 7;
-- 65840 of the 96478 delivered orders were delivered in > 7 days
SELECT 65840/96478; -- 68.24% more than a week


SELECT AVG(DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp))),
	CASE
		WHEN price < 50 THEN 'small'
        WHEN price >100 THEN 'big'
        ELSE 'medium'
    END AS order_size
FROM order_items
JOIN orders
	USING(order_id)
WHERE order_status = 'delivered' 
GROUP BY order_size;
-- orders <50 have an average delivery time of 11.32 days
-- order between 50 and 100 have an average delivery time of 12.5 days
-- large order (>100) have an average delivery time of 13.41 days

DROP TABLE TempOrders;
CREATE TEMPORARY TABLE TempOrders
	SELECT order_id, order_item_id, seller_id, COUNT(DISTINCT seller_id) AS n_seller_p_order, MAX(order_item_id) AS n_items
	FROM order_items
    GROUP BY order_id;
-- SELECT * FROM TempOrders ORDER BY n_seller_p_order DESC;
/*
SELECT o.order_id, o.order_item_id, o.seller_id, n_seller_p_order, n_items
FROM order_items o
LEFT JOIN orders o2
ON o.order_id = o2.order_id
LEFT JOIN TempOrders t
ON o.order_id = t.order_id
ORDER BY n_seller_p_order DESC;
*/
SELECT o.order_id, o.order_item_id, o.seller_id, n_seller_p_order, AVG(DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp))) AS avg_delivery_n_seller
FROM order_items o
LEFT JOIN orders o2
ON o.order_id = o2.order_id
LEFT JOIN TempOrders t
ON o.order_id = t.order_id
GROUP BY n_seller_p_order
ORDER BY n_seller_p_order DESC;
-- average delivery time higherst with 1 or 5 sellers
SELECT o.order_id, o.order_item_id, o.seller_id, n_items, AVG(DATEDIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp))) AS avg_delivery_n_items
FROM order_items o
LEFT JOIN orders o2
ON o.order_id = o2.order_id
LEFT JOIN TempOrders t
ON o.order_id = t.order_id
GROUP BY n_items
ORDER BY n_items DESC;
--  average delivery time highest with 21 (most) items, however always high


--     Is Magist a good fit for high-end tech products?
-- -> Not really, only 7.44 % of all offered items are in tech category
--     Are orders delivered on time?
-- -> No


SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM product_category_name_translation;
SELECT * FROM sellers;

SELECT order_status, count(*) 	
FROM orders
GROUP BY order_status;
