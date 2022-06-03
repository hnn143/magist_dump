USE magist;

SELECT COUNT(DISTINCT product_id) FROM products;
SELECT * FROM product_category_name_translation;
SELECT COUNT(DISTINCT product_category_name) FROM product_category_name_translation;
SELECT COUNT(*)
FROM products
LEFT JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cine_photo', 'consoles_games', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'watches_gifts')
;
-- total 3425
SELECT product_category_name_english, COUNT(*)
FROM products
LEFT JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cine_photo', 'consoles_games', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'watches_gifts')
GROUP BY product_category_name_english
ORDER BY COUNT(*) DESC;

SELECT product_category_name_english, COUNT(*)
FROM order_items
LEFT JOIN products
USING (product_id)
LEFT JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ('audio', 'cine_photo', 'consoles_games', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'watches_gifts')
GROUP BY product_category_name_english
ORDER BY COUNT(*) DESC;

