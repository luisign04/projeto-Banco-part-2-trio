USE EditoraLivros;

-- DROP DE PROCEDURES EXISTENTES
DROP PROCEDURE IF EXISTS sp_cadastrar_cliente;
DROP PROCEDURE IF EXISTS sp_atualizar_livro;
DROP PROCEDURE IF EXISTS sp_relatorio_cliente;
DROP PROCEDURE IF EXISTS sp_registrar_alteracao_exemplar;
DROP PROCEDURE IF EXISTS sp_registrar_venda;
DROP PROCEDURE IF EXISTS sp_excluir_cliente;

DELIMITER //

-- 1. Cadastrar novo cliente com endereço
CREATE PROCEDURE sp_cadastrar_cliente(
    IN nome_cli VARCHAR(100),
    IN contato_cli VARCHAR(100),
    IN telefone_cli VARCHAR(20),
    IN endereco_cli VARCHAR(255),
    IN cidade_cli VARCHAR(100),
    IN cep_cli VARCHAR(20)
)
BEGIN
    DECLARE novo_id INT;

    INSERT INTO CLIENTES (nome, contato, telefone)
    VALUES (nome_cli, contato_cli, telefone_cli);

    SET novo_id = LAST_INSERT_ID();

    INSERT INTO CLIENTE_ENDERECOS (id_cliente, tipo, endereco, cidade, cep)
    VALUES (novo_id, 'entrega', endereco_cli, cidade_cli, cep_cli);

    SELECT * FROM CLIENTES WHERE id_cliente = novo_id;
    SELECT * FROM CLIENTE_ENDERECOS WHERE id_cliente = novo_id;
END;
//

-- 2. Atualizar preço e estado de um livro
CREATE PROCEDURE sp_atualizar_livro(
    IN p_isbn VARCHAR(13),
    IN novo_preco DECIMAL(10,2),
    IN novo_estado ENUM('disponível', 'reservado', 'danificado', 'vendido'),
    IN nova_localizacao VARCHAR(100)
)
BEGIN
    UPDATE LIVROS
    SET preco_sugerido = novo_preco
    WHERE isbn = p_isbn;

    UPDATE EXEMPLARES
    SET estado = novo_estado,
        localizacao = nova_localizacao
    WHERE isbn = p_isbn;

    SELECT * FROM LIVROS WHERE isbn = p_isbn;
    SELECT * FROM EXEMPLARES WHERE isbn = p_isbn;
END;
//

-- 3. Relatório de dados de um cliente
CREATE PROCEDURE sp_relatorio_cliente(
    IN id_cliente_in INT
)
BEGIN
    SELECT * FROM CLIENTES WHERE id_cliente = id_cliente_in;
    SELECT * FROM CLIENTE_ENDERECOS WHERE id_cliente = id_cliente_in;
    SELECT p.*, v.*
    FROM PEDIDOS p
    LEFT JOIN VENDAS v ON p.id_pedido = v.id_pedido
    WHERE p.id_cliente = id_cliente_in;
    SELECT ip.*, l.titulo
    FROM PEDIDOS p
    JOIN ITENS_PEDIDO ip ON p.id_pedido = ip.id_pedido
    JOIN LIVROS l ON ip.isbn = l.isbn
    WHERE p.id_cliente = id_cliente_in;
END;
//

-- 4. Registrar histórico de alteração de exemplar
CREATE PROCEDURE sp_registrar_alteracao_exemplar(
    IN id_exemplar_in INT,
    IN estado_novo_in ENUM('disponível', 'reservado', 'danificado', 'vendido'),
    IN id_funcionario_in INT
)
BEGIN
    DECLARE estado_ant ENUM('disponível', 'reservado', 'danificado', 'vendido');

    SELECT estado INTO estado_ant
    FROM EXEMPLARES
    WHERE id_exemplar = id_exemplar_in;

    UPDATE EXEMPLARES
    SET estado = estado_novo_in
    WHERE id_exemplar = id_exemplar_in;

    INSERT INTO HISTORICO_EXEMPLARES (
        id_exemplar, estado_anterior, estado_novo, id_funcionario
    ) VALUES (
        id_exemplar_in, estado_ant, estado_novo_in, id_funcionario_in
    );

    SELECT * FROM HISTORICO_EXEMPLARES
    WHERE id_exemplar = id_exemplar_in
    ORDER BY data_alteracao DESC;
END;
//

-- 5. Registrar nova venda com item
CREATE PROCEDURE sp_registrar_venda(
    IN id_pedido_in INT,
    IN id_exemplar_in INT,
    IN preco_venda_in DECIMAL(10,2),
    IN metodo_pagamento_in VARCHAR(50)
)
BEGIN
    DECLARE nova_venda_id INT;

    INSERT INTO VENDAS (id_pedido, metodo_pagamento, status_pagamento)
    VALUES (id_pedido_in, metodo_pagamento_in, 'pendente');

    SET nova_venda_id = LAST_INSERT_ID();

    INSERT INTO ITENS_VENDA (id_venda, id_exemplar, preco_venda)
    VALUES (nova_venda_id, id_exemplar_in, preco_venda_in);

    SELECT * FROM VENDAS WHERE id_venda = nova_venda_id;
    SELECT * FROM ITENS_VENDA WHERE id_venda = nova_venda_id;
END;
//

-- 6. Excluir cliente e dados associados
CREATE PROCEDURE sp_excluir_cliente(
    IN id_cliente_in INT
)
BEGIN
    DELETE FROM AVALIACOES WHERE id_cliente = id_cliente_in;
    DELETE FROM CLIENTE_ENDERECOS WHERE id_cliente = id_cliente_in;
    DELETE FROM PEDIDOS WHERE id_cliente = id_cliente_in;
    DELETE FROM CLIENTES WHERE id_cliente = id_cliente_in;

    SELECT CONCAT('Cliente ', id_cliente_in, ' excluído com sucesso.') AS resultado;
END;
//

-- RESTAURA DELIMITER PADRÃO
DELIMITER ;

-- ============================
-- TESTES DAS PROCEDURES
-- ============================

-- 1. Cadastrar cliente
CALL sp_cadastrar_cliente(
    'Cliente Teste',
    'Sr. Testador',
    '(11) 91234-5678',
    'Rua do Teste, 123',
    'São Paulo',
    '01000-000'
);

-- 2. Atualizar livro
CALL sp_atualizar_livro('9788535901234', 99.90, 'reservado', 'Estante Z - Bloco 9');

-- 3. Relatório de cliente
CALL sp_relatorio_cliente(1);

-- 4. Alteração de exemplar
CALL sp_registrar_alteracao_exemplar(1, 'danificado', 2);

-- 5. Registrar venda
CALL sp_registrar_venda(3, 3, 39.90, 'PIX');

-- 6. Excluir cliente (ajuste ID conforme necessário)
CALL sp_excluir_cliente(11);
