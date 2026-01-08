-- ========================================
-- EVELYN PRO - SQL AVANÇADO
-- Inserção de Dados
-- ========================================

-- INSERIR CLIENTES (10 registros)
INSERT INTO clientes (nome, email, telefone, cidade, estado, segmento, data_cadastro, status) VALUES
('Ana Silva', 'ana.silva@email.com', '(11) 98765-4321', 'São Paulo', 'SP', 'Premium', '2025-01-15', 'Ativo'),
('Bruno Costa', 'bruno.costa@email.com', '(21) 97654-3210', 'Rio de Janeiro', 'RJ', 'Regular', '2025-02-20', 'Ativo'),
('Carla Mendes', 'carla.mendes@email.com', '(31) 96543-2109', 'Belo Horizonte', 'MG', 'Bronze', '2025-03-10', 'Ativo'),
('Daniel Souza', 'daniel.souza@email.com', '(41) 95432-1098', 'Curitiba', 'PR', 'Premium', '2025-01-25', 'Ativo'),
('Elaine Lima', 'elaine.lima@email.com', '(51) 94321-0987', 'Porto Alegre', 'RS', 'Regular', '2025-04-05', 'Ativo'),
('Fernando Alves', 'fernando.alves@email.com', '(61) 93210-9876', 'Brasília', 'DF', 'Bronze', '2025-02-15', 'Inativo'),
('Gabriela Santos', 'gabriela.santos@email.com', '(71) 92109-8765', 'Salvador', 'BA', 'Premium', '2025-03-20', 'Ativo'),
('Henrique Rocha', 'henrique.rocha@email.com', '(81) 91098-7654', 'Recife', 'PE', 'Regular', '2025-01-30', 'Ativo'),
('Isabela Martins', 'isabela.martins@email.com', '(85) 90987-6543', 'Fortaleza', 'CE', 'Bronze', '2025-04-10', 'Ativo'),
('João Pereira', 'joao.pereira@email.com', '(11) 99876-5432', 'São Paulo', 'SP', 'Premium', '2025-02-01', 'Ativo');

-- INSERIR PEDIDOS (15 registros)
INSERT INTO pedidos (cliente_id, data_pedido, valor_total, desconto, status_pedido, forma_pagamento, vendedor) VALUES
(1, '2025-05-10', 1500.00, 150.00, 'Entregue', 'Crédito', 'Vendedor A'),
(2, '2025-05-12', 800.00, 0.00, 'Entregue', 'PIX', 'Vendedor B'),
(3, '2025-05-15', 450.00, 50.00, 'Enviado', 'Débito', 'Vendedor A'),
(4, '2025-05-18', 2200.00, 200.00, 'Entregue', 'Crédito', 'Vendedor C'),
(5, '2025-05-20', 650.00, 0.00, 'Confirmado', 'Boleto', 'Vendedor B'),
(1, '2025-05-22', 1200.00, 100.00, 'Entregue', 'PIX', 'Vendedor A'),
(6, '2025-05-25', 300.00, 30.00, 'Cancelado', 'Crédito', 'Vendedor C'),
(7, '2025-05-28', 1800.00, 180.00, 'Entregue', 'Crédito', 'Vendedor A'),
(8, '2025-06-01', 950.00, 0.00, 'Enviado', 'PIX', 'Vendedor B'),
(9, '2025-06-05', 400.00, 40.00, 'Pendente', 'Débito', 'Vendedor C'),
(10, '2025-06-08', 3000.00, 300.00, 'Entregue', 'Crédito', 'Vendedor A'),
(2, '2025-06-10', 750.00, 0.00, 'Confirmado', 'PIX', 'Vendedor B'),
(4, '2025-06-12', 1900.00, 150.00, 'Entregue', 'Crédito', 'Vendedor C'),
(7, '2025-06-15', 1100.00, 100.00, 'Enviado', 'PIX', 'Vendedor A'),
(10, '2025-06-18', 2500.00, 250.00, 'Entregue', 'Crédito', 'Vendedor B');

-- INSERIR ENTREGAS (12 registros)
INSERT INTO entregas (pedido_id, data_envio, data_entrega_prevista, data_entrega_real, status_entrega, transportadora, custo_frete) VALUES
(1, '2025-05-11', '2025-05-15', '2025-05-14', 'Entregue', 'Loggi', 25.00),
(2, '2025-05-13', '2025-05-17', '2025-05-16', 'Entregue', 'Correios', 15.00),
(3, '2025-05-16', '2025-05-20', NULL, 'Em trânsito', 'Jadlog', 20.00),
(4, '2025-05-19', '2025-05-23', '2025-05-22', 'Entregue', 'Loggi', 30.00),
(6, '2025-05-23', '2025-05-27', '2025-05-26', 'Entregue', 'Correios', 18.00),
(8, '2025-05-29', '2025-06-02', '2025-06-01', 'Entregue', 'Loggi', 28.00),
(9, '2025-06-02', '2025-06-06', NULL, 'Em trânsito', 'Jadlog', 22.00),
(11, '2025-06-09', '2025-06-13', '2025-06-12', 'Entregue', 'Loggi', 35.00),
(13, '2025-06-13', '2025-06-17', '2025-06-16', 'Entregue', 'Correios', 25.00),
(14, '2025-06-16', '2025-06-20', NULL, 'Em trânsito', 'Jadlog', 24.00),
(15, '2025-06-19', '2025-06-23', '2025-06-22', 'Entregue', 'Loggi', 32.00),
(4, '2025-05-19', '2025-05-23', '2025-05-25', 'Atrasado', 'Correios', 20.00);

-- INSERIR MÉTRICAS DIÁRIAS (10 registros)
INSERT INTO metricas_diarias (data_referencia, visitas_site, conversoes, ticket_medio, taxa_conversao) VALUES
('2025-06-01', 1200, 45, 850.00, 3.75),
('2025-06-02', 1350, 52, 920.00, 3.85),
('2025-06-03', 1100, 38, 780.00, 3.45),
('2025-06-04', 1500, 60, 1050.00, 4.00),
('2025-06-05', 1280, 48, 890.00, 3.75),
('2025-06-06', 1420, 55, 950.00, 3.87),
('2025-06-07', 1180, 42, 820.00, 3.56),
('2025-06-08', 1600, 65, 1100.00, 4.06),
('2025-06-09', 1320, 50, 910.00, 3.79),
('2025-06-10', 1450, 58, 980.00, 4.00);
