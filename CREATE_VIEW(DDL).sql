DROP DATABASE IF EXISTS EditoraLivros;
CREATE DATABASE EditoraLivros DEFAULT CHARACTER SET utf8mb4;
USE EditoraLivros;
-- Criação das tabelas principais
CREATE TABLE LIVROS (
    isbn VARCHAR(13) PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    editora VARCHAR(100) NOT NULL,
    data_publicacao DATE,
    genero VARCHAR(50),
    num_paginas INT,
    descricao TEXT
);

CREATE TABLE AUTORES (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    biografia TEXT,
    nacionalidade VARCHAR(50),
    data_nascimento DATE
);

CREATE TABLE AREAS_CONHECIMENTO (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL
);

CREATE TABLE PALAVRAS_CHAVE (
    id_palavra INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE CLIENTES (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100),
    endereco VARCHAR(255)
);

CREATE TABLE DEPARTAMENTOS (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    id_responsavel INT -- FK adicionada posteriormente
);

CREATE TABLE FUNCIONARIOS (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTOS(id_departamento)
);

CREATE TABLE EXEMPLARES (
    id_exemplar INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL,
    estado ENUM('disponível', 'reservado', 'danificado', 'vendido') DEFAULT 'disponível',
    localizacao VARCHAR(100),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn)
);

CREATE TABLE PEDIDOS (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'processando', 'enviado', 'cancelado') DEFAULT 'pendente',
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
);

CREATE TABLE ITENS_PEDIDO (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    isbn VARCHAR(13) NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn)
);

CREATE TABLE VENDAS (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pagamento VARCHAR(50),
    status_pagamento ENUM('pendente', 'aprovado', 'recusado') DEFAULT 'pendente',
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido)
);

CREATE TABLE ITENS_VENDA (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_exemplar INT NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES VENDAS(id_venda),
    FOREIGN KEY (id_exemplar) REFERENCES EXEMPLARES(id_exemplar)
);

-- Tabelas de relacionamento N:M
CREATE TABLE LIVRO_AUTOR (
    isbn VARCHAR(13) NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (isbn, id_autor),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn),
    FOREIGN KEY (id_autor) REFERENCES AUTORES(id_autor)
);

CREATE TABLE LIVRO_AREA (
    isbn VARCHAR(13) NOT NULL,
    id_area INT NOT NULL,
    PRIMARY KEY (isbn, id_area),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn),
    FOREIGN KEY (id_area) REFERENCES AREAS_CONHECIMENTO(id_area)
);

CREATE TABLE LIVRO_PALAVRA (
    isbn VARCHAR(13) NOT NULL,
    id_palavra INT NOT NULL,
    PRIMARY KEY (isbn, id_palavra),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn),
    FOREIGN KEY (id_palavra) REFERENCES PALAVRAS_CHAVE(id_palavra)
);

-- Adicionando FK pendente em DEPARTAMENTOS
ALTER TABLE DEPARTAMENTOS
ADD FOREIGN KEY (id_responsavel) REFERENCES FUNCIONARIOS(id_funcionario);

-- Índices para otimização
CREATE INDEX idx_livros_titulo ON LIVROS(titulo);
CREATE INDEX idx_autores_nome ON AUTORES(nome);
CREATE INDEX idx_clientes_nome ON CLIENTES(nome);
CREATE INDEX idx_pedidos_data ON PEDIDOS(data_pedido);

-- Views para relatórios e consultas frequentes
CREATE VIEW vw_livros_completos AS
SELECT 
    l.isbn,
    l.titulo,
    l.editora,
    GROUP_CONCAT(DISTINCT a.nome SEPARATOR ', ') AS autores,
    GROUP_CONCAT(DISTINCT ac.descricao SEPARATOR ', ') AS areas,
    GROUP_CONCAT(DISTINCT pc.descricao SEPARATOR ', ') AS palavras_chave
FROM LIVROS l
LEFT JOIN LIVRO_AUTOR la ON l.isbn = la.isbn
LEFT JOIN AUTORES a ON la.id_autor = a.id_autor
LEFT JOIN LIVRO_AREA lc ON l.isbn = lc.isbn
LEFT JOIN AREAS_CONHECIMENTO ac ON lc.id_area = ac.id_area
LEFT JOIN LIVRO_PALAVRA lp ON l.isbn = lp.isbn
LEFT JOIN PALAVRAS_CHAVE pc ON lp.id_palavra = pc.id_palavra
GROUP BY l.isbn;

CREATE VIEW vw_estoque_por_livro AS
SELECT 
    l.isbn,
    l.titulo,
    COUNT(e.id_exemplar) AS total_exemplares,
    SUM(CASE WHEN e.estado = 'disponível' THEN 1 ELSE 0 END) AS disponiveis,
    SUM(CASE WHEN e.estado = 'reservado' THEN 1 ELSE 0 END) AS reservados,
    SUM(CASE WHEN e.estado = 'danificado' THEN 1 ELSE 0 END) AS danificados
FROM LIVROS l
JOIN EXEMPLARES e ON l.isbn = e.isbn
GROUP BY l.isbn;

CREATE VIEW vw_vendas_detalhadas AS
SELECT
    v.id_venda,
    v.data_venda,
    c.nome AS cliente,
    l.titulo AS livro,
    iv.preco_venda,
    e.id_exemplar,
    v.metodo_pagamento,
    v.status_pagamento
FROM VENDAS v
JOIN PEDIDOS p ON v.id_pedido = p.id_pedido
JOIN CLIENTES c ON p.id_cliente = c.id_cliente
JOIN ITENS_VENDA iv ON v.id_venda = iv.id_venda
JOIN EXEMPLARES e ON iv.id_exemplar = e.id_exemplar
JOIN LIVROS l ON e.isbn = l.isbn;

CREATE VIEW vw_autores_obras AS
SELECT
    a.id_autor,
    a.nome,
    COUNT(la.isbn) AS total_livros,
    GROUP_CONCAT(l.titulo SEPARATOR '; ') AS obras
FROM AUTORES a
LEFT JOIN LIVRO_AUTOR la ON a.id_autor = la.id_autor
LEFT JOIN LIVROS l ON la.isbn = l.isbn
GROUP BY a.id_autor;