USE EditoraLivros;

-- Inserir Editoras
INSERT INTO EDITORAS (nome, cidade, pais) VALUES
('Companhia das Letras', 'São Paulo', 'Brasil'),
('Sextante', 'Rio de Janeiro', 'Brasil'),
('Record', 'Rio de Janeiro', 'Brasil'),
('Intrínseca', 'Rio de Janeiro', 'Brasil'),
('Rocco', 'Rio de Janeiro', 'Brasil'),
('Arqueiro', 'São Paulo', 'Brasil'),
('Principis', 'São Paulo', 'Brasil'),
('HarperCollins', 'Nova York', 'EUA'),
('Penguin Random House', 'Londres', 'Reino Unido'),
('Editora 34', 'São Paulo', 'Brasil');

-- Inserir Áreas de Conhecimento
INSERT INTO AREAS_CONHECIMENTO (descricao) VALUES
('Literatura Brasileira'),
('Ficção Científica'),
('Fantasia'),
('Romance'),
('Autoajuda'),
('Negócios'),
('Tecnologia'),
('História'),
('Biografia'),
('Infantojuvenil');

-- Inserir Palavras-Chave
INSERT INTO PALAVRAS_CHAVE (descricao) VALUES
('best-seller'),
('clássico'),
('suspense'),
('distopia'),
('mitologia'),
('empreendedorismo'),
('ciência de dados'),
('guerra'),
('memórias'),
('magia');

-- Inserir Autores (COM DATA CORRIGIDA)
INSERT INTO AUTORES (nome, email, biografia, nacionalidade, data_nascimento) VALUES
('Clarice Lispector', 'clarice@email.com', 'Escritora e jornalista brasileira', 'Ucraniana-Brasileira', '1920-12-10'),
('George Orwell', 'orwell@email.com', 'Escritor e jornalista britânico', 'Britânico', '1903-06-25'),
('J.K. Rowling', 'jkrowling@email.com', 'Escritora britânica', 'Britânica', '1965-07-31'),
('Augusto Cury', 'cury@email.com', 'Psiquiatra e escritor brasileiro', 'Brasileiro', '1958-10-02'),
('Yuval Noah Harari', 'harari@email.com', 'Historiador e autor israelense', 'Israelense', '1976-02-24'),
('Rick Riordan', 'riordan@email.com', 'Escritor americano', 'Americano', '1964-06-05'),
('Leandro Karnal', 'karnal@email.com', 'Historiador e escritor brasileiro', 'Brasileiro', '1963-02-01'),
('J.R.R. Tolkien', 'tolkien@email.com', 'Escritor britânico', 'Britânico', '1892-01-03'),
('Sun Tzu', 'suntzu@email.com', 'Estrategista militar chinês', 'Chinês', NULL),
('Monteiro Lobato', 'lobato@email.com', 'Escritor brasileiro', 'Brasileiro', '1882-04-18');

-- Inserir Livros (COM ISBNs ÚNICOS E DATAS VÁLIDAS)
INSERT INTO LIVROS (isbn, titulo, id_editora, data_publicacao, genero, num_paginas, descricao, edicao, preco_sugerido, custo_producao) VALUES
('9788535901234', 'A Hora da Estrela', 1, '1977-01-01', 'Romance', 88, 'Último romance de Clarice Lispector', 1, 29.90, 12.50),
('9780451524935', '1984', 8, '1949-06-08', 'Ficção Científica', 328, 'Clássico da literatura distópica', 3, 45.00, 18.75),
('9788532530663', 'Harry Potter e a Pedra Filosofal', 9, '1997-06-26', 'Fantasia', 264, 'Primeiro livro da saga', 1, 39.90, 15.00),
('9788543102100', 'Ansiedade', 2, '2013-01-01', 'Autoajuda', 256, 'Como enfrentar o mal do século', 5, 34.90, 10.25),
('9788535932500', 'Sapiens', 1, '2011-01-01', 'História', 464, 'Breve história da humanidade', 1, 59.90, 22.00),
('9788595088800', 'Percy Jackson e o Ladrão de Raios', 4, '2005-06-28', 'Fantasia', 400, 'Série baseada na mitologia grega', 1, 37.50, 14.30),
('9788576791200', 'O Mundo Assombrado', 7, '2019-01-01', 'História', 304, 'História da humanidade', 1, 44.90, 17.80),
('9788533613800', 'O Senhor dos Anéis', 3, '1954-07-29', 'Fantasia', 1216, 'Trilogia épica', 2, 89.90, 35.00),
('9788575422920', 'A Arte da Guerra', 10, NULL, 'Estratégia', 96, 'Tratado militar clássico', 10, 19.90, 6.50),
('9788578934500', 'Reinações de Narizinho', 5, '1931-01-01', 'Infantojuvenil', 192, 'Clássico da literatura infantil', 1, 32.50, 11.20);

