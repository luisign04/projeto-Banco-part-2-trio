use mydb;

use mydb;

DROP VIEW IF EXISTS vw_livros_com_detalhes;
CREATE VIEW vw_livros_com_detalhes AS
SELECT 
    l.isbn,
    l.titulo,
    l.editora,
    l.data_publicacao,
    l.genero,
    l.num_paginas,
    a.nome AS autor,
    a.nacionalidade,
    ac.descricao AS area_conhecimento
FROM Livros l
LEFT JOIN Autores a ON l.autor_id = a.idAutor
LEFT JOIN Areas_Conhecimento ac ON l.area_conhecimento_id = ac.id_AreasConhecimento;

DROP VIEW IF EXISTS vw_pedidos_completo;
CREATE VIEW vw_pedidos_completo AS
SELECT 
    pv.idPedidoVenda,
    pv.data_transacao,
    pv.status_pedido,
    c.cliente_nome,
    c.CPF_CNPJ,
    c.sexo,
    c.cliente_telefone,
    ce.UF AS cliente_UF,
    ce.cidade AS cliente_cidade,
    e.numero_serie,
    l.titulo AS livro_titulo,
    l.isbn
FROM Pedidos_Vendas pv
JOIN Clientes c ON pv.cliente_id = c.cliente_id
JOIN Clientes_Endereco ce ON c.cliente_id = ce.cliente_id
JOIN Exemplares e ON pv.exemplar_serie = e.numero_serie
JOIN Livros l ON e.isbn = l.isbn;

DROP VIEW IF EXISTS vw_estoque_exemplares;
CREATE VIEW vw_estoque_exemplares AS
SELECT
    e.numero_serie,
    e.estado,
    e.localizacao,
    l.titulo,
    l.editora,
    l.data_publicacao,
    l.genero,
    a.nome AS autor,
    ac.descricao AS area_conhecimento
FROM Exemplares e
JOIN Livros l ON e.isbn = l.isbn
LEFT JOIN Autores a ON l.autor_id = a.idAutor
LEFT JOIN Areas_Conhecimento ac ON l.area_conhecimento_id = ac.id_AreasConhecimento;

DROP VIEW IF EXISTS vw_funcionarios_completo;
CREATE VIEW vw_funcionarios_completo AS
SELECT
    f.idFuncionario,
    f.nome,
    f.cargo,
    f.telefone,
    d.nome AS departamento,
    fe.UF,
    fe.cidade,
    fe.bairro,
    fe.rua,
    fe.CEP
FROM Funcionarios f
LEFT JOIN Departamentos d ON f.departamento_id = d.idDepartamento
JOIN Funcionarios_Endereco fe ON f.idFuncionario = fe.funcionario_id;

DROP VIEW IF EXISTS vw_livros_palavras_chave;
CREATE VIEW vw_livros_palavras_chave AS
SELECT
    l.isbn,
    l.titulo,
    GROUP_CONCAT(pc.descricao SEPARATOR ', ') AS palavras_chave
FROM Livros l
JOIN Livros_PalavrasChave lpc ON l.isbn = lpc.livro_isbn
JOIN Palavras_Chave pc ON lpc.palavra_chave_id = pc.id_PalavraChave
GROUP BY l.isbn, l.titulo;

DROP VIEW IF EXISTS vw_clientes_enderecos;
CREATE VIEW vw_clientes_enderecos AS
SELECT
    c.cliente_id,
    c.cliente_nome,
    c.CPF_CNPJ,
    c.sexo,
    c.cliente_telefone,
    c.cliente_email,
    CONCAT(ce.rua, ', ', ce.bairro, ', ', ce.cidade, ' - ', ce.UF, ', CEP: ', ce.CEP) AS endereco_completo
FROM Clientes c
JOIN Clientes_Endereco ce ON c.cliente_id = ce.cliente_id;

DROP VIEW IF EXISTS vw_resumo_pedidos;
CREATE VIEW vw_resumo_pedidos AS
SELECT
    status_pedido,
    COUNT(*) AS total_pedidos,
    MIN(data_transacao) AS primeiro_pedido,
    MAX(data_transacao) AS ultimo_pedido
FROM Pedidos_Vendas
GROUP BY status_pedido;

DROP VIEW IF EXISTS vw_livros_por_area;
CREATE VIEW vw_livros_por_area AS
SELECT
    ac.descricao AS area_conhecimento,
    COUNT(l.isbn) AS quantidade_livros,
    GROUP_CONCAT(l.titulo SEPARATOR '; ') AS titulos
FROM Areas_Conhecimento ac
LEFT JOIN Livros l ON ac.id_AreasConhecimento = l.area_conhecimento_id
GROUP BY ac.id_AreasConhecimento;

DROP VIEW IF EXISTS vw_vendas_por_genero_autor;
CREATE VIEW vw_vendas_por_genero_autor AS
SELECT 
    l.genero,
    a.nome AS autor,
    COUNT(pv.idPedidoVenda) AS total_vendas,
    MIN(pv.data_transacao) AS primeira_venda,
    MAX(pv.data_transacao) AS ultima_venda
FROM Pedidos_Vendas pv
JOIN Exemplares e ON pv.exemplar_serie = e.numero_serie
JOIN Livros l ON e.isbn = l.isbn
JOIN Autores a ON l.autor_id = a.idAutor
GROUP BY l.genero, a.nome;

DROP VIEW IF EXISTS vw_clientes_historico_compras;
CREATE VIEW vw_clientes_historico_compras AS
SELECT
    c.cliente_id,
    c.cliente_nome,
    c.CPF_CNPJ,
    c.sexo,
    COUNT(pv.idPedidoVenda) AS total_compras,
    SUM(CASE WHEN pv.status_pedido = 'entregue' THEN 1 ELSE 0 END) AS compras_entregues,
    SUM(CASE WHEN pv.status_pedido = 'cancelado' THEN 1 ELSE 0 END) AS compras_canceladas,
    MAX(pv.data_transacao) AS ultima_compra
FROM Clientes c
LEFT JOIN Pedidos_Vendas pv ON c.cliente_id = pv.cliente_id
GROUP BY c.cliente_id, c.cliente_nome, c.CPF_CNPJ, c.sexo;



