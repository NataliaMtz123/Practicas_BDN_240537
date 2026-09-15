DROP USER IF EXISTS 'natalia.carrasco'@'%';
DROP USER IF EXISTS 'marco.ramirez'@'%';
DROP USER IF EXISTS 'aylin.esteban'@'%',
DROP USER IF EXISTS 'uriel.valenzuela'@'%';

DROP ROLE IF exists 'admin';
DROP ROLE IF exists 'seller';
DROP ROLE IF exists 'buyer';
DROP ROLE IF exists 'buyer';
DROP ROLE IF exists 'user_not_registered';
DROP ROLE IF exists 'support';


/* CREACION DE USUARIOS REMOTOS */

CREATE USER 'natalia.carrasco'@'%' IDENTIFIED BY '240853';
CREATE USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER 'aylin.esteban'@'%' IDENTIFIED BY '240853';
CREATE USER 'uriel.valenzuela'@'%' IDENTIFIED BY '240485';


/* ASIGNACION DE PRIVILEGIOS DEL SUPER USUARIO - IMPORTANTE: SOLO USTEDES */

GRANT ALL PRIVILEGES ON *.* TO 'natalia.carrasco'@'%' WITH GRANT OPTION;



/* CREACION DE ROLES PARA LOS USUARIOS DE LA PLATAFORMA DE ECOMMERCE */

CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'buyer';
CREATE ROLE 'user_not_registered';
CREATE ROLE 'support';


/* ASIGNACION DE PRIVILEGIOS A LOS ROLES DE LA PLATAFORMA DE ECOMMERCE */

/* ADMIN */

GRANT ALL PRIVILEGES ON db_test.* TO 'admin';


/* SUPPORT */

GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';


/* ASIGNAR EL ROL AL USUARIO */

GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'uriel.valenzuela'@'%';