-- Relacionar Livros e Autores (COM NOVOS ISBNs)
INSERT INTO LIVRO_AUTOR (isbn, id_autor) VALUES
('9788535901234', 1),
('9780451524935', 2),
('9788532530663', 3),
('9788543102100', 4),
('9788535932500', 5),
('9788595088800', 6),
('9788576791200', 7),
('9788533613800', 8),
('9788575422920', 9),
('9788578934500', 10);

-- Relacionar Livros e Áreas (COM NOVOS ISBNs)
INSERT INTO LIVRO_AREA (isbn, id_area) VALUES
('9788535901234', 1),
('9780451524935', 2),
('9788532530663', 3),
('9788543102100', 5),
('9788535932500', 8),
('9788595088800', 3),
('9788576791200', 8),
('9788533613800', 3),
('9788575422920', 7),
('9788578934500', 10);

-- Relacionar Livros e Palavras-Chave (COM NOVOS ISBNs)
INSERT INTO LIVRO_PALAVRA (isbn, id_palavra) VALUES
('9788535901234', 2),
('9780451524935', 4),
('9788532530663', 10),
('9788543102100', 1),
('9788535932500', 1),
('9788595088800', 5),
('9788576791200', 8),
('9788533613800', 2),
('9788575422920', 9),
('9788578934500', 2);

-- Inserir Departamentos
INSERT INTO DEPARTAMENTOS (nome, descricao) VALUES
('Editorial', 'Responsável pela seleção e edição de obras'),
('Produção', 'Coordena a impressão e produção física'),
('Marketing', 'Promoção e divulgação dos livros'),
('Vendas', 'Comercialização e distribuição'),
('RH', 'Gestão de recursos humanos'),
('Financeiro', 'Gestão financeira e contábil'),
('TI', 'Tecnologia da informação'),
('Atendimento', 'Suporte a clientes e livrarias'),
('Eventos', 'Organização de lançamentos e feiras'),
('Tradução', 'Tradução de obras internacionais');

-- Inserir Funcionários
INSERT INTO FUNCIONARIOS (nome, cargo, telefone, endereco, id_departamento) VALUES
('Carlos Silva', 'Editor Chefe', '(11) 99999-1111', 'Rua A, 100 - SP', 1),
('Ana Costa', 'Coordenadora de Produção', '(21) 99999-2222', 'Av. B, 200 - RJ', 2),
('Pedro Santos', 'Gerente de Marketing', '(11) 99999-3333', 'Rua C, 300 - SP', 3),
('Juliana Pereira', 'Diretora de Vendas', '(21) 99999-4444', 'Av. D, 400 - RJ', 4),
('Roberto Oliveira', 'Analista RH', '(11) 99999-5555', 'Rua E, 500 - SP', 5),
('Fernanda Lima', 'Contadora', '(21) 99999-6666', 'Av. F, 600 - RJ', 6),
('Marcos Souza', 'Desenvolvedor', '(11) 99999-7777', 'Rua G, 700 - SP', 7),
('Patrícia Rocha', 'Atendente', '(21) 99999-8888', 'Av. H, 800 - RJ', 8),
('Ricardo Mendes', 'Organizador de Eventos', '(11) 99999-9999', 'Rua I, 900 - SP', 9),
('Camila Alves', 'Tradutora', '(21) 99999-0000', 'Av. J, 1000 - RJ', 10);

