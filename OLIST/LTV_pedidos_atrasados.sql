
WITH pedidos_atrasados_base AS (
    -- Step 1: Identifica os pedidos atrasados considerando APENAS A DATA (sem hora)
    SELECT 
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM olist_db.olist_orders_dataset o
    JOIN olist_db.olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
),

primeiro_atraso_cliente AS (
    -- Step 2: Menor data do primeiro atraso de cada pessoa
    SELECT 
        customer_unique_id,
        MIN(order_purchase_timestamp) AS data_primeiro_atraso
    FROM pedidos_atrasados_base
    GROUP BY customer_unique_id
),

comportamento_pos_atraso AS (
    -- Step 3: Compras posteriores ao primeiro atraso
    SELECT 
        p.customer_unique_id,
        COUNT(o.order_id) AS qtd_compras_posteriores
    FROM primeiro_atraso_cliente p
    LEFT JOIN olist_db.olist_customers_dataset c ON p.customer_unique_id = c.customer_unique_id
    LEFT JOIN olist_db.olist_orders_dataset o 
        ON c.customer_id = o.customer_id
       AND o.order_purchase_timestamp > p.data_primeiro_atraso
       AND o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY p.customer_unique_id
)

-- Step 4: Métricas Consolidadas
SELECT 
    -- Total de pedidos atrasados (Deve bater exatamente com os 6.534 do Power BI)
    (SELECT COUNT(order_id) FROM pedidos_atrasados_base) AS total_pedidos_atrasados,
    
    -- Total de clientes únicos afetados por esses 6.534 pedidos
    COUNT(c.customer_unique_id) AS total_clientes_afetados,
    
    -- Quantos voltaram a comprar
    COUNT(CASE WHEN c.qtd_compras_posteriores > 0 THEN c.customer_unique_id END) AS clientes_recompraram,
    
    -- Quantos nunca mais compraram
    COUNT(CASE WHEN c.qtd_compras_posteriores = 0 THEN c.customer_unique_id END) AS clientes_churned,
    
    -- % de Retenção após atraso
    ROUND(
        100.0 * COUNT(CASE WHEN c.qtd_compras_posteriores > 0 THEN c.customer_unique_id END) / COUNT(c.customer_unique_id), 
        2
    ) AS pct_retencao_pos_atraso
FROM comportamento_pos_atraso c;