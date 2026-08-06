SELECT 
    c.customer_state AS uf_cliente,
    
    -- Métricas de Quantidade
    COUNT(o.order_id) AS total_pedidos,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS pedidos_cancelados,
    SUM(CASE WHEN o.order_status = 'unavailable' THEN 1 ELSE 0 END) AS pedidos_indisponiveis,
    
    -- Métricas de Atraso
    SUM(CASE 
            WHEN o.order_status = 'delivered' 
                 AND DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) 
            THEN 1 ELSE 0 
        END) AS pedidos_atrasados,
    
    ROUND(
        (
            SUM(CASE WHEN o.order_status = 'delivered' AND DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN 1 ELSE 0 END) 
            / NULLIF(SUM(CASE WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END), 0)
        ) * 100, 
        2
    ) AS pct_atraso,
    
    ROUND(
        AVG(CASE WHEN o.order_status = 'delivered' THEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) END), 
        1
    ) AS media_dias_desvio,

    -- 💰 NOVAS MÉTRICAS DE FATURAMENTO:
    -- Faturamento Total por Estado (soma dos produtos dos pedidos entregues/válidos)
    ROUND(SUM(COALESCE(i.faturamento_pedido, 0)), 2) AS faturamento_total,
    
    -- Faturamento Retido em Atrasos (valor dos produtos que atrasaram)
    ROUND(
        SUM(CASE 
                WHEN o.order_status = 'delivered' 
                     AND DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) 
                THEN COALESCE(i.faturamento_pedido, 0) 
                ELSE 0 
            END), 
        2
    ) AS faturamento_atrasado

FROM olist_db.olist_orders_dataset o
JOIN olist_db.olist_customers_dataset c 
    ON o.customer_id = c.customer_id

-- Subquery para somar o valor total de itens por pedido sem duplicar linhas no JOIN
LEFT JOIN (
    SELECT 
        order_id, 
        SUM(price) AS faturamento_pedido
    FROM olist_db.olist_order_items_dataset
    GROUP BY order_id
) i ON o.order_id = i.order_id
GROUP BY c.customer_state
ORDER BY pct_atraso DESC;