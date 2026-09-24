/* CREACION DE USUARIOS REMOTOS */

CREATE USER IF NOT EXISTS 'natalia.carrasco'@'%' IDENTIFIED BY '240853';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'aylin.esteban'@'%' IDENTIFIED BY '240853';
CREATE USER IF NOT EXISTS 'uriel.valenzuela'@'%' IDENTIFIED BY '240485';
CREATE USER IF NOT EXISTS 'yazmin.esquivel'@'%' IDENTIFIED BY '240235';
CREATE USER IF NOT EXISTS 'uriel.gonzales'@'%' IDENTIFIED BY '240463';
CREATE USER IF NOT EXISTS 'saul.barrios'@'%' IDENTIFIED BY '240196';


/* ASIGNACION DE PRIVILEGIOS DEL SUPER USUARIO - IMPORTANTE: SOLO USTEDES */

GRANT ALL PRIVILEGES ON *.* 
TO 'natalia.carrasco'@'%' 
WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON db_test.* 
TO 'saul.barrios'@'%';


/* CREACION DE ROLES PARA LOS USUARIOS DE LA PLATAFORMA DE ECOMMERCE */

CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'commom';
CREATE ROLE IF NOT EXISTS 'user_not_registered';
CREATE ROLE IF NOT EXISTS 'support';


/* ASIGNACION DE PRIVILEGIOS A LOS ROLES */


/* SUPERADMIN */

GRANT ALL PRIVILEGES ON *.* 
TO 'superadmin';


/* ADMIN */

GRANT ALL PRIVILEGES ON db_test.* 
TO 'admin';


/* SUPPORT */

GRANT SELECT, INSERT, UPDATE 
ON db_test.tb_users 
TO 'support';

GRANT SELECT, INSERT, UPDATE 
ON db_test.tb_products 
TO 'support';


/* SELLER */

GRANT SELECT, INSERT, UPDATE 
ON db_test.tb_products 
TO 'seller';


/* ASIGNAR EL ROL AL USUARIO */

GRANT 'superadmin' TO 'natalia.carrasco'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'uriel.gonzales'@'%';
GRANT 'seller' TO 'yazmin.esquivel'@'%';
GRANT 'seller' TO 'aylin.esteban'@'%';


/* ESTABLECER ROLES PREDETERMINADOS */

SET DEFAULT ROLE 'superadmin' 
TO 'natalia.carrasco'@'%';

SET DEFAULT ROLE 'admin' 
TO 'marco.ramirez'@'%';

SET DEFAULT ROLE 'support' 
TO 'uriel.gonzales'@'%';

SET DEFAULT ROLE 'seller' 
TO 'yazmin.esquivel'@'%';

SET DEFAULT ROLE 'seller' 
TO 'aylin.esteban'@'%';



SELECT 'Los usuarios y privilegios han sido creados correctamente' 
AS mensaje;