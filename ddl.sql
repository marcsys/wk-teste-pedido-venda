-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema wk_teste_pedido_venda
-- -----------------------------------------------------
-- Schema para a aplicação teste de Pedidos de Venda

-- -----------------------------------------------------
-- Schema wk_teste_pedido_venda
--
-- Schema para a aplicação teste de Pedidos de Venda
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `wk_teste_pedido_venda` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `wk_teste_pedido_venda` ;

-- -----------------------------------------------------
-- Table `wk_teste_pedido_venda`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cliente`;

CREATE TABLE IF NOT EXISTS `wk_teste_pedido_venda`.`cliente` (
  `cod_cliente` BIGINT(14) NOT NULL COMMENT 'Código do cliente, compatível com CPF/CNPJ',
  `nome_cliente` VARCHAR(100) NOT NULL COMMENT 'Nome do cliente',
  `cidade_cliente` VARCHAR(45) NULL COMMENT 'Município do cliente',
  `uf_cliente` CHAR(2) NULL COMMENT 'Unidade Federativa do cliente',
  PRIMARY KEY (`cod_cliente`))
ENGINE = InnoDB
COMMENT = 'Tabela de clientes';


-- -----------------------------------------------------
-- Table `wk_teste_pedido_venda`.`produto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produto`;

CREATE TABLE IF NOT EXISTS `wk_teste_pedido_venda`.`produto` (
  `cod_produto` BIGINT(13) NOT NULL COMMENT 'Código do produto, compatível com código de barras.',
  `desc_produto` VARCHAR(250) NULL COMMENT 'Descrição do produto',
  `preco_venda` DECIMAL(7,2) NOT NULL COMMENT 'Preço do produto',
  PRIMARY KEY (`cod_produto`))
ENGINE = InnoDB
COMMENT = 'Tabela de produtos';


-- -----------------------------------------------------
-- Table `wk_teste_pedido_venda`.`pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pedido`;

CREATE TABLE IF NOT EXISTS `wk_teste_pedido_venda`.`pedido` (
  `num_pedido` INT NOT NULL AUTO_INCREMENT COMMENT 'Número do pedido',
  `cod_cliente` BIGINT(14) NOT NULL COMMENT 'Número do cliente que fez o pedido',
  `data_emissao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora do pedido',
  `valor_total` DECIMAL(14,2) NOT NULL COMMENT 'Valor total do pedido',
  PRIMARY KEY (`num_pedido`),
  CONSTRAINT `pedido_cliente_fk`
    FOREIGN KEY (`cod_cliente`)
    REFERENCES `wk_teste_pedido_venda`.`cliente` (`cod_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tabela de Pedidos de Venda';

CREATE INDEX `pedido_cliente_fk_idx` ON `wk_teste_pedido_venda`.`pedido` (`cod_cliente` ASC);


-- -----------------------------------------------------
-- Table `wk_teste_pedido_venda`.`item_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `item_pedido`;

CREATE TABLE IF NOT EXISTS `wk_teste_pedido_venda`.`item_pedido` (
  `seq_item_pedido` INT NOT NULL AUTO_INCREMENT COMMENT 'Sequencial de item de pedido',
  `num_pedido` INT NOT NULL COMMENT 'Número do pedido vinculado',
  `cod_produto` BIGINT(14) NOT NULL COMMENT 'Código do produto referenciado',
  `valor_unitario` DECIMAL(7,2) NOT NULL COMMENT 'Valor unitário (pode ser diferente do valor de venda do produto)',
  `quantidade` FLOAT NOT NULL DEFAULT 1 COMMENT 'Quantidade de unidades do item',
  `valor_total_item` DECIMAL(14,2) GENERATED ALWAYS AS (valor_unitario * quantidade) VIRTUAL COMMENT 'Valor unitário * a quantidade',
  PRIMARY KEY (`seq_item_pedido`),
  CONSTRAINT `item_pedido_fk`
    FOREIGN KEY (`num_pedido`)
    REFERENCES `wk_teste_pedido_venda`.`pedido` (`num_pedido`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `item_produto_fk`
    FOREIGN KEY (`cod_produto`)
    REFERENCES `wk_teste_pedido_venda`.`produto` (`cod_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tabela de itens de pedido';

CREATE INDEX `item_pedido_fk_idx` ON `wk_teste_pedido_venda`.`item_pedido` (`num_pedido` ASC) ;

CREATE INDEX `item_produto_fk_idx` ON `wk_teste_pedido_venda`.`item_pedido` (`cod_produto` ASC) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
