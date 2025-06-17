USE EditoraLivros;

-- Desativar modo de atualização segura
SET SQL_SAFE_UPDATES = 0;

-- 1. Atualizar preço de um livro
UPDATE LIVROS 
SET preco_sugerido = 49.90 
WHERE isbn = '9788535932500';  -- Usando ISBN único

-- 2. Promover funcionário (corrigido usando ID)
UPDATE FUNCIONARIOS 
SET cargo = 'Gerente Editorial' 
WHERE id_funcionario = 1;  -- Carlos Silva tem ID 1

-- 3. Reclassificar livro para nova área (corrigido)
UPDATE LIVRO_AREA 
SET id_area = (SELECT id_area FROM AREAS_CONHECIMENTO WHERE descricao = 'Filosofia') 
WHERE isbn = (SELECT isbn FROM LIVROS WHERE titulo = 'A Arte da Guerra');

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
WHERE id_venda = 2;  -- Usando ID da venda

-- 7. Corrigir nacionalidade de autor
UPDATE AUTORES 
SET nacionalidade = 'Brasileira' 
WHERE id_autor = 1;  -- Clarice Lispector tem ID 1

-- 8. Atualizar endereço de cliente
UPDATE CLIENTE_ENDERECOS 
SET endereco = 'Av. Paulista, 1500 - SP' 
WHERE id_endereco = 1;  -- Usando ID do endereço

-- 9. Reagendar evento
UPDATE EVENTOS 
SET data_evento = '2023-10-05 18:00:00' 
WHERE id_evento = 10;  -- Usando ID do evento

-- 10. Atualizar avaliação de livro
UPDATE AVALIACOES 
SET nota = 5, comentario = 'Excelente, superou expectativas' 
WHERE id_avaliacao = 3;

-- 11. Atualizar fornecedor principal (corrigido)
UPDATE EXEMPLARES 
SET id_fornecedor = (SELECT id_fornecedor FROM FORNECEDORES WHERE nome = 'Gráfica Express') 
WHERE id_exemplar IN (1,2,3);  -- Especificando IDs

-- 12. Atualizar descrição de departamento
UPDATE DEPARTAMENTOS 
SET descricao = 'Gestão de talentos e desenvolvimento organizacional' 
WHERE id_departamento = 5;  -- RH tem ID 5

-- 13. Remover livro danificado
DELETE FROM EXEMPLARES 
WHERE id_exemplar = 7;  -- Exemplar danificado específico

-- 14. Remover avaliação inapropriada
DELETE FROM AVALIACOES 
WHERE id_avaliacao = 5;  -- Avaliação específica

-- 15. Excluir evento cancelado
DELETE FROM EVENTOS 
WHERE id_evento = 10;

-- 16. Remover palavra-chave não utilizada (execução segura)
DELETE FROM PALAVRAS_CHAVE 
WHERE id_palavra NOT IN (SELECT DISTINCT id_palavra FROM LIVRO_PALAVRA)
AND id_palavra > 10;  -- Não remove palavras-chave originais

-- 17. Excluir fornecedor inativo
DELETE FROM FORNECEDORES 
WHERE id_fornecedor = 10;  -- Fornecedor específico

-- 18. Remover histórico antigo
DELETE FROM HISTORICO_EXEMPLARES 
WHERE id_historico IN (1,2,3);  -- Históricos específicos

-- 19. Excluir cliente inativo
DELETE FROM CLIENTES 
WHERE id_cliente = 10;  -- Cliente específico

-- 20. Atualizar data de publicação de livro
UPDATE LIVROS 
SET data_publicacao = '2023-01-01' 
WHERE isbn = '9788575422920';  -- Arte da Guerra

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
WHERE id_autor = 9;  -- Sun Tzu

-- Reativar modo de atualização segura
SET SQL_SAFE_UPDATES = 1;