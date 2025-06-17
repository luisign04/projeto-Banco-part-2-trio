USE EditoraLivros;

-- 1. Livros e seus autores
SELECT l.titulo, a.nome AS autor, e.nome AS editora
FROM LIVROS l
JOIN LIVRO_AUTOR la ON l.isbn = la.isbn
JOIN AUTORES a ON la.id_autor = a.id_autor
JOIN EDITORAS e ON l.id_editora = e.id_editora;

-- 2. Total de vendas por livro
SELECT l.titulo, SUM(ip.quantidade) AS total_vendido
FROM LIVROS l
JOIN ITENS_PEDIDO ip ON l.isbn = ip.isbn
GROUP BY l.isbn
ORDER BY total_vendido DESC;

-- 3. Pedidos pendentes com mais de 30 dias
SELECT p.id_pedido, c.nome AS cliente, DATEDIFF(CURDATE(), p.data_pedido) AS dias_atraso
FROM PEDIDOS p
JOIN CLIENTES c ON p.id_cliente = c.id_cliente
WHERE p.status = 'pendente'
AND DATEDIFF(CURDATE(), p.data_pedido) > 30;

-- 4. Média de avaliações por editora
SELECT e.nome, AVG(a.nota) AS media_avaliacoes
FROM EDITORAS e
JOIN LIVROS l ON e.id_editora = l.id_editora
JOIN AVALIACOES a ON l.isbn = a.isbn
GROUP BY e.id_editora
ORDER BY media_avaliacoes DESC;

-- 5. Histórico completo de um exemplar
SELECT e.id_exemplar, l.titulo, 
       he.estado_anterior, he.estado_novo, he.data_alteracao, f.nome AS funcionario
FROM EXEMPLARES e
JOIN LIVROS l ON e.isbn = l.isbn
JOIN HISTORICO_EXEMPLARES he ON e.id_exemplar = he.id_exemplar
JOIN FUNCIONARIOS f ON he.id_funcionario = f.id_funcionario
WHERE e.id_exemplar = 1;

-- 6. Clientes com maior valor em compras
SELECT c.nome, SUM(ip.quantidade * ip.preco_unitario * (1 - ip.desconto)) AS total_gasto
FROM CLIENTES c
JOIN PEDIDOS p ON c.id_cliente = p.id_cliente
JOIN ITENS_PEDIDO ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente
ORDER BY total_gasto DESC
LIMIT 5;

-- 7. Palavras-chave mais utilizadas por gênero
SELECT l.genero, p.descricao AS palavra_chave, COUNT(*) AS utilizacoes
FROM LIVROS l
JOIN LIVRO_PALAVRA lp ON l.isbn = lp.isbn
JOIN PALAVRAS_CHAVE p ON lp.id_palavra = p.id_palavra
GROUP BY l.genero, p.id_palavra
ORDER BY utilizacoes DESC;

-- 8. Funcionários por departamento com seus gerentes
SELECT d.nome AS departamento, f.nome AS funcionario, g.nome AS gerente
FROM DEPARTAMENTOS d
JOIN FUNCIONARIOS f ON d.id_departamento = f.id_departamento
JOIN FUNCIONARIOS g ON d.id_responsavel = g.id_funcionario;

-- 9. Livros com estoque crítico
SELECT l.titulo, COUNT(e.id_exemplar) AS qtd_disponivel
FROM LIVROS l
JOIN EXEMPLARES e ON l.isbn = e.isbn
WHERE e.estado = 'disponível'
GROUP BY l.isbn
HAVING qtd_disponivel < 3;

-- 10. Vendas por método de pagamento
SELECT v.metodo_pagamento, COUNT(*) AS total_vendas, SUM(iv.preco_venda) AS valor_total
FROM VENDAS v
JOIN ITENS_VENDA iv ON v.id_venda = iv.id_venda
GROUP BY v.metodo_pagamento;

-- 11. Autores e suas áreas de atuação
SELECT a.nome AS autor, ac.descricao AS area, COUNT(DISTINCT l.isbn) AS qtd_livros
FROM AUTORES a
JOIN LIVRO_AUTOR la ON a.id_autor = la.id_autor
JOIN LIVROS l ON la.isbn = l.isbn
JOIN LIVRO_AREA lc ON l.isbn = lc.isbn
JOIN AREAS_CONHECIMENTO ac ON lc.id_area = ac.id_area
GROUP BY a.id_autor, ac.id_area;

-- 12. Livros nunca avaliados
SELECT l.titulo, e.nome AS editora
FROM LIVROS l
JOIN EDITORAS e ON l.id_editora = e.id_editora
LEFT JOIN AVALIACOES a ON l.isbn = a.isbn
WHERE a.id_avaliacao IS NULL;

