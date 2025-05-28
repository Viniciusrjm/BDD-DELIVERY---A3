INSERT INTO usuarios (nome, email, senha, sem_gluten, vegetariano, vegano, low_carb) VALUES
('Ana Silva', 'ana.silva@example.com', 'hashed_senha_ana', 1, 0, 0, 1),
('Bruno Costa', 'bruno.costa@example.com', 'hashed_senha_bruno', 0, 1, 0, 0),
('Carla Dias', 'carla.dias@example.com', 'hashed_senha_carla', 0, 0, 1, 0),
('Daniel Rocha', 'daniel.rocha@example.com', 'hashed_senha_daniel', 0, 0, 0, 0);

INSERT INTO restaurantes(nome,razao_social ,cnpj,email,senha,endereco,telefone,tipo,logo_path,updated_at) VALUES  (
    'Restaurante Sabor da Terra',
    'Sabor da Terra Alimentos Ltda',
    '12.345.678/0001-90',
    'contato@saborterra.com',
    'senhaSegura123', -- idealmente, você deveria armazenar um hash da senha
    'Rua das Flores, 123 - Centro, São Paulo - SP',
    '(11) 98765-4321',
    'Comida Brasileira',
    '/imagens/logos/saborterra.png',
    CURRENT_TIMESTAMP
);


-- Teste: Tentar inserir e-mail duplicado (deve falhar)
INSERT INTO usuarios (nome, email, senha) VALUES ('Ana Duplicada', 'ana.silva@example.com', 'hashed_senha_duplicada');

-- Teste: Ver usuários inseridos
SELECT id, nome, email, sem_gluten, vegetariano, vegano, low_carb, created_at FROM usuarios;

 SELECT*FROM restaurantes;


-- testando para ver se o git está funcionando corretamente
-- Teste: Ver restaurantes inseridos