-- Atualizar Departamentos com responsáveis
UPDATE DEPARTAMENTOS SET id_responsavel = 1 WHERE id_departamento = 1;
UPDATE DEPARTAMENTOS SET id_responsavel = 2 WHERE id_departamento = 2;
UPDATE DEPARTAMENTOS SET id_responsavel = 3 WHERE id_departamento = 3;
UPDATE DEPARTAMENTOS SET id_responsavel = 4 WHERE id_departamento = 4;
UPDATE DEPARTAMENTOS SET id_responsavel = 5 WHERE id_departamento = 5;
UPDATE DEPARTAMENTOS SET id_responsavel = 6 WHERE id_departamento = 6;
UPDATE DEPARTAMENTOS SET id_responsavel = 7 WHERE id_departamento = 7;
UPDATE DEPARTAMENTOS SET id_responsavel = 8 WHERE id_departamento = 8;
UPDATE DEPARTAMENTOS SET id_responsavel = 9 WHERE id_departamento = 9;
UPDATE DEPARTAMENTOS SET id_responsavel = 10 WHERE id_departamento = 10;

-- Inserir Fornecedores
INSERT INTO FORNECEDORES (nome, contato, endereco) VALUES
('Papelaria ABC', 'João Silva', 'Rua K, 1100 - SP'),
('Gráfica Express', 'Maria Oliveira', 'Av. L, 1200 - RJ'),
('Encadernadora Premium', 'Carlos Santos', 'Rua M, 1300 - SP'),
('Logística Rápida', 'Ana Costa', 'Av. N, 1400 - RJ'),
('Distribuidora Nacional', 'Pedro Mendes', 'Rua O, 1500 - SP'),
('Insumos Gráficos', 'Juliana Pereira', 'Av. P, 1600 - RJ'),
('Transportes Livreiros', 'Roberto Almeida', 'Rua Q, 1700 - SP'),
('Digital Print', 'Fernanda Lima', 'Av. R, 1800 - RJ'),
('Papel Reciclado SA', 'Marcos Souza', 'Rua S, 1900 - SP'),
('Capa Dura Ltda', 'Patrícia Rocha', 'Av. T, 2000 - RJ');

-- Inserir Exemplares (COM NOVOS ISBNs)
INSERT INTO EXEMPLARES (isbn, estado, localizacao, id_fornecedor) VALUES
('9788535901234', 'disponível', 'Prateleira A1', 1),
('9780451524935', 'reservado', 'Prateleira A2', 2),
('9788532530663', 'disponível', 'Prateleira B1', 3),
('9788543102100', 'disponível', 'Prateleira C1', 4),
('9788535932500', 'vendido', 'Entregue', 5),
('9788595088800', 'disponível', 'Prateleira D1', 6),
('9788576791200', 'danificado', 'Setor Reciclagem', 7),
('9788533613800', 'disponível', 'Prateleira E1', 8),
('9788575422920', 'reservado', 'Prateleira F1', 9),
('9788578934500', 'disponível', 'Prateleira G1', 10);

-- Inserir Clientes
INSERT INTO CLIENTES (nome, contato, telefone) VALUES
('Livraria Cultura', 'Sra. Silva', '(11) 98888-1111'),
('Saraiva Megastore', 'Sr. Oliveira', '(21) 98888-2222'),
('Amazon Brasil', 'Sra. Santos', '(11) 98888-3333'),
('Livraria Leitura', 'Sr. Costa', '(31) 98888-4444'),
('Fnac Brasil', 'Sra. Mendes', '(11) 98888-5555'),
('Americanas', 'Sr. Pereira', '(21) 98888-6666'),
('Submarino', 'Sra. Almeida', '(11) 98888-7777'),
('Shoptime', 'Sr. Lima', '(21) 98888-8888'),
('Magazine Luiza', 'Sra. Souza', '(11) 98888-9999'),
('Mercado Livre', 'Sr. Rocha', '(21) 98888-0000');

-- Inserir Endereços de Clientes
INSERT INTO CLIENTE_ENDERECOS (id_cliente, tipo, endereco, cidade, cep) VALUES
(1, 'entrega', 'Av. Paulista, 1000 - SP', 'São Paulo', '01310-100'),
(1, 'cobrança', 'Rua Augusta, 2000 - SP', 'São Paulo', '01305-000'),
(2, 'entrega', 'Av. Rio Branco, 300 - RJ', 'Rio de Janeiro', '20040-007'),
(3, 'entrega', 'Rua Fidencio Ramos, 400 - SP', 'São Paulo', '04551-010'),
(4, 'entrega', 'Av. Contorno, 500 - BH', 'Belo Horizonte', '30110-010'),
(5, 'entrega', 'Rua Oscar Freire, 600 - SP', 'São Paulo', '01426-000'),
(6, 'entrega', 'Av. Nossa Sra. Copacabana, 700 - RJ', 'Rio de Janeiro', '22070-011'),
(7, 'entrega', 'Rua Funchal, 800 - SP', 'São Paulo', '04551-060'),
(8, 'entrega', 'Av. Borges de Medeiros, 900 - RJ', 'Rio de Janeiro', '22430-041'),
(9, 'entrega', 'Rua Carlos Gomes, 1000 - SP', 'São Paulo', '04512-001');

-- Inserir Pedidos
INSERT INTO PEDIDOS (id_cliente, data_pedido, status) VALUES
(1, '2023-01-15 10:30:00', 'enviado'),
(2, '2023-01-20 14:45:00', 'processando'),
(3, '2023-02-01 09:15:00', 'pendente'),
(4, '2023-02-10 11:20:00', 'enviado'),
(5, '2023-02-15 16:30:00', 'cancelado'),
(6, '2023-03-05 08:00:00', 'enviado'),
(7, '2023-03-10 13:45:00', 'processando'),
(8, '2023-03-15 15:20:00', 'pendente'),
(9, '2023-04-01 10:00:00', 'enviado'),
(10, '2023-04-10 17:30:00', 'processando');

-- Inserir Itens de Pedido (COM NOVOS ISBNs)
INSERT INTO ITENS_PEDIDO (id_pedido, isbn, quantidade, preco_unitario, desconto) VALUES
(1, '9788535901234', 10, 25.00, 0.05),
(1, '9788532530663', 5, 35.00, 0.10),
(2, '9788543102100', 20, 30.00, 0.00),
(3, '9788535932500', 8, 50.00, 0.15),
(4, '9788595088800', 15, 30.00, 0.05),
(5, '9788576791200', 12, 40.00, 0.20),
(6, '9788533613800', 7, 80.00, 0.00),
(7, '9788575422920', 25, 15.00, 0.10),
(8, '9788578934500', 30, 25.00, 0.05),
(9, '9788535901234', 10, 25.00, 0.00);

-- Inserir Vendas
INSERT INTO VENDAS (id_pedido, data_venda, metodo_pagamento, status_pagamento) VALUES
(1, '2023-01-18 14:00:00', 'Cartão Crédito', 'aprovado'),
(2, '2023-01-25 11:30:00', 'Boleto', 'pendente'),
(4, '2023-02-12 10:45:00', 'Transferência', 'aprovado'),
(6, '2023-03-08 09:15:00', 'Cartão Crédito', 'aprovado'),
(9, '2023-04-03 15:20:00', 'PIX', 'aprovado'),
(1, '2023-01-20 16:00:00', 'Cartão Débito', 'aprovado'),
(3, '2023-02-05 14:30:00', 'Boleto', 'recusado'),
(4, '2023-02-15 12:00:00', 'Cartão Crédito', 'aprovado'),
(7, '2023-03-12 11:45:00', 'PIX', 'pendente'),
(10, '2023-04-15 17:00:00', 'Transferência', 'aprovado');

-- Inserir Itens de Venda (IDs de exemplares atualizados)
INSERT INTO ITENS_VENDA (id_venda, id_exemplar, preco_venda) VALUES
(1, 1, 25.00),
(1, 3, 35.00),
(2, 4, 30.00),
(3, 6, 30.00),
(4, 8, 80.00),
(5, 10, 25.00),
(6, 2, 25.00),
(7, 5, 50.00),
(8, 7, 40.00),
(9, 9, 15.00);

-- Inserir Histórico de Exemplares
INSERT INTO HISTORICO_EXEMPLARES (id_exemplar, estado_anterior, estado_novo, id_funcionario) VALUES
(1, 'disponível', 'reservado', 1),
(2, 'disponível', 'reservado', 2),
(3, 'disponível', 'vendido', 3),
(4, 'disponível', 'danificado', 4),
(5, 'reservado', 'vendido', 5),
(6, 'disponível', 'reservado', 6),
(7, 'disponível', 'danificado', 7),
(8, 'reservado', 'disponível', 8),
(9, 'disponível', 'reservado', 9),
(10, 'reservado', 'vendido', 10);

-- Inserir Eventos
INSERT INTO EVENTOS (tipo, data_evento, localizacao, descricao) VALUES
('lançamento', '2023-05-10 19:00:00', 'Livraria Cultura - SP', 'Lançamento novo livro de ficção'),
('sessão_autógrafos', '2023-05-15 16:00:00', 'Saraiva Megastore - RJ', 'Sessão com autor best-seller'),
('feira_livros', '2023-06-01 10:00:00', 'Bienal do Livro - SP', 'Participação na feira internacional'),
('lançamento', '2023-06-10 18:30:00', 'Fnac Paulista - SP', 'Lançamento coletivo novos autores'),
('sessão_autógrafos', '2023-06-20 15:00:00', 'Livraria Leitura - BH', 'Encontro com escritora premiada'),
('feira_livros', '2023-07-05 09:00:00', 'Feira do Livro de Porto Alegre', 'Estande com obras regionais'),
('lançamento', '2023-07-15 19:30:00', 'Casa das Rosas - SP', 'Lançamento livro de poesia'),
('sessão_autógrafos', '2023-08-01 17:00:00', 'CCBB - RJ', 'Sessão com autor internacional'),
('feira_livros', '2023-08-10 10:00:00', 'Feira Literária de Paraty', 'Participação com editora convidada'),
('lançamento', '2023-09-05 18:00:00', 'Museu da Língua Portuguesa - SP', 'Lançamento obra de referência');

-- Relacionar Livros e Eventos (COM NOVOS ISBNs)
INSERT INTO LIVRO_EVENTO (id_evento, isbn) VALUES
(1, '9788535901234'),
(2, '9788532530663'),
(3, '9788543102100'),
(4, '9788535932500'),
(5, '9788595088800'),
(6, '9788576791200'),
(7, '9788533613800'),
(8, '9788575422920'),
(9, '9788578934500'),
(10, '9788535901234');

-- Inserir Avaliações (COM NOVOS ISBNs)
INSERT INTO AVALIACOES (isbn, id_cliente, nota, comentario, data_avaliacao) VALUES
('9788535901234', 1, 5, 'Obra-prima da literatura brasileira', '2023-02-01 10:00:00'),
('9788532530663', 2, 4, 'Leitura obrigatória para todos', '2023-02-05 14:30:00'),
('9788543102100', 3, 3, 'Bom conteúdo mas linguagem difícil', '2023-02-10 11:45:00'),
('9788535932500', 4, 5, 'Mudou minha visão de mundo', '2023-02-15 09:15:00'),
('9788595088800', 5, 4, 'Divertido e educativo para jovens', '2023-03-01 16:20:00'),
('9788576791200', 6, 5, 'Análise profunda da condição humana', '2023-03-05 08:45:00'),
('9788533613800', 7, 5, 'Clássico atemporal da fantasia', '2023-03-10 13:00:00'),
('9788575422920', 8, 4, 'Conceitos úteis para liderança', '2023-03-15 15:30:00'),
('9788578934500', 9, 5, 'Encantador como na minha infância', '2023-04-01 10:45:00'),
('9788535901234', 10, 4, 'Leitura densa mas recompensadora', '2023-04-10 17:15:00');