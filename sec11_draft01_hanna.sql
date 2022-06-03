USE magist;

SELECT * FROM orders;

-- 1. How many orders are there in the dataset?
SELECT count(order_id) AS 'total_orders'
FROM orders;
-- 99441

-- 2. Are orders actually delivered?
SELECT order_id, order_status, 
	CASE
		WHEN order_status = 'delivered' THEN 1
        ELSE 0
    END AS delivered01, COUNT(*)
FROM orders
GROUP BY delivered01;
-- 96478 delivered, 2963 not yet
SELECT 96478/99441;
-- 97.02 % of orders are already delivered

SELECT order_id, order_status, count(*)
FROM orders
GROUP BY order_status;
-- 96478 delivered, detailled listing about the other order's status

-- 3. Is Magist having user growth?
-- ordered year, month
SELECT YEAR(order_purchase_timestamp) AS per_y, MONTH(order_purchase_timestamp) AS per_m, COUNT(order_id)
FROM orders
GROUP BY per_y, per_m
ORDER BY per_y, per_m;
-- highest number end 2017/beginning 2018, then decreasing, sharp drop august to sept. 2018 (16 orders), finishing with only 4 orders in Oct. 2018

-- ordered month, year to account for seasonal differences
SELECT YEAR(order_purchase_timestamp) AS per_y, MONTH(order_purchase_timestamp) AS per_m, COUNT(order_id)
FROM orders
GROUP BY per_y, per_m
ORDER BY per_m, per_y;
-- the last months are extremly low also compared to previous years

-- 4. How many products are there in the products table?
SELECT COUNT(*) FROM products; -- 32951
SELECT COUNT(DISTINCT product_id) AS count_products FROM products; -- 32951

-- 5. Which are the categories with most products?
SELECT product_category_name, COUNT( DISTINCT product_id) AS num_products_in_cat
FROM products
GROUP BY product_category_name 
ORDER BY num_products_in_cat DESC;
-- cama_mesa_banho 3029
-- esporte_lazer 2867
-- moveis_decoracao 2657
-- beleza_saude 2444
-- utilidades_domesticas 2335

-- 6. How many of those products were present in actual transactions?
SELECT COUNT(DISTINCT product_id) AS num_ordered_products
FROM order_items;
-- 32951 -> all have already been ordered

SELECT product_id, order_id, order_status 
FROM products
LEFT JOIN order_items
USING(product_id)
LEFT JOIN orders
USING(order_id);

SELECT order_status , count(product_id) AS num_products,
	CASE
		WHEN order_status = 'delivered' THEN 'delivered'
        WHEN order_status != 'delivered' AND order_status IS NOT NULL THEN 'ordered, not delivered'
        ELSE 'never ordered'
	END AS ordered_yet
FROM products
LEFT JOIN order_items
USING(product_id)
LEFT JOIN orders
USING(order_id)
GROUP BY ordered_yet;
-- all have been ordered. the "never ordered" category does not appear

-- 7. What's the price for the most expensive and cheapest product?
SELECT MIN(price) AS min_price, MAX(price) AS max_price
FROM order_items;
-- cheapest: 0.85, most expensive: 6765

-- 8. What are the highest and lowest payment values?
SELECT MIN(payment_value) AS min_payment, MAX(payment_value) AS max_payment
FROM order_payments;
-- lowest payment value: 0, highest payment value: 13664.1
SELECT MIN(payment_value) AS min_payment, MAX(payment_value) AS max_payment
FROM order_payments
WHERE payment_value != 0;
-- lowest payment value (w/o 0): 0.1, highest payment value: 13664.1

/*
SELECT * FROM products;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM order_payments;
*/
