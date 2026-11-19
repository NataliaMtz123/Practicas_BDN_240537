USE db_test;

/* 1. Cuantas tablas tenemos? */
-- En la práctica 3 agregamos 2 nuevas categorias y productos_categorias
SHOW TABLES;

/* 2. Cuantos triggers tenemos */
-- 12 Por cada tabla creada deberan estar 3 trigger para poder realizar la trazabilidad de bitacora
SHOW TRIGGERS FROM db_test;

/* 3. Contabilizar el total de productos por usuario*/
SELECT COUNT(*), inserted_by
FROM vw_trazabilidad_productos
GROUP BY inserted_by ;

/* 4. Contabilizar cuantos productos por categoria*/
SELECT * 
FROM vw_total_products_by_category
ORDER BY category_id is null;

/* 5. Muestra los procedimientos de la base de datos */
SHOW PROCEDURE STATUS WHERE Db = 'db_test';

/* 13. Consulta la trazabilidad de usuarios */
select * from vw_trazabilidad_usuarios ORDER BY operation_date desc;	

/* Consultas para ver la insersion masiva de usuarios*/

CALL db_test.sp_generar_usuarios_masivos(
    'USA1000',
    1000,
    'US',
    18,
    65,
    100
);

CALL db_test.sp_generar_usuarios_masivos(
    'EDAD2000',
    2000,
    'MX',
    18,
    30,
    100
);

CALL db_test.sp_generar_usuarios_masivos(
    'STATUS7222',
    7222,
    'MX',
    18,
    65,
    85
);


/*Total de usuarios insertados 1000*/
SELECT COUNT(*) AS usuarios_estadounidenses
FROM db_test.tb_users u
INNER JOIN db_test.tb_people p
    ON u.ID = p.user_ID
WHERE u.nick LIKE 'test_USA1000_%'
  AND p.country_code = 'US';

/*Total de usuarios insertados 2000*/
SELECT
    COUNT(*) AS total_usuarios,
    MIN(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()))
        AS edad_minima,
    MAX(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()))
        AS edad_maxima
FROM db_test.tb_users u
INNER JOIN db_test.tb_people p
    ON u.ID = p.user_ID
WHERE u.nick LIKE 'test_EDAD2000_%';

/*Total de usuarios insertados 7222*/
SELECT
    COUNT(*) AS total_usuarios,
    SUM(u.status + 0) AS activos,
    SUM(1 - (u.status + 0)) AS inactivos,
    ROUND(100 * AVG(u.status + 0), 2)
        AS porcentaje_activos,
    ROUND(100 * AVG(1 - (u.status + 0)), 2)
        AS porcentaje_inactivos
FROM db_test.tb_users u
WHERE u.nick LIKE 'test_STATUS7222_%';

/* Catidad de triggers*/
SELECT COUNT(*) AS total_triggers
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test';

/* Cantidad de usuarios en la BD*/
/*10222 insertados con el procedimiento*/
/* 11 insertados desde la terminal*/
SELECT COUNT(*) AS total_usuarios
FROM tb_users;

/* Cantidad de usarios Activos e Inactivos*/
SELECT
    COUNT(*) AS total_usuarios,
    SUM(status = b'1') AS usuarios_activos,
    SUM(status = b'0') AS usuarios_inactivos
FROM db_test.tb_users;

/*Mostrar las vistas*/
SELECT
    TABLE_NAME AS nombre_vista,
    TABLE_TYPE AS tipo
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_test'
  AND TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME;

/*Mostrar el total de trazablidades*/
SELECT COUNT(*) AS total_vistas_trazabilidad
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'db_test'
  AND TABLE_NAME LIKE 'vw_trazabilidad_%';