-- ========================================
-- EVELYN PRO - SQL AVANÇADO
-- 10 Queries de Análise de Dados
-- ========================================

-- QUERY 1: Análise 360º de Pedidos
-- JOIN múltiplo com informações completas
SELECT 
    c.nome AS cliente,
    c.segmento,
    c.cidade,
    p.pedido_id,
    p.data_pedido,
    p.valor_total,
    p.forma_pagamento,
    p.vendedor,
    e.transportadora,
    e.status_entrega,
    e.data_entrega_real
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
LEFT JOIN entregas e ON p.pedido_id = e.pedido_id
WHERE p.status_pedido != 'Cancelado'
ORDER BY p.data_pedido DESC;

-- QUERY 2: Performance de Vendedores (CTE + Window Function)
WITH vendas_vendedor AS (
    SELECT 
        vendedor,
        COUNT(*) AS total_vendas,
        SUM(valor_total - desconto) AS receita_total,
        AVG(valor_total - desconto) AS ticket_medio
    FROM pedidos
    WHERE status_pedido != 'Cancelado'
    GROUP BY vendedor
)
SELECT 
    vendedor,
    total_vendas,
    ROUND(receita_total, 2) AS receita_total,
    ROUND(ticket_medio, 2) AS ticket_medio,
    RANK() OVER (ORDER BY receita_total DESC) AS ranking_receita
FROM vendas_vendedor
ORDER BY receita_total DESC;

-- QUERY 3: Lifetime Value de Clientes (CTE + LAG)
WITH historico_cliente AS (
    SELECT 
        c.cliente_id,
        c.nome,
        c.segmento,
        COUNT(p.pedido_id) AS total_pedidos,
        SUM(p.valor_total - p.desconto) AS valor_total_gasto,
        MIN(p.data_pedido) AS primeira_compra,
        MAX(p.data_pedido) AS ultima_compra
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.status_pedido != 'Cancelado'
    GROUP BY c.cliente_id, c.nome, c.segmento
)
SELECT 
    nome,
    segmento,
    total_pedidos,
    ROUND(valor_total_gasto, 2) AS ltv,
    ROUND(valor_total_gasto / total_pedidos, 2) AS ticket_medio,
    primeira_compra,
    ultima_compra,
    (ultima_compra - primeira_compra) AS dias_relacionamento
FROM historico_cliente
ORDER BY ltv DESC;

-- QUERY 4: Crescimento Mês a Mês (Window Function)
WITH vendas_mensais AS (
    SELECT 
        DATE_TRUNC('month', data_pedido) AS mes,
        COUNT(*) AS total_pedidos,
        SUM(valor_total - desconto) AS receita
    FROM pedidos
    WHERE status_pedido != 'Cancelado'
    GROUP BY DATE_TRUNC('month', data_pedido)
)
SELECT 
    TO_CHAR(mes, 'YYYY-MM') AS mes,
    total_pedidos,
    ROUND(receita, 2) AS receita,
    LAG(receita) OVER (ORDER BY mes) AS receita_mes_anterior,
    ROUND(
        ((receita - LAG(receita) OVER (ORDER BY mes)) / 
        LAG(receita) OVER (ORDER BY mes)) * 100, 2
    ) AS variacao_percentual
FROM vendas_mensais
ORDER BY mes;

-- QUERY 5: Ranking de Clientes por Receita (Window Function)
SELECT 
    c.nome,
    c.segmento,
    COUNT(p.pedido_id) AS pedidos,
    ROUND(SUM(p.valor_total - p.desconto), 2) AS receita_total,
    RANK() OVER (ORDER BY SUM(p.valor_total - p.desconto) DESC) AS ranking_geral,
    RANK() OVER (PARTITION BY c.segmento ORDER BY SUM(p.valor_total - p.desconto) DESC) AS ranking_segmento
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.status_pedido != 'Cancelado'
GROUP BY c.cliente_id, c.nome, c.segmento
ORDER BY receita_total DESC;

-- QUERY 6: Tendências de Conversão (Moving Average)
SELECT 
    data_referencia,
    visitas_site,
    conversoes,
    taxa_conversao,
    ROUND(AVG(taxa_conversao) OVER (
        ORDER BY data_referencia 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS media_movel_3dias
FROM metricas_diarias
ORDER BY data_referencia;

-- QUERY 7: Análise Multidimensional (Segmento x Forma Pagamento)
SELECT 
    c.segmento,
    p.forma_pagamento,
    COUNT(*) AS total_transacoes,
    ROUND(SUM(p.valor_total - p.desconto), 2) AS receita,
    ROUND(AVG(p.valor_total - p.desconto), 2) AS ticket_medio
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.status_pedido != 'Cancelado'
GROUP BY c.segmento, p.forma_pagamento
ORDER BY c.segmento, receita DESC;

-- QUERY 8: Performance Logística (Transportadoras)
SELECT 
    e.transportadora,
    COUNT(*) AS total_entregas,
    COUNT(CASE WHEN e.status_entrega = 'Entregue' THEN 1 END) AS entregas_sucesso,
    COUNT(CASE WHEN e.status_entrega = 'Atrasado' THEN 1 END) AS entregas_atrasadas,
    ROUND(
        (COUNT(CASE WHEN e.status_entrega = 'Entregue' THEN 1 END)::NUMERIC / 
        COUNT(*)::NUMERIC) * 100, 2
    ) AS taxa_sucesso,
    ROUND(AVG(e.custo_frete), 2) AS custo_medio_frete,
    ROUND(AVG(e.data_entrega_real - e.data_envio), 2) AS prazo_medio_dias
FROM entregas e
WHERE e.data_entrega_real IS NOT NULL
GROUP BY e.transportadora
ORDER BY taxa_sucesso DESC, custo_medio_frete ASC;

-- QUERY 9: Dataset Completo para Dashboard (KPIs)
WITH kpis AS (
    SELECT 
        COUNT(DISTINCT c.cliente_id) AS total_clientes,
        COUNT(DISTINCT CASE WHEN p.data_pedido >= CURRENT_DATE - 30 THEN c.cliente_id END) AS clientes_ativos_30d,
        COUNT(p.pedido_id) AS total_pedidos,
        ROUND(SUM(p.valor_total - p.desconto), 2) AS receita_total,
        ROUND(AVG(p.valor_total - p.desconto), 2) AS ticket_medio,
        COUNT(DISTINCT p.vendedor) AS total_vendedores
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.status_pedido != 'Cancelado'
)
SELECT * FROM kpis;

-- QUERY 10: Segmentação RFM (Recency, Frequency, Monetary)
WITH rfm AS (
    SELECT 
        c.cliente_id,
        c.nome,
        CURRENT_DATE - MAX(p.data_pedido) AS recency,
        COUNT(p.pedido_id) AS frequency,
        ROUND(SUM(p.valor_total - p.desconto), 2) AS monetary
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.status_pedido != 'Cancelado'
    GROUP BY c.cliente_id, c.nome
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm
)
SELECT 
    nome,
    recency AS dias_desde_ultima_compra,
    frequency AS total_compras,
    monetary AS valor_total_gasto,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_total,
    CASE 
        WHEN (r_score + f_score + m_score) >= 13 THEN 'VIP'
        WHEN (r_score + f_score + m_score) >= 9 THEN 'Alto Valor'
        WHEN (r_score + f_score + m_score) >= 6 THEN 'Médio Valor'
        ELSE 'Baixo Valor'
    END AS segmento_rfm
FROM rfm_scores
ORDER BY rfm_total DESC;
