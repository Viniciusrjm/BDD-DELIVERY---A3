-- Active: 1747828636490@@127.0.0.1@3306

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    senha TEXT NOT NULL,
    sem_gluten INTEGER DEFAULT 0,
    vegetariano INTEGER DEFAULT 0,
    vegano INTEGER DEFAULT 0,
    low_carb INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE restaurantes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    razao_social TEXT,
    cnpj TEXT UNIQUE,
    email TEXT UNIQUE NOT NULL,
    senha TEXT NOT NULL,
    endereco TEXT,
    telefone TEXT,
    tipo TEXT,
    logo_path TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE carrinho (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1,
    ativo INTEGER DEFAULT 1, -- 1 = ativo, 0 = convertido em pedido
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL,
    valor_total REAL NOT NULL,
    taxa_servico REAL DEFAULT 0,
    taxa_entrega REAL DEFAULT 0,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'pendente' CHECK(status IN ('pendente', 'em_preparo', 'em_transporte', 'entregue', 'cancelado')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (restaurante_id) REFERENCES restaurantes(id)
);

CREATE TABLE itens_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario REAL NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

CREATE TABLE avaliacoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL,
    nota INTEGER CHECK(nota BETWEEN 0 AND 5),
    comentario TEXT(500), -- Limite de 500 caracteres
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (restaurante_id) REFERENCES restaurantes(id)
);

CREATE TABLE produtos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    restaurante_id INTEGER NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,
    preco REAL NOT NULL,
    imagem_path TEXT,
    categoria TEXT,
    ativo INTEGER DEFAULT 1, -- 1 = ativo, 0 = inativo
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (restaurante_id) REFERENCES restaurantes(id)
);

CREATE TABLE informacoes_nutricionais (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    produto_id INTEGER NOT NULL UNIQUE,
    porcao_g REAL,
    calorias REAL,
    carboidratos REAL,
    proteinas REAL,
    gorduras_totais REAL,
    gorduras_saturadas REAL,
    gorduras_trans REAL,
    fibras REAL,
    sodio REAL,
    colesterol REAL,
    vitaminas_minerais TEXT,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

CREATE TABLE enderecos_usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    rua TEXT NOT NULL,
    numero TEXT,
    bairro TEXT NOT NULL,
    cidade TEXT NOT NULL,
    estado TEXT NOT NULL,
    cep TEXT,
    complemento TEXT,
    tipo_endereco TEXT, -- Ex: 'Casa', 'Trabalho', 'Outro'
    is_principal INTEGER DEFAULT 0, -- 1 se for o endereço principal do usuário
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE pagamentos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    metodo_pagamento TEXT NOT NULL, -- Ex: 'Cartão de Crédito', 'PIX', 'Dinheiro'
    status_pagamento TEXT DEFAULT 'pendente' CHECK(status_pagamento IN ('pendente', 'aprovado', 'recusado', 'reembolsado')),
    valor_pago REAL NOT NULL,
    transacao_id TEXT UNIQUE, -- ID da transação no gateway de pagamento, se houver
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

-- Índices para a tabela produtos
CREATE INDEX idx_produtos_restaurante_id ON produtos (restaurante_id);
CREATE INDEX idx_produtos_categoria ON produtos (categoria);

-- Índices para a tabela carrinho
CREATE UNIQUE INDEX idx_carrinho_usuario_produto_ativo ON carrinho (usuario_id, produto_id) WHERE ativo = 1; -- Garante apenas 1 item ativo de um produto por usuário
CREATE INDEX idx_carrinho_usuario_id ON carrinho (usuario_id);

-- Índices para a tabela pedidos
CREATE INDEX idx_pedidos_usuario_id ON pedidos (usuario_id);
CREATE INDEX idx_pedidos_restaurante_id ON pedidos (restaurante_id);
CREATE INDEX idx_pedidos_status ON pedidos (status);

-- Índices para a tabela itens_pedido
CREATE INDEX idx_itens_pedido_pedido_id ON itens_pedido (pedido_id);
CREATE INDEX idx_itens_pedido_produto_id ON itens_pedido (produto_id);

-- Índices para a tabela avaliacoes
CREATE INDEX idx_avaliacoes_usuario_id ON avaliacoes (usuario_id);
CREATE INDEX idx_avaliacoes_restaurante_id ON avaliacoes (restaurante_id);

-- Índices para a tabela informacoes_nutricionais
-- O UNIQUE já cria um índice para produto_id, mas para consultas por calorias, por exemplo
CREATE INDEX idx_informacoes_nutricionais_calorias ON informacoes_nutricionais (calorias);

-- Índices para a nova tabela enderecos_usuarios
CREATE INDEX idx_enderecos_usuarios_usuario_id ON enderecos_usuarios (usuario_id);

-- Índices para a nova tabela pagamentos
CREATE INDEX idx_pagamentos_pedido_id ON pagamentos (pedido_id);
-- O UNIQUE já cria um índice para transacao_id, mas para consultas por status
CREATE INDEX idx_pagamentos_status ON pagamentos (status_pagamento);

