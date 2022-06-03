USE magist;

CREATE TEMPORARY TABLE TempPrice
SELECT product_id, order_item_id, price
FROM products
LEFT JOIN order_items
USING (product_id);

CREATE TABLE products_hnn AS
SELECT * FROM products
LEFT JOIN product_category_name_translation
USING (product_category_name)
LEFT JOIN TempPrice
USING (product_id);

SELECT * FROM products_hnn;












SELECT MIN(price), MAX(price)
FROM products
LEFT JOIN order_items
USING (product_id)
WHERE product_category_name IN ('eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'audio');

CREATE TEMPORARY TABLE TempTech
	SELECT product_category_name, product_category_name_english, CASE WHEN product_category_name_english IN ('audio', 'electronics') THEN 'technology'
						ELSE 'not technology'
	FROM product_category_name_translation ;




ALTER TABLE products_hnn ADD COLUMN technology VARCHAR(20);
UPDATE products_hnn
	SET technology = CASE WHEN product_category_name_english IN ('audio', 'electronics') THEN 'technology'
						ELSE 'not technology')
                        END;



ALTER TABLE products
ADD COLUMN technology VARCHAR(20), ADD price_cat VARCHAR(20) ;

INSERT INTO products (price_cat)
SELECT CASE WHEN price > 1000 THEN 'high' WHEN price < 50 THEN 'low' ELSE 'medium' END
FROM products
LEFT JOIN order_items ON products.product_id = order_items.product_id;

INSERT INTO products (technology)
VALUES
( CASE WHEN product_category_name_english IN ('audio', 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics') THEN 'technology'
ELSE 'not technology' );

UPDATE products
SET technology = 
	CASE WHEN product_category_name_english IN ('audio') -- , 'cas_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics') -- , 'industry_commerce_and_business', 'computer_accssories', 'books_technical', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
	THEN 'technology' ELSE  'not technology' END;
FROM products
LEFT JOIN product_category_name_translation
USING (product_category_name);

ALTER TABLE products DROP COLUMN technology;
ALTER TABLE products DROP COLUMN price_cat;
DROP TABLE TempTech;
DROP TABLE products_hnn;
SELECT * FROM products;
INSERT INTO products (price_cat)
SELECT CASE WHEN product_name_length<20 THEN 'small' END;