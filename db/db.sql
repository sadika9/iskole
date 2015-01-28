-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema school
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `school` ;

-- -----------------------------------------------------
-- Schema school
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `school` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `school` ;

-- -----------------------------------------------------
-- Table `school`.`user_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`user_type` ;

CREATE TABLE IF NOT EXISTS `school`.`user_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'STUDENT, TEACHER, PARENT, SYSTEM_USER';


-- -----------------------------------------------------
-- Table `school`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`user` ;

CREATE TABLE IF NOT EXISTS `school`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` VARCHAR(45) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `salt` VARCHAR(255) NULL DEFAULT NULL,
  `email` VARCHAR(255) NOT NULL,
  `user_type_id` INT NOT NULL,
  `activation_code` VARCHAR(45) NULL DEFAULT NULL,
  `forgotten_password_code` VARCHAR(45) NULL DEFAULT NULL,
  `forgotten_password_time` INT UNSIGNED NULL DEFAULT NULL,
  `remember_code` VARCHAR(45) NULL DEFAULT NULL,
  `created_on` INT UNSIGNED NOT NULL,
  `deactivated_on` INT UNSIGNED NULL DEFAULT NULL,
  `last_login` INT UNSIGNED NULL DEFAULT NULL,
  `active` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `user_type_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  INDEX `fk_user_user_type2_idx` (`user_type_id` ASC),
  CONSTRAINT `fk_user_user_type2`
    FOREIGN KEY (`user_type_id`)
    REFERENCES `school`.`user_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`user_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`user_details` ;

CREATE TABLE IF NOT EXISTS `school`.`user_details` (
  `user_id` INT UNSIGNED NOT NULL,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(255) NULL,
  `initials` VARCHAR(255) NULL,
  `address_line1` VARCHAR(255) NULL,
  `address_line2` VARCHAR(255) NULL,
  `city` VARCHAR(255) NULL,
  `province` VARCHAR(255) NULL,
  `postal_code` VARCHAR(255) NULL,
  `country` VARCHAR(255) NULL,
  `phone_number_1` VARCHAR(15) NULL,
  `phone_number_2` VARCHAR(15) NULL,
  `gender` CHAR(1) NULL,
  `dob` DATE NULL,
  INDEX `fk_contact_details_user_idx` (`user_id` ASC),
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_contact_details_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`teacher_ratings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`teacher_ratings` ;

CREATE TABLE IF NOT EXISTS `school`.`teacher_ratings` (
  `teacher_id` INT UNSIGNED NOT NULL,
  `ratings` INT NULL,
  INDEX `fk_teacher_user1_idx` (`teacher_id` ASC),
  PRIMARY KEY (`teacher_id`),
  CONSTRAINT `fk_teacher_user1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`student_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`student_details` ;

CREATE TABLE IF NOT EXISTS `school`.`student_details` (
  `student_id` INT UNSIGNED NOT NULL,
  `admission_date` DATE NULL,
  `parent_1` INT UNSIGNED NULL,
  `parent_2` INT UNSIGNED NULL,
  INDEX `fk_student_details_user1_idx` (`student_id` ASC),
  PRIMARY KEY (`student_id`, `parent_1`, `parent_2`),
  INDEX `fk_student_details_user2_idx` (`parent_1` ASC),
  INDEX `fk_student_details_user3_idx` (`parent_2` ASC),
  CONSTRAINT `fk_student_details_user1`
    FOREIGN KEY (`student_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_student_details_user2`
    FOREIGN KEY (`parent_1`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_details_user3`
    FOREIGN KEY (`parent_2`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`subject`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`subject` ;

CREATE TABLE IF NOT EXISTS `school`.`subject` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`class` ;

CREATE TABLE IF NOT EXISTS `school`.`class` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year_start` DATE NOT NULL,
  `year_end` DATE NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `level` VARCHAR(255) NOT NULL,
  `teacher_id` INT UNSIGNED NOT NULL,
  `ongoing` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`, `teacher_id`),
  INDEX `fk_class_user1_idx` (`teacher_id` ASC),
  CONSTRAINT `fk_class_user1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`student_class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`student_class` ;

CREATE TABLE IF NOT EXISTS `school`.`student_class` (
  `class_id` INT NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `status` VARCHAR(255) NULL COMMENT 'pass to next class\nPASS, FAILED, TRANSFERRED\n',
  PRIMARY KEY (`class_id`, `student_id`),
  INDEX `fk_class_user_user1_idx` (`student_id` ASC),
  INDEX `fk_class_has_user_class1_idx` (`class_id` ASC),
  CONSTRAINT `fk_class_has_user_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `school`.`class` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_class_has_user_user1`
    FOREIGN KEY (`student_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`course` ;

CREATE TABLE IF NOT EXISTS `school`.`course` (
  `id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `teacher_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `class_id`, `subject_id`, `teacher_id`),
  INDEX `fk_course_class1_idx` (`class_id` ASC),
  INDEX `fk_course_subject1_idx` (`subject_id` ASC),
  INDEX `fk_course_user1_idx` (`teacher_id` ASC),
  CONSTRAINT `fk_course_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `school`.`class` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_course_subject1`
    FOREIGN KEY (`subject_id`)
    REFERENCES `school`.`subject` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_course_user1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`enrollment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`enrollment` ;

CREATE TABLE IF NOT EXISTS `school`.`enrollment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `course_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_has_course_course1_idx` (`course_id` ASC),
  INDEX `fk_user_has_course_user1_idx` (`student_id` ASC),
  UNIQUE INDEX `student_id_UNIQUE` (`student_id` ASC),
  UNIQUE INDEX `course_id_UNIQUE` (`course_id` ASC),
  CONSTRAINT `fk_user_has_course_user1`
    FOREIGN KEY (`student_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_course_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `school`.`course` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`exam_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`exam_category` ;

CREATE TABLE IF NOT EXISTS `school`.`exam_category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '1st term test=1TT, 2nd term test=2TT';


-- -----------------------------------------------------
-- Table `school`.`exam`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`exam` ;

CREATE TABLE IF NOT EXISTS `school`.`exam` (
  `enrollment_id` INT NOT NULL,
  `exam_category_id` INT NOT NULL,
  `date` DATE NULL,
  `marks` DECIMAL(5,2) NULL,
  `grade` CHAR(2) NULL,
  PRIMARY KEY (`enrollment_id`, `exam_category_id`),
  INDEX `fk_exam_exam_category1_idx` (`exam_category_id` ASC),
  CONSTRAINT `fk_exam_enrollment1`
    FOREIGN KEY (`enrollment_id`)
    REFERENCES `school`.`enrollment` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_exam_exam_category1`
    FOREIGN KEY (`exam_category_id`)
    REFERENCES `school`.`exam_category` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`permissions` ;

CREATE TABLE IF NOT EXISTS `school`.`permissions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`login_attempt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`login_attempt` ;

CREATE TABLE IF NOT EXISTS `school`.`login_attempt` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` VARCHAR(45) NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `time` INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`groups` ;

CREATE TABLE IF NOT EXISTS `school`.`groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`user_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`user_group` ;

CREATE TABLE IF NOT EXISTS `school`.`user_group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `group_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_group_group1_idx` (`group_id` ASC),
  INDEX `fk_user_group_user1_idx` (`user_id` ASC),
  UNIQUE INDEX `uc_user_group` (`group_id` ASC, `user_id` ASC),
  CONSTRAINT `fk_users_has_groups_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `school`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_groups_groups1`
    FOREIGN KEY (`group_id`)
    REFERENCES `school`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`group_permission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `school`.`group_permission` ;

CREATE TABLE IF NOT EXISTS `school`.`group_permission` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` INT UNSIGNED NOT NULL,
  `permission_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_group_permission_permission1_idx` (`permission_id` ASC),
  INDEX `fk_group_permission_group1_idx` (`group_id` ASC),
  UNIQUE INDEX `uc_group_permission` (`permission_id` ASC, `group_id` ASC),
  CONSTRAINT `fk_group_permission_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `school`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_permission_permission1`
    FOREIGN KEY (`permission_id`)
    REFERENCES `school`.`permissions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `school`.`user_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`user_type` (`id`, `type`) VALUES (1, 'ADMIN');
INSERT INTO `school`.`user_type` (`id`, `type`) VALUES (2, 'TEACHER');
INSERT INTO `school`.`user_type` (`id`, `type`) VALUES (3, 'STUDENT');
INSERT INTO `school`.`user_type` (`id`, `type`) VALUES (4, 'PARENT');

COMMIT;


-- -----------------------------------------------------
-- Data for table `school`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`user` (`id`, `ip_address`, `username`, `password`, `salt`, `email`, `user_type_id`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `deactivated_on`, `last_login`, `active`) VALUES (1, '127.0.0.1', 'admin', '$2a$07$SeBknntpZror9uyftVopmu61qg0ms8Qv1yV6FG.kQOSM.9QhmTo36', NULL, 'admin@iskole.com', 1, NULL, NULL, NULL, NULL, 1268889823, NULL, 1268889823, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `school`.`permissions`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (1, 'create_user', 'Create new user');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (2, 'edit_user', 'Edit user details');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (3, 'change_user_state', 'Activate/Deactivate User');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (4, 'view_all_users', 'Get list of all users');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (5, 'create_users_groups', 'Create users groups');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (6, 'edit_users_groups', 'Edit users groups');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (7, 'create_group_permissions', 'Create group permissions');
INSERT INTO `school`.`permissions` (`id`, `name`, `description`) VALUES (8, 'edit_group_permissions', 'Edit group permissions');

COMMIT;


-- -----------------------------------------------------
-- Data for table `school`.`groups`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`groups` (`id`, `name`, `description`) VALUES (1, 'ADMIN', 'Administrator Group');

COMMIT;


-- -----------------------------------------------------
-- Data for table `school`.`user_group`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`user_group` (`id`, `user_id`, `group_id`) VALUES (1, 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `school`.`group_permission`
-- -----------------------------------------------------
START TRANSACTION;
USE `school`;
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (1, 1, 1);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (2, 1, 2);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (3, 1, 3);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (4, 1, 4);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (5, 1, 5);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (6, 1, 6);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (7, 1, 7);
INSERT INTO `school`.`group_permission` (`id`, `group_id`, `permission_id`) VALUES (8, 1, 8);

COMMIT;

