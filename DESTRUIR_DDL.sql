USE `mydb` ;

-- Desabilitar verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 0;

-- Remover todas as views
DROP VIEW IF EXISTS 
    vw_livros_com_detalhes,
    vw_pedidos_completo,
    vw_estoque_exemplares,
    vw_funcionarios_completo,
    vw_livros_palavras_chave,
    vw_clientes_enderecos,
    vw_resumo_pedidos,
    vw_livros_por_area,
    vw_vendas_por_genero_autor,
    vw_clientes_historico_compras;

-- Remover todas as tabelas na ordem correta de dependências
DROP TABLE IF EXISTS 
    mydb.Livros_PalavrasChave,
    mydb.Funcionarios_Endereco,
    mydb.Clientes_Endereco,
    mydb.Pedidos_Vendas,
    mydb.Exemplares,
    mydb.Funcionarios,
    mydb.Clientes,
    mydb.Livros,
    mydb.Palavras_Chave,
    mydb.Areas_Conhecimento,
    mydb.Autores,
    mydb.Departamentos;

-- Reabilitar verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;

-- Remover o schema completo
DROP SCHEMA IF EXISTS mydb;