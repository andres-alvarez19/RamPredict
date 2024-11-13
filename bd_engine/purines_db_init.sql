-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema purinesdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `purinesdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `purinesdb` ;

-- -----------------------------------------------------
-- Table `purinesdb`.`antibiotico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`antibiotico` (
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`nombre`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `purinesdb`.`animal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`animal` (
  `id` INT UNSIGNED NOT NULL,
  `edad_promedio` INT UNSIGNED NULL DEFAULT NULL,
  `estado_salud` VARCHAR(50) NULL DEFAULT NULL,
  `cantidad_animales` INT UNSIGNED NULL DEFAULT NULL,
  `dieta_animales` VARCHAR(255) NULL DEFAULT NULL,
  `uso_antibioticos` TINYINT NULL DEFAULT NULL,
  `animal` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `purinesdb`.`antibiotico_usado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`antibiotico_usado` (
  `id_antibiotico_usado` INT UNSIGNED NOT NULL,
  `dias_tratamiento` INT NULL,
  `antibiotico_nombre` VARCHAR(100) NOT NULL,
  `animal_id` INT UNSIGNED NOT NULL,
  `cantidad_usada_por_animal_promedio` FLOAT NULL,
  `frecuencia_antibiotico` VARCHAR(45) NULL,
  PRIMARY KEY (`id_antibiotico_usado`),
  INDEX `fk_antibiotico_usado_antibiotico_idx` (`antibiotico_nombre` ASC) VISIBLE,
  INDEX `fk_antibiotico_usado_animal1_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_antibiotico_usado_antibiotico`
    FOREIGN KEY (`antibiotico_nombre`)
    REFERENCES `purinesdb`.`antibiotico` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_antibiotico_usado_animal1`
    FOREIGN KEY (`animal_id`)
    REFERENCES `purinesdb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`gen_resistencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`gen_resistencia` (
  `nombre` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`nombre`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `purinesdb`.`muestra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`muestra` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `resultado` VARCHAR(50) NULL DEFAULT NULL,
  `tipo_purin` VARCHAR(50) NULL DEFAULT NULL,
  `volumen_muestra` FLOAT NULL DEFAULT NULL,
  `ph_muestra` FLOAT NULL DEFAULT NULL,
  `comentarios` TEXT NULL DEFAULT NULL,
  `fecha_recoleccion` DATE NULL,
  `gps_coordinates` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `purinesdb`.`analisis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`analisis` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `muestra_id` INT UNSIGNED NOT NULL,
  `fecha_analisis` DATE NULL DEFAULT NULL,
  `metodo_analisis` VARCHAR(100) NULL DEFAULT NULL,
  `parametros_calidad` VARCHAR(255) NULL DEFAULT NULL,
  `cebadores_sondas` VARCHAR(255) NULL DEFAULT NULL,
  `concentracion_materia_organica` FLOAT NULL DEFAULT NULL,
  `carga_microbiana` FLOAT NULL DEFAULT NULL,
  `diversidad_microbiana` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `muestra_id` (`muestra_id` ASC) VISIBLE,
  CONSTRAINT `analisis_ibfk_1`
    FOREIGN KEY (`muestra_id`)
    REFERENCES `purinesdb`.`muestra` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`gen_presente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`gen_presente` (
  `id_gen_presente` INT UNSIGNED NOT NULL,
  `concentracion_gen` FLOAT NULL,
  `gen_resistencia_nombre` VARCHAR(150) NOT NULL,
  `unidad_concentracion` VARCHAR(20) NULL,
  `analisis_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_gen_presente`),
  INDEX `fk_cantidad_gen_presente_genes_resistencia1_idx` (`gen_resistencia_nombre` ASC) VISIBLE,
  UNIQUE INDEX `gen_resistencia_nombre_UNIQUE` (`gen_resistencia_nombre` ASC) VISIBLE,
  INDEX `fk_gen_presente_analisis1_idx` (`analisis_id` ASC) VISIBLE,
  CONSTRAINT `fk_cantidad_gen_presente_genes_resistencia1`
    FOREIGN KEY (`gen_resistencia_nombre`)
    REFERENCES `purinesdb`.`gen_resistencia` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gen_presente_analisis1`
    FOREIGN KEY (`analisis_id`)
    REFERENCES `purinesdb`.`analisis` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `purinesdb`.`resistencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`resistencia` (
  `id_resistencia` INT NOT NULL,
  `porcentaje_resistencia` FLOAT NULL,
  `antibiotico_nombre` VARCHAR(100) NOT NULL,
  `resistenciacol` VARCHAR(45) NULL,
  `gen_presente_id_gen_presente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_resistencia`, `antibiotico_nombre`, `gen_presente_id_gen_presente`),
  INDEX `fk_resistencia_antibiotico1_idx` (`antibiotico_nombre` ASC) VISIBLE,
  INDEX `fk_resistencia_gen_presente1_idx` (`gen_presente_id_gen_presente` ASC) VISIBLE,
  CONSTRAINT `fk_resistencia_antibiotico1`
    FOREIGN KEY (`antibiotico_nombre`)
    REFERENCES `purinesdb`.`antibiotico` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_resistencia_gen_presente1`
    FOREIGN KEY (`gen_presente_id_gen_presente`)
    REFERENCES `purinesdb`.`gen_presente` (`id_gen_presente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `purinesdb`.`caracteristicasfundo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`caracteristicasfundo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `muestra_id` INT UNSIGNED NOT NULL,
  `ubicacion_geografica` VARCHAR(100) NULL DEFAULT NULL,
  `caracteristicas_fundo` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `muestra_id` (`muestra_id` ASC) VISIBLE,
  CONSTRAINT `caracteristicasfundo_ibfk_1`
    FOREIGN KEY (`muestra_id`)
    REFERENCES `purinesdb`.`muestra` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `purinesdb`.`condicion_ambiental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`condicion_ambiental` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `muestra_id` INT UNSIGNED NOT NULL,
  `temperatura_muestra` FLOAT NULL DEFAULT NULL,
  `temperatura_ambiental` FLOAT NULL DEFAULT NULL,
  `humedad_relativa` FLOAT NULL DEFAULT NULL,
  `condiciones_meteorologicas` VARCHAR(100) NULL DEFAULT NULL,
  `hora_recoleccion` TIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `muestra_id` (`muestra_id` ASC) VISIBLE,
  CONSTRAINT `condicionesambientales_ibfk_1`
    FOREIGN KEY (`muestra_id`)
    REFERENCES `purinesdb`.`muestra` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `purinesdb`.`tratamientomuestra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`tratamientomuestra` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `muestra_id` INT UNSIGNED NOT NULL,
  `tratamientos_previos` VARCHAR(255) NULL DEFAULT NULL,
  `metodo_conservacion` VARCHAR(100) NULL DEFAULT NULL,
  `tiempo_almacenamiento` INT NULL DEFAULT NULL,
  `condiciones_transporte` VARCHAR(100) NULL DEFAULT NULL,
  `temperatura_almacenamiento` FLOAT NULL,
  PRIMARY KEY (`id`),
  INDEX `muestra_id` (`muestra_id` ASC) VISIBLE,
  CONSTRAINT `tratamientomuestra_ibfk_1`
    FOREIGN KEY (`muestra_id`)
    REFERENCES `purinesdb`.`muestra` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `purinesdb`.`animal_has_muestra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purinesdb`.`animal_has_muestra` (
  `animal_id` INT UNSIGNED NOT NULL,
  `muestra_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`animal_id`, `muestra_id`),
  INDEX `fk_animal_has_muestra_muestra1_idx` (`muestra_id` ASC) VISIBLE,
  INDEX `fk_animal_has_muestra_animal1_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_animal_has_muestra_animal1`
    FOREIGN KEY (`animal_id`)
    REFERENCES `purinesdb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_animal_has_muestra_muestra1`
    FOREIGN KEY (`muestra_id`)
    REFERENCES `purinesdb`.`muestra` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
