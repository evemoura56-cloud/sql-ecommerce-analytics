-- ========================================
-- EVELYN PRO - SQL AVANÇADO
-- Criação das Tabelas
-- ========================================

-- Limpar tabelas se já existirem
DROP TABLE IF EXISTS metricas_diarias;
DROP TABLE IF EXISTS entregas;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;

-- 1. TABELA DE CLIENTES
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(50),
    estado CHAR(2),
    segmento VARCHAR(20) CHECK (segmento IN ('Premium', 'Regular', 'Bronze')),
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(10) CHECK (status IN ('Ativo', 'Inativo')) DEFAULT 'Ativo'
);

-- 2. TABELA DE PEDIDOS
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    data_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    valor_total DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) DEFAULT 0,
    status_pedido VARCHAR(20) CHECK (status_pedido IN ('Pendente', 'Confirmado', 'Enviado', 'Entregue', 'Cancelado')),
    forma_pagamento VARCHAR(20) CHECK (forma_pagamento IN ('Crédito', 'Débito', 'PIX', 'Boleto')),
    vendedor VARCHAR(50),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- 3. TABELA DE ENTREGAS
CREATE TABLE entregas (
    entrega_id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    data_envio DATE,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    status_entrega VARCHAR(20) CHECK (status_entrega IN ('Em trânsito', 'Entregue', 'Atrasado', 'Devolvido')),
    transportadora VARCHAR(50),
    custo_frete DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

-- 4. TABELA DE MÉTRICAS DIÁRIAS
CREATE TABLE metricas_diarias (
    metrica_id SERIAL PRIMARY KEY,
    data_referencia DATE NOT NULL UNIQUE,
    visitas_site INTEGER DEFAULT 0,
    conversoes INTEGER DEFAULT 0,
    ticket_medio DECIMAL(10, 2),
    taxa_conversao DECIMAL(5, 2)
);

-- Criar índices para otimização
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_entregas_pedido ON entregas(pedido_id);
CREATE INDEX idx_metricas_data ON metricas_diarias(data_referencia);
