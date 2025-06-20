USE EditoraLivros;

-- Resgitra automaticamente a venda se caso não seja informada
DELIMITER //
CREATE TRIGGER trg_auto_data_venda
BEFORE INSERT ON vendas
FOR EACH ROW
BEGIN
  IF NEW.data_venda IS NULL THEN
    SET NEW.data_venda = NOW();
  END IF;
END;
// DELIMITER ;

-- Atualiza o estoque reduzindo o numero de livros
DELIMITER //
CREATE TRIGGER trg_atualiza_estoque_venda
AFTER INSERT ON itens_venda
FOR EACH ROW
BEGIN
  UPDATE exemplares
  SET estado = 'VENDIDO'
  WHERE id_exemplar = NEW.id_exemplar;
END;
//
DELIMITER ;

-- Cria um histórico de entrada quando um exemplar é inserido. 
DELIMITER //
CREATE TRIGGER trg_historico_novo_exemplar
AFTER INSERT ON exemplares
FOR EACH ROW
BEGIN
  INSERT INTO historico_exemplar (id_exemplar, estado_anterior, estado_novo, data_alteracao, id_funcionario)
  VALUES (NEW.id_exemplar, NULL, NEW.estado, NOW(), NULL);
END;
//
DELIMITER ;

-- Impede a exclusão de livros com exemplares associados
DELIMITER //
CREATE TRIGGER trg_impede_delete_livro_com_exemplares
BEFORE DELETE ON livros
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM exemplares WHERE isbn = OLD.isbn
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Não é possível excluir um livro com exemplares associados.';
  END IF;
END;
//
DELIMITER ;

-- Impedir duplicação de palavras-chave por livro.
DELIMITER //
CREATE TRIGGER trg_prevent_palavra_duplicada
BEFORE INSERT ON livro_palavra
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM livro_palavra
    WHERE isbn = NEW.isbn AND id_palavra = NEW.id_palavra
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Este livro já possui essa palavra-chave.';
  END IF;
END;
//
DELIMITER ;

-- Atualizar status do pedido automaticamente
DELIMITER //
CREATE TRIGGER trg_status_pedido_em_processamento
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
  UPDATE pedidos
  SET status = 'EM PROCESSAMENTO'
  WHERE id_pedido = NEW.id_pedido
    AND status = 'ABERTO';
END;
//
DELIMITER ;

-- Atualizar automaticamente a data quando um livro quando um for inserido
DELIMITER //
CREATE TRIGGER trg_atualiza_data_livro
AFTER INSERT ON exemplares
FOR EACH ROW
BEGIN
UPDATE livros
  SET dt_atualizacao = NOW()
  WHERE isbn = NEW.isbn;
END;
//
DELIMITER ;