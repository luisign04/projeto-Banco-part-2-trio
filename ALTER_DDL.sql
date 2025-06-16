USE `mydb`;

-- 1. Adicionar preço aos livros
ALTER TABLE Livros
ADD COLUMN preco DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER descricao;

-- 2. Ajustar formato do CPF/CNPJ
ALTER TABLE Clientes
MODIFY COLUMN CPF_CNPJ VARCHAR(14) NOT NULL;

-- 3. Adicionar data de contratação de funcionários
ALTER TABLE Funcionarios
ADD COLUMN data_contratacao DATE NOT NULL DEFAULT (CURRENT_DATE) AFTER cargo;

-- 4. Renomear coluna de número de série
ALTER TABLE Pedidos_Vendas
RENAME COLUMN exemplar_serie TO exemplar_numero_serie;

-- 5. Garantir ISBN único
ALTER TABLE Livros
ADD UNIQUE INDEX uq_livros_isbn (isbn ASC);

-- 6. Ampliar tamanho do título dos livros
ALTER TABLE Livros
MODIFY COLUMN titulo VARCHAR(255) NOT NULL;

-- 7. Adicionar status de funcionário
ALTER TABLE Funcionarios
ADD COLUMN status ENUM('ativo', 'inativo', 'ferias') NOT NULL DEFAULT 'ativo' AFTER telefone;

-- 8. Adicionar data de cadastro do cliente
ALTER TABLE Clientes
ADD COLUMN data_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER cliente_email;

-- 9. Expandir estados de exemplares
ALTER TABLE Exemplares
MODIFY COLUMN estado ENUM('disponivel', 'reservado', 'vendido', 'danificado', 'perdido') NOT NULL DEFAULT 'disponivel';

-- 10. Correção da estrutura de Departamentos (usando abordagem compatível)
SET @colname = 'responsavel';
SET @prepstmt = (SELECT IF(
    EXISTS(
        SELECT * FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = 'mydb' 
        AND TABLE_NAME = 'Departamentos' 
        AND COLUMN_NAME = @colname
    ),
    CONCAT('ALTER TABLE Departamentos DROP COLUMN ', @colname),
    'SELECT 1'
));
PREPARE stmt FROM @prepstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE Departamentos 
ADD COLUMN id_responsavel INT NULL,
ADD CONSTRAINT fk_departamentos_responsavel
    FOREIGN KEY (id_responsavel)
    REFERENCES Funcionarios(idFuncionario)
    ON DELETE SET NULL
    ON UPDATE CASCADE;