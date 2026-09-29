
USE db_test;

/* Verificar el total de tabla en mi base de datos*/
SHOW TABLES;

/*Verificar el total de triggers en mi base de datos*/
SHOW TRIGGERS FROM db_test;

/*cuantosz registros existen en la tabla users?*/
select count(*)  AS total_registros From tb_users;

/* Consultar los registros de los usuarios*/
SELECT * FROM tb_users;
/* Consultar los registros de la bitacora */
SELECT * FROM tb_logs;

/* Verifica los usuarios remotos creados en el servidor*/
SELECT user,host FROM mysql.user WHERE host="%";

/*Verificar que los usuarios remotos hayan sido creados*/
select  User, Host From mysql.user where host='%' and account_locked='N';


/* Verificar los roles asignados a los usuarios remotos creados en el servidor*/
SELECT
	FROM_USER AS Rol,
    FROM_HOST AS Host_Rol,
    TO_USER AS Usuario,
    TO_HOST AS Host_Usuario
FROM mysql.role_edges
ORDER BY FROM_USER, TO_USER;

/* Consulta para verificar que usuarios de la base de datos, inserto a que usuario de la plataforma 
agregando el rol del SBBD*/
SELECT u.nick, u.email, b.db_userS AS inserted_by,
GROUP_CONCAT(DISTINCT re.FROM_USER ORDER BY re.FROM_USER SEPARATOR ', ' ) AS roles,
    b.operation_description,
    b.operation_date
FROM tb_users u
JOIN tb_logs b
    ON b.operation_description LIKE CONCAT('%', u.nick, '%')
    AND b.operation_description LIKE CONCAT('%', u.email, '%')
LEFT JOIN mysql.role_edges re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_users, '@', 1)
WHERE b.table_operation = 'Create'
AND b.table_name = 'tb_users'
GROUP BY u.nick, u.email, b.db_user, b.operation_description, b.operation_date
ORDER BY b.operation_date asc;

SELECT 
    p.id,
    p.name,
    p.description,
    b.db_users AS inserted_by,

    COALESCE(
        GROUP_CONCAT(
            DISTINCT re.FROM_USER
            ORDER BY re.FROM_USER
            SEPARATOR ', '
        ),
        'Sin rol'
    ) AS roles,

    b.description AS operation_description,
    b.operation_date

FROM tb_products AS p

JOIN tb_logs AS b
    ON b.description LIKE CONCAT('%ID=', p.id, '%')

LEFT JOIN mysql.role_edges AS re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_users, '@', 1)

WHERE b.operation = 'Create'
  AND b.table_name = 'tb_products'

GROUP BY
    p.id,
    p.name,
    p.description,
    b.db_users,
    b.description,
    b.operation_date

ORDER BY b.operation_date ASC;