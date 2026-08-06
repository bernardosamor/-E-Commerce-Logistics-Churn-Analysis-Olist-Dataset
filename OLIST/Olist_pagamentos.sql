SELECT * FROM olist_db.olist_order_payments_dataset;

-- Entendendo a distribuição de formas de pagamento
SELECT payment_type,
COUNT(*) AS formas_pagamento
FROM  olist_db.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY formas_pagamento DESC;

-- Unir com a tabela de order e entender se existe algum viés de cancelamento por forma de pagamento (se elas tiverem proporções similares, os cancelamentos seguem a lógica da base, não mostrando anomalias)
-- Hipótese: boletos normalmente podem levar a cancelamentos de vendas pela necessidade de confirmação manual da compra
SELECT 
	payment_type,
	COUNT(*) AS formas_pagamento,
	COUNT(DISTINCT order_id)/(SELECT
									COUNT(DISTINCT order_id)
                                    FROM olist_db.olist_order_payments_dataset) * 100 AS percentual_do_total
FROM  olist_db.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY formas_pagamento DESC;