-- 13. Relação completa livro-área-palavra-chave
SELECT l.titulo, 
       GROUP_CONCAT(DISTINCT ac.descricao SEPARATOR ', ') AS areas,
       GROUP_CONCAT(DISTINCT pc.descricao SEPARATOR ', ') AS palavras_chave
FROM LIVROS l
JOIN LIVRO_AREA la ON l.isbn = la.isbn
JOIN AREAS_CONHECIMENTO ac ON la.id_area = ac.id_area
JOIN LIVRO_PALAVRA lp ON l.isbn = lp.isbn
JOIN PALAVRAS_CHAVE pc ON lp.id_palavra = pc.id_palavra
GROUP BY l.isbn;

-- 14. Fornecedores e seus exemplares
SELECT f.nome AS fornecedor, 
       l.titulo, 
       COUNT(e.id_exemplar) AS total_fornecido,
       SUM(CASE WHEN e.estado = 'disponível' THEN 1 ELSE 0 END) AS disponiveis
FROM FORNECEDORES f
JOIN EXEMPLARES e ON f.id_fornecedor = e.id_fornecedor
JOIN LIVROS l ON e.isbn = l.isbn
GROUP BY f.id_fornecedor, l.isbn;

-- 15. Clientes com múltiplos endereços
SELECT c.nome, COUNT(ce.id_endereco) AS qtd_enderecos
FROM CLIENTES c
JOIN CLIENTE_ENDERECOS ce ON c.id_cliente = ce.id_cliente
GROUP BY c.id_cliente
HAVING qtd_enderecos > 1;

-- 16. Livros com maior margem de lucro
SELECT l.titulo,
       l.preco_sugerido,
       l.custo_producao,
       (l.preco_sugerido - l.custo_producao) AS lucro_unitario,
       SUM(ip.quantidade) AS vendidos,
       (l.preco_sugerido - l.custo_producao) * SUM(ip.quantidade) AS lucro_total
FROM LIVROS l
JOIN ITENS_PEDIDO ip ON l.isbn = ip.isbn
GROUP BY l.isbn
ORDER BY lucro_total DESC;

-- 17. Eventos por localização
SELECT localizacao, 
       COUNT(*) AS total_eventos,
       GROUP_CONCAT(tipo SEPARATOR '; ') AS tipos
FROM EVENTOS
GROUP BY localizacao;

-- 18. Relatório completo de um pedido
SELECT p.id_pedido, c.nome AS cliente, p.data_pedido, p.status,
       l.titulo, ip.quantidade, ip.preco_unitario, ip.desconto
FROM PEDIDOS p
JOIN CLIENTES c ON p.id_cliente = c.id_cliente
JOIN ITENS_PEDIDO ip ON p.id_pedido = ip.id_pedido
JOIN LIVROS l ON ip.isbn = l.isbn
WHERE p.id_pedido = 1;

-- 19.1 Livros melhor avaliados com detalhes completos
SELECT 
    l.titulo,
    e.nome AS editora,
    ROUND(AVG(a.nota), 2) AS media_avaliacao,
    COUNT(a.id_avaliacao) AS total_avaliacoes,
    GROUP_CONCAT(DISTINCT ar.nome SEPARATOR ', ') AS autores,
    GROUP_CONCAT(DISTINCT ac.descricao SEPARATOR '; ') AS areas
FROM LIVROS l
JOIN AVALIACOES a ON l.isbn = a.isbn
JOIN EDITORAS e ON l.id_editora = e.id_editora
JOIN LIVRO_AUTOR la ON l.isbn = la.isbn
JOIN AUTORES ar ON la.id_autor = ar.id_autor
JOIN LIVRO_AREA lc ON l.isbn = lc.isbn
JOIN AREAS_CONHECIMENTO ac ON lc.id_area = ac.id_area
GROUP BY l.isbn
HAVING media_avaliacao >= 4
ORDER BY media_avaliacao DESC, total_avaliacoes DESC;

-- 20. Análise de rentabilidade por área de conhecimento
SELECT ac.descricao AS area_conhecimento,
       COUNT(DISTINCT l.isbn) AS total_livros,
       SUM(ip.quantidade) AS exemplares_vendidos,
       SUM(ip.quantidade * ip.preco_unitario * (1 - ip.desconto)) AS receita_total,
       SUM(ip.quantidade * l.custo_producao) AS custo_total,
       SUM(ip.quantidade * (ip.preco_unitario * (1 - ip.desconto) - l.custo_producao)) AS lucro_total
FROM AREAS_CONHECIMENTO ac
JOIN LIVRO_AREA lc ON ac.id_area = lc.id_area
JOIN LIVROS l ON lc.isbn = l.isbn
JOIN ITENS_PEDIDO ip ON l.isbn = ip.isbn
GROUP BY ac.id_area
ORDER BY lucro_total DESC;