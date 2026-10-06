USE db_test;

/* 1. Cuantas tablas tenemos?*/
-- En la Practica 3 agregamos 2 nuevas categorias y productos_categorias
SHOW TABLES;

/* 2. Cuantos triggers tenemos*/
-- Por cada tabla creada deberan estar 3 triggers para poder realizar la trazabilidad de bitacora
SHOW TRIGGERS FROM db_test;

/*3. Consulta de productos por categoria*/
SELECT *
FROM vw_total_products_by_category
order by
	category_ID is null;