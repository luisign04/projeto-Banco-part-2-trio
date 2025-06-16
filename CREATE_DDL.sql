-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Autores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Autores` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Autores` (
  `idAutor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `biografia` TEXT NULL,
  `nacionalidade` VARCHAR(50) NULL,
  `data_nascimento` DATE NULL,
  PRIMARY KEY (`idAutor`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Areas_Conhecimento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Areas_Conhecimento` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Areas_Conhecimento` (
  `id_AreasConhecimento` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_AreasConhecimento`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Departamentos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Departamentos` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Departamentos` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT NULL,
  `responsavel` VARCHAR(100) NULL,
  PRIMARY KEY (`idDepartamento`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Palavras_Chave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Palavras_Chave` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Palavras_Chave` (
  `id_PalavraChave` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_PalavraChave`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Livros`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Livros` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Livros` (
  `isbn` VARCHAR(20) NOT NULL,
  `titulo` VARCHAR(150) NOT NULL,
  `editora` VARCHAR(100) NULL,
  `data_publicacao` DATE NULL,
  `genero` VARCHAR(50) NULL,
  `num_paginas` INT NULL,
  `descricao` TEXT NULL,
  `autor_id` INT NULL,
  `area_conhecimento_id` INT NULL,
  PRIMARY KEY (`isbn`),
  INDEX `autor_id_idx` (`autor_id` ASC),
  INDEX `area_conhecimento_id_idx` (`area_conhecimento_id` ASC),
  CONSTRAINT `autor_id`
    FOREIGN KEY (`autor_id`)
    REFERENCES `mydb`.`Autores` (`idAutor`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `area_conhecimento_id`
    FOREIGN KEY (`area_conhecimento_id`)
    REFERENCES `mydb`.`Areas_Conhecimento` (`id_AreasConhecimento`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Exemplares`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Exemplares` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Exemplares` (
  `numero_serie` VARCHAR(30) NOT NULL,
  `isbn` VARCHAR(20) NULL,
  `estado` ENUM('pendente', 'enviado', 'cancelado', 'entregue') NOT NULL,
  `localizacao` VARCHAR(100) NULL,
  PRIMARY KEY (`numero_serie`),
  INDEX `fk_exemplares_livros_idx` (`isbn` ASC),
  CONSTRAINT `fk_exemplares_livros`
    FOREIGN KEY (`isbn`)
    REFERENCES `mydb`.`Livros` (`isbn`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Clientes` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Clientes` (
  `cliente_id` INT NOT NULL AUTO_INCREMENT,
  `CPF_CNPJ` VARCHAR(14) NOT NULL,
  `cliente_nome` VARCHAR(100) NOT NULL,
  `sexo` ENUM('M', 'F') NOT NULL,
  `cliente_telefone` VARCHAR(20) NULL,
  `cliente_email` VARCHAR(100) NULL,
  PRIMARY KEY (`cliente_id`),
  UNIQUE INDEX `CPF_CNPJ_UNIQUE` (`CPF_CNPJ` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Pedidos_Vendas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Pedidos_Vendas` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Pedidos_Vendas` (
  `idPedidoVenda` INT NOT NULL AUTO_INCREMENT,
  `cliente_id` INT NOT NULL,
  `data_transacao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status_pedido` ENUM('pendente', 'enviado', 'cancelado', 'entregue') NOT NULL,
  `pagamento_detalhes` TEXT NULL,
  `exemplar_serie` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idPedidoVenda`),
  INDEX `fk_pedidos_exemplares_idx` (`exemplar_serie` ASC),
  INDEX `fk_pedidos_clientes_idx` (`cliente_id` ASC),
  CONSTRAINT `fk_pedidos_exemplares`
    FOREIGN KEY (`exemplar_serie`)
    REFERENCES `mydb`.`Exemplares` (`numero_serie`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_clientes`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `mydb`.`Clientes` (`cliente_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Funcionarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Funcionarios` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Funcionarios` (
  `idFuncionario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cargo` VARCHAR(50) NULL,
  `telefone` VARCHAR(20) NULL,
  `departamento_id` INT NULL,
  PRIMARY KEY (`idFuncionario`),
  INDEX `departamento_id_idx` (`departamento_id` ASC),
  CONSTRAINT `departamento_id`
    FOREIGN KEY (`departamento_id`)
    REFERENCES `mydb`.`Departamentos` (`idDepartamento`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Funcionarios_Endereco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Funcionarios_Endereco` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Funcionarios_Endereco` (
  `funcionario_id` INT NOT NULL,
  `UF` CHAR(2) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(50) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `CEP` CHAR(8) NOT NULL,
  `comp` VARCHAR(100) NULL,
  PRIMARY KEY (`funcionario_id`),
  CONSTRAINT `funcionario_id`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `mydb`.`Funcionarios` (`idFuncionario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Clientes_Endereco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Clientes_Endereco` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Clientes_Endereco` (
  `cliente_id` INT NOT NULL,
  `UF` CHAR(2) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(50) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `CEP` CHAR(8) NOT NULL,
  `comp` VARCHAR(100) NULL,
  PRIMARY KEY (`cliente_id`),
  CONSTRAINT `cliente_id`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `mydb`.`Clientes` (`cliente_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Livros_PalavrasChave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Livros_PalavrasChave` ;
CREATE TABLE IF NOT EXISTS `mydb`.`Livros_PalavrasChave` (
  `livro_isbn` VARCHAR(20) NOT NULL,
  `palavra_chave_id` INT NOT NULL,
  PRIMARY KEY (`livro_isbn`, `palavra_chave_id`),
  INDEX `id_PalavraChave_idx` (`palavra_chave_id` ASC),
  CONSTRAINT `livro_isbn`
    FOREIGN KEY (`livro_isbn`)
    REFERENCES `mydb`.`Livros` (`isbn`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_PalavraChave`
    FOREIGN KEY (`palavra_chave_id`)
    REFERENCES `mydb`.`Palavras_Chave` (`id_PalavraChave`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;