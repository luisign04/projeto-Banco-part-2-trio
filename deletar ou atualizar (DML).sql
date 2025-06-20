USE EditoraLivros;

-- Desativar verificações temporariamente
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Atualizar preço de um livro
UPDATE LIVROS 
SET preco_sugerido = 49.90 
WHERE isbn = '9788535932500';

-- 2. Promover funcionário
UPDATE FUNCIONARIOS 
SET cargo = 'Gerente Editorial' 
WHERE id_funcionario = 1;

-- 3. Reclassificar livro para nova área
SET @filosofia_id := (SELECT id_area FROM AREAS_CONHECIMENTO WHERE descricao = 'Filosofia');

UPDATE LIVRO_AREA
SET id_area = @filosofia_id
WHERE isbn = (SELECT isbn FROM LIVROS WHERE titulo = 'A Arte da Guerra')
AND @filosofia_id IS NOT NULL;

-- 4. Atualizar estado de exemplar
UPDATE EXEMPLARES 
SET estado = 'reservado' 
WHERE id_exemplar = 1;

-- 5. Aplicar desconto em pedido
UPDATE ITENS_PEDIDO 
SET desconto = 0.15 
WHERE id_pedido = 2;

-- 6. Atualizar status de pagamento
UPDATE VENDAS 
SET status_pagamento = 'aprovado' 
WHERE id_venda = 2;

-- 7. Corrigir nacionalidade de autor
UPDATE AUTORES 
SET nacionalidade = 'Brasileira' 
WHERE id_autor = 1;

-- 8. Atualizar endereço de cliente
UPDATE CLIENTE_ENDERECOS 
SET endereco = 'Av. Paulista, 1500 - SP' 
WHERE id_endereco = 1;

-- 9. Reagendar evento
UPDATE EVENTOS 
SET data_evento = '2023-10-05 18:00:00' 
WHERE id_evento = 10;

-- 10. Atualizar avaliação de livro
UPDATE AVALIACOES 
SET nota = 5, comentario = 'Excelente, superou expectativas' 
WHERE id_avaliacao = 3;

-- 11. Atualizar fornecedor principal
SET @grafica_id := (SELECT id_fornecedor FROM FORNECEDORES WHERE nome = 'Gráfica Express');

UPDATE EXEMPLARES 
SET id_fornecedor = @grafica_id
WHERE id_exemplar IN (1,2,3) 
AND @grafica_id IS NOT NULL;

-- 12. Atualizar descrição de departamento
UPDATE DEPARTAMENTOS 
SET descricao = 'Gestão de talentos e desenvolvimento organizacional' 
WHERE id_departamento = 5;

-- 13. Remover livro danificado
DELETE FROM HISTORICO_EXEMPLARES WHERE id_exemplar = 7;
DELETE FROM EXEMPLARES WHERE id_exemplar = 7;

-- 14. Remover avaliação inapropriada
DELETE FROM AVALIACOES WHERE id_avaliacao = 5;

-- 15. Excluir evento cancelado
DELETE FROM EVENTOS WHERE id_evento = 10;

-- 16. Remover palavra-chave não utilizada
DELETE FROM PALAVRAS_CHAVE 
WHERE id_palavra NOT IN (SELECT DISTINCT id_palavra FROM LIVRO_PALAVRA)
AND id_palavra > 10;

-- 17. Excluir fornecedor inativo
UPDATE EXEMPLARES SET id_fornecedor = NULL WHERE id_fornecedor = 10;
DELETE FROM FORNECEDORES WHERE id_fornecedor = 10;

-- 18. Remover histórico antigo
DELETE FROM HISTORICO_EXEMPLARES WHERE id_historico IN (1,2,3);

-- 19. Excluir cliente inativo (CORREÇÃO: removidas referências a VENDAS)
DELETE FROM CLIENTE_ENDERECOS WHERE id_cliente = 10;
DELETE FROM AVALIACOES WHERE id_cliente = 10;
-- Se existir tabela PEDIDOS relacionada:
-- DELETE FROM PEDIDOS WHERE id_cliente = 10;
DELETE FROM CLIENTES WHERE id_cliente = 10;

-- 20. Atualizar data de publicação de livro
UPDATE LIVROS 
SET data_publicacao = '2023-01-01' 
WHERE isbn = '9788575422920';

-- 21. Remover relacionamento livro-palavra
DELETE FROM LIVRO_PALAVRA 
WHERE isbn = '9788535901234' AND id_palavra = 4;

-- 22. Atualizar cargo de funcionário
UPDATE FUNCIONARIOS 
SET cargo = 'Analista Sênior' 
WHERE id_funcionario = 5;

-- 23. Excluir item de pedido
DELETE FROM ITENS_PEDIDO 
WHERE id_item = 10;

-- 24. Atualizar método de pagamento
UPDATE VENDAS 
SET metodo_pagamento = 'PIX' 
WHERE id_venda = 5;

-- 25. Remover autor sem livros
DELETE FROM AUTORES 
WHERE id_autor = 9
AND NOT EXISTS (SELECT 1 FROM LIVROS WHERE id_autor = 9);

-- Reativar verificações de segurança
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;