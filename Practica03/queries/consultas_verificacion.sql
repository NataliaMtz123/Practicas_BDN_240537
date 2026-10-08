USE db_test;

/* 1. Cuantas tablas tenemos?*/
-- En la Practica 3 agregamos 2 nuevas categorias y productos_categorias
SHOW TABLES;

/* 2. Cuantos triggers tenemos*/
-- Por cada tabla creada deberan estar 3 triggers para poder realizar la trazabilidad de bitacora
SHOW TRIGGERS FROM db_test;

/*3. */
SELECT count(*) from tb_logs;

/*4. Contabilizar el total de productos*/
SELECT count(*) FROM tb_products;

/*4.1*/
 

/*5.1 Contabilizar las categorias*/
select count(*) from tbc_categories;

/*6. Verfificar los movimientos de categorias en la bitacora*/
select * from tb_logs 

/*3. Consulta de productos por categoria*/
SELECT *
FROM vw_total_products_by_category
order by
	category_ID is null;
    
/*4. Muestra los procedimientos de la base de datos*/
SHOW PROCEDURE STATUS WHERE Db= 'db_test';


    