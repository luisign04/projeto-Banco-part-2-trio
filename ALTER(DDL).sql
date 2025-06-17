USE EditoraLivros;

-- 1. Adicionar email em AUTORES
ALTER TABLE AUTORES
ADD COLUMN email VARCHAR(100) AFTER nome;

-- 2. Modificar tamanho da editora e adicionar índice
ALTER TABLE LIVROS
MODIFY COLUMN editora VARCHAR(150),
ADD INDEX idx_editora (editora);

-- 3. Adicionar edição e revisão em LIVROS
ALTER TABLE LIVROS
ADD COLUMN edicao TINYINT UNSIGNED DEFAULT 1,
ADD COLUMN revisao TINYINT UNSIGNED DEFAULT 0;

-- 4. Criar tabela de FORNECEDORES
CREATE TABLE FORNECEDORES (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100),
    endereco VARCHAR(255)
);

-- 5. Adicionar fornecedor em EXEMPLARES
ALTER TABLE EXEMPLARES
ADD COLUMN id_fornecedor INT,
ADD FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDORES(id_fornecedor);

-- 6. Adicionar preços em LIVROS
ALTER TABLE LIVROS
ADD COLUMN preco_sugerido DECIMAL(10,2),
ADD COLUMN custo_producao DECIMAL(10,2);

-- 7. Adicionar desconto em ITENS_PEDIDO
ALTER TABLE ITENS_PEDIDO
ADD COLUMN desconto DECIMAL(5,2) DEFAULT 0.00;

-- 8. Normalizar EDITORAS
CREATE TABLE EDITORAS (
    id_editora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cidade VARCHAR(50),
    pais VARCHAR(50)
);

INSERT INTO EDITORAS (nome)
SELECT DISTINCT editora FROM LIVROS;

ALTER TABLE LIVROS
ADD COLUMN id_editora INT AFTER editora;

UPDATE LIVROS L
JOIN EDITORAS E ON L.editora = E.nome
SET L.id_editora = E.id_editora;

ALTER TABLE LIVROS
ADD FOREIGN KEY (id_editora) REFERENCES EDITORAS(id_editora),
DROP COLUMN editora;

-- 9. Criar histórico de EXEMPLARES
CREATE TABLE HISTORICO_EXEMPLARES (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_exemplar INT NOT NULL,
    estado_anterior ENUM('disponível', 'reservado', 'danificado', 'vendido'),
    estado_novo ENUM('disponível', 'reservado', 'danificado', 'vendido'),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_funcionario INT,
    FOREIGN KEY (id_exemplar) REFERENCES EXEMPLARES(id_exemplar),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIOS(id_funcionario)
);

-- 10. Adicionar índices nas tabelas de relacionamento
ALTER TABLE LIVRO_AUTOR
ADD INDEX idx_autor (id_autor);

ALTER TABLE LIVRO_AREA
ADD INDEX idx_area (id_area);

ALTER TABLE LIVRO_PALAVRA
ADD INDEX idx_palavra (id_palavra);

-- 11. Criar tabela de EVENTOS e LIVRO_EVENTO
CREATE TABLE EVENTOS (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('lançamento', 'sessão_autógrafos', 'feira_livros') NOT NULL,
    data_evento DATETIME,
    localizacao VARCHAR(200),
    descricao TEXT
);

CREATE TABLE LIVRO_EVENTO (
    id_evento INT,
    isbn VARCHAR(13),
    PRIMARY KEY (id_evento, isbn),
    FOREIGN KEY (id_evento) REFERENCES EVENTOS(id_evento),
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn)
);

-- 12. Adicionar metadados de auditoria (apenas nas tabelas que ainda não têm)
ALTER TABLE LIVROS
ADD COLUMN dt_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN dt_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE PEDIDOS
ADD COLUMN dt_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN dt_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 13. Criar tabela de endereços de clientes e migrar
CREATE TABLE CLIENTE_ENDERECOS (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo ENUM('cobrança', 'entrega') DEFAULT 'entrega',
    endereco VARCHAR(255) NOT NULL,
    cidade VARCHAR(100),
    cep VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
);

-- Migrar endereços existentes
INSERT INTO CLIENTE_ENDERECOS (id_cliente, tipo, endereco)
SELECT id_cliente, 'entrega', endereco FROM CLIENTES;

ALTER TABLE CLIENTES
DROP COLUMN endereco;

-- Adicionar coluna telefone na tabela CLIENTES
ALTER TABLE CLIENTES ADD COLUMN telefone VARCHAR(20) AFTER contato;

-- 14. Adicionar sistema de avaliações
ALTER TABLE LIVROS
ADD COLUMN avaliacao_media DECIMAL(3,2) DEFAULT 0.00,
ADD COLUMN total_avaliacoes INT DEFAULT 0;

CREATE TABLE AVALIACOES (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL,
    id_cliente INT NOT NULL,
    nota TINYINT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (isbn) REFERENCES LIVROS(isbn),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
);