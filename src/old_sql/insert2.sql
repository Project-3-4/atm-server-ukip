-- MySQL Script generated by MySQL Workbench
-- Tue Jun  7 16:35:36 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bankserver_main
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bankserver_main
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bankserver_main` DEFAULT CHARACTER SET utf8 ;
USE `bankserver_main` ;

-- -----------------------------------------------------
-- Table `bankserver_main`.`user_account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bankserver_main`.`user_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `pin` VARCHAR(100) NOT NULL,
  `iban` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `iban_UNIQUE` (`iban` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bankserver_main`.`billing_account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bankserver_main`.`billing_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `iban` VARCHAR(100) NOT NULL,
  `bank_code` VARCHAR(45) NOT NULL,
  `country_code` VARCHAR(45) NOT NULL,
  `user_account_id` INT NOT NULL,
  `balance` INT NOT NULL,
  PRIMARY KEY (`id`, `balance`),
  UNIQUE INDEX `iban_UNIQUE` (`iban` ASC) VISIBLE,
  INDEX `fk_billing_account_user_account_idx` (`user_account_id` ASC) VISIBLE,
  CONSTRAINT `fk_billing_account_user_account`
    FOREIGN KEY (`user_account_id`)
    REFERENCES `bankserver_main`.`user_account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bankserver_main`.`atm-money`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bankserver_main`.`atm-money` (
  `idATM-Money` INT NOT NULL,
  `1` INT NULL,
  `2` INT NULL,
  `10` INT NULL,
  `20` INT NULL,
  `50` INT NULL,
  `OUTOFMONEY` TINYINT NOT NULL,
  PRIMARY KEY (`idATM-Money`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bankserver_main`.`transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bankserver_main`.`transaction` (
  `idtransaction` INT NOT NULL,
  `balance_post_transaction` INT NOT NULL,
  `amount` INT NULL,
  `paper` VARCHAR(50) NULL,
  PRIMARY KEY (`idtransaction`, `balance_post_transaction`),
  INDEX `balance_idx` (`balance_post_transaction` ASC) VISIBLE,
  CONSTRAINT `balance`
    FOREIGN KEY (`balance_post_transaction`)
    REFERENCES `bankserver_main`.`billing_account` (`balance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bankserver_main`.`transaction_has_atm-money`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bankserver_main`.`transaction_has_atm-money` (
  `transaction_idtransaction` INT NOT NULL,
  `transaction_balance_post_transaction` INT NOT NULL,
  `atm-money_idATM-Money` INT NOT NULL,
  PRIMARY KEY (`transaction_idtransaction`, `transaction_balance_post_transaction`, `atm-money_idATM-Money`),
  INDEX `fk_transaction_has_atm-money_atm-money1_idx` (`atm-money_idATM-Money` ASC) VISIBLE,
  INDEX `fk_transaction_has_atm-money_transaction1_idx` (`transaction_idtransaction` ASC, `transaction_balance_post_transaction` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_has_atm-money_transaction1`
    FOREIGN KEY (`transaction_idtransaction` , `transaction_balance_post_transaction`)
    REFERENCES `bankserver_main`.`transaction` (`idtransaction` , `balance_post_transaction`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_has_atm-money_atm-money1`
    FOREIGN KEY (`atm-money_idATM-Money`)
    REFERENCES `bankserver_main`.`atm-money` (`idATM-Money`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;