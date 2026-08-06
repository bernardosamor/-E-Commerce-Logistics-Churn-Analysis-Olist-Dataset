SELECT * FROM olist_db.olist_orders_dataset;

#1) Entendendo a natureza dos status de vendas 
SELECT order_status,
COUNT(*) AS quantidade_vendas_por_status
FROM  olist_db.olist_orders_dataset
GROUP BY order_status
ORDER BY quantidade_vendas_por_status DESC;
-- Resposta: status canceled e unavaliable preocupam

-- Considerando que canceled e unavailable representamd vendas não concretizadas, estimar o impacto destas 2 no faturamento total.
SELECT 
    COUNT(*) AS total_pedidos_geral,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS cancelados,
    SUM(CASE WHEN order_status = 'unavailable' THEN 1 ELSE 0 END) AS indisponiveis,
    
    -- Calculando as taxas percentuais arredondadas
    ROUND((SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS taxa_cancelamento_pct,
    ROUND((SUM(CASE WHEN order_status = 'unavailable' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS taxa_indisponivel_pct
FROM olist_db.olist_orders_dataset;
	-- Resposta: Posso assumir que a taxa de cancelamento não representa um montante muito considerável no orçamento final

#2) Quanto dinheiro deixou de ganhar com essas vendas canceladas?
-- Fazer um join para estimar o custo de cada order_id e filtrar apenas as canceladas/indisponíveis
CREATE OR REPLACE VIEW olist_db.v_pedidos_com_faturamento AS 
SELECT
	Olist_pedidos.order_id,
	Olist_pedidos.order_status AS status_pedidos,
    Olist_pagamentos.payment_value
FROM olist_order_payments_dataset AS Olist_pagamentos
JOIN olist_orders_dataset AS Olist_pedidos
	ON Olist_pedidos.order_id = Olist_pagamentos.order_id
WHERE Olist_pedidos.order_status IN ('canceled', 'unavailable');
SELECT * FROM olist_db.v_pedidos_com_faturamento;

-- Somando o faturamento perdido e comparando com total em termos percentuais. Verificando natureza das vendas (confirmando se o ticket das vendas não concretizadas influenciava)
SELECT 
	ROUND(SUM(Olist_pagamentos.payment_value), 2) AS faturamento_total_geral,
	ROUND(SUM(CASE WHEN Olist_pedidos.order_status IN ('canceled', 'unavailable') 
                   THEN Olist_pagamentos.payment_value ELSE 0 END), 2) AS faturamento_total_perdido,
   ROUND(
        (SUM(CASE WHEN Olist_pedidos.order_status IN ('canceled', 'unavailable') THEN Olist_pagamentos.payment_value ELSE 0 END) 
        / SUM(Olist_pagamentos.payment_value)) * 100, 2) AS porcentagem_faturamento
FROM olist_db.olist_order_payments_dataset AS Olist_pagamentos 
JOIN olist_db.olist_orders_dataset    AS Olist_pedidos
	ON Olist_pedidos.order_id = Olist_pagamentos.order_id;													
-- Resposta: R$ 269735.11 (vendas canceladas ou indisponíveis) -> 1,68% do faturamento
-- Plano de ação: reavaliar os planos de distribuição de estoque, considernado que a indisponibilidade de produtos influenciou em 49% do faturamento de vendas não realizadas.
	
#3) Entendendo se existe algum gatilho para cancelamento de vendas.
-- Filtrando vendas canceladas foram realizadas via boleto (entender se ele é gatilho)

CREATE OR REPLACE VIEW olist_db.v_pedidos_com_forma_pagamento AS
SELECT 
    Olist_pagamentos.payment_type AS forma_pagamento,
    COUNT(DISTINCT Olist_pedidos.order_id) AS total_pedidos_cancelados,
    COUNT(DISTINCT Olist_pedidos.order_id)/(SELECT
												COUNT(DISTINCT order_id) 
												FROM olist_db.olist_orders_dataset 
                                                WHERE order_status = 'canceled') * 100 AS percentual_total
FROM olist_db.olist_order_payments_dataset AS Olist_pagamentos
JOIN olist_db.olist_orders_dataset AS Olist_pedidos
    ON Olist_pedidos.order_id = Olist_pagamentos.order_id -- Chave com chave!
WHERE Olist_pedidos.order_status = 'canceled' -- Olha apenas os cancelados
GROUP BY Olist_pagamentos.payment_type
ORDER BY total_pedidos_cancelados DESC;
SELECT * FROM olist_db.v_pedidos_com_forma_pagamento;
-- Resposta: A proporção de cancelamentos por forma de pagamento mostra viés para vendas via voucher e não boleto, como proposto inicialmente. Se compararmos as vendas percentuais totais da base, elas são 4% via voucher, mas os cancelamentos são 15%, um aumento de 400%
-- Plano de ação: Considerando que o cliente se frusta com voucher e indisponibilidade, quando o cliente selecionar o voucher, fazer uma varredura no estoque para garantir que a compra pode serguir em frente.
