INSERT INTO usuarios (nome, email, senha, sem_gluten, vegetariano, vegano, low_carb) VALUES
('Ana Silva', 'ana.silva@example.com', 'hashed_senha_ana', 1, 0, 0, 1),
('Bruno Costa', 'bruno.costa@example.com', 'hashed_senha_bruno', 0, 1, 0, 0),
('Carla Dias', 'carla.dias@example.com', 'hashed_senha_carla', 0, 0, 1, 0),
('Daniel Rocha', 'daniel.rocha@example.com', 'hashed_senha_daniel', 0, 0, 0, 0);

-- Teste: Tentar inserir e-mail duplicado (deve falhar)
INSERT INTO usuarios (nome, email, senha) VALUES ('Ana Duplicada', 'ana.silva@example.com', 'hashed_senha_duplicada');

-- Teste: Ver usuários inseridos
SELECT id, nome, email, sem_gluten, vegetariano, vegano, low_carb, created_at FROM usuarios;