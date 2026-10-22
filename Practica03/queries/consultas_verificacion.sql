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