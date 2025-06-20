USE EditoraLivros;

-- 1. Calcula valor líquido de um item com desconto
DELIMITER //
CREATE FUNCTION fn_calcular_valor_liquido(
    preco_unitario DECIMAL(10,2),
    desconto DECIMAL(5,2),
    quantidade INT
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN preco_unitario * (1 - desconto) * quantidade;
END;
//
DELIMITER ;

-- 2. Verifica disponibilidade de um livro
DELIMITER //
CREATE FUNCTION fn_livro_disponivel(
    p_isbn VARCHAR(13)
) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM EXEMPLARES 
        WHERE isbn = p_isbn 
        AND estado = 'disponível'
    );
END;
//
DELIMITER ;

-- 3. Calcula idade do autor
DELIMITER //
CREATE FUNCTION fn_calcular_idade_autor(
    p_id_autor INT
) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE data_nasc DATE;
    DECLARE idade INT;
    
    SELECT data_nascimento INTO data_nasc
    FROM AUTORES 
    WHERE id_autor = p_id_autor;
    
    IF data_nasc IS NULL THEN
        RETURN NULL;
    END IF;
    
    SET idade = TIMESTAMPDIFF(YEAR, data_nasc, CURDATE());
    RETURN idade;
END;
//
DELIMITER ;

-- 4. Classifica livro por popularidade
DELIMITER //
CREATE FUNCTION fn_classificar_popularidade(
    p_isbn VARCHAR(13)
) 
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE qtd_avaliacoes INT;
    DECLARE media_avaliacao DECIMAL(3,2);
    
    SELECT 
        COUNT(*),
        AVG(nota) 
    INTO qtd_avaliacoes, media_avaliacao
    FROM AVALIACOES
    WHERE isbn = p_isbn;
    
    RETURN CASE
        WHEN qtd_avaliacoes >= 50 AND media_avaliacao >= 4.5 THEN 'Best-seller'
        WHEN qtd_avaliacoes >= 20 AND media_avaliacao >= 4.0 THEN 'Popular'
        WHEN qtd_avaliacoes >= 5 THEN 'Médio'
        ELSE 'Baixo'
    END;
END;
//
DELIMITER ;

-- 5. Formata preço para exibição
DELIMITER //
CREATE FUNCTION fn_formatar_preco(
    preco DECIMAL(10,2)
) 
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    RETURN CONCAT('R$ ', FORMAT(preco, 2, 'pt_BR'));
END;
//
DELIMITER ;

-- 6. Calcula dias desde publicação
DELIMITER //
CREATE FUNCTION fn_dias_desde_publicacao(
    p_isbn VARCHAR(13)
) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE data_pub DATE;
    
    SELECT data_publicacao INTO data_pub
    FROM LIVROS 
    WHERE isbn = p_isbn;
    
    IF data_pub IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN DATEDIFF(CURDATE(), data_pub);
END;
//
DELIMITER ;

-- Calcular valor líquido de um pedido
SELECT 
    fn_calcular_valor_liquido(50.00, 0.10, 5) AS total_liquido;
-- Retorno: 225.00

-- Verificar disponibilidade de livro
SELECT fn_livro_disponivel('9788535932500') AS disponivel;

-- Calcular idade de autor
SELECT fn_calcular_idade_autor(1) AS idade_autor;

-- Classificar popularidade
SELECT fn_classificar_popularidade('9788532530663') AS popularidade;

-- Formatar preço
SELECT fn_formatar_preco(49.9) AS preco_formatado;
-- Retorno: "R$ 49,90"

-- Calcular dias desde publicação
SELECT fn_dias_desde_publicacao('9788535901234') AS dias_publicacao;