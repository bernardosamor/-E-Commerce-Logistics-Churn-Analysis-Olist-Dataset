CREATE DATABASE olist_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE olist_db;

SELECT * 
FROM product_category_name_translation; #Conferir nome do cabeçalho

SELECT * 
FROM olist_sellers_dataset;

SELECT * 
FROM olist_products_dataset;

SELECT * 
FROM olist_order_payments_dataset; #Tabela FATO

SELECT * 
FROM olist_customers_dataset;

SELECT * 
FROM olist_order_reviews_dataset;

SELECT * 
FROM olist_order_items_dataset; 

SELECT * 
FROM olist_orders_dataset; 

SELECT * 
FROM olist_geolocation_dataset; #Remover aspas

/*
#Remoção das aspas no texto
SET SQL_SAFE_UPDATES = 0;

UPDATE olist_order_items_dataset
SET 
    order_id = REPLACE(order_id, '"', ''),
    product_id = REPLACE(product_id, '"', ''),
    seller_id = REPLACE(seller_id, '"', '');

UPDATE olist_orders_dataset
SET 
    order_id = REPLACE(order_id, '"', ''),
    customer_id = REPLACE(customer_id, '"', '');

UPDATE olist_geolocation_dataset
SET 
    geolocation_zip_code_prefix = REPLACE(geolocation_zip_code_prefix, '"', '');   
*/

DROP TABLE olist_geolocation_dataset;
