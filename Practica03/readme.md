# Práctica 03 — Manipulación de datos, relaciones, procedimientos, funciones y eventos en conexiones remotas

# Prácticas de la asignatura Optativa I: Bases de Datos en la Nube
## Ingeniería en Tecnologías de la Información e Innovación Digital
### Docente: M.T.I. Marco A. Ramírez Hernández
**Periodo:** Septiembre – diciembre de 2026

---

## Tabla de prácticas de la materia

| No. | Nombre | Descripción | Potenciador | Estatus |
|---|---|---|---:|---|
| 1 | Metodología de Evaluación de la Materia | Transcribir en libreta y comprender la metodología y fechas de evaluación de la asignatura. | 42 | 💚 Concluida |
| 2 | Conexiones Remotas para Bases de Datos SQL | Crear y administrar usuarios y privilegios para conexiones desde internet o redes locales. | 60 | 💚 Concluida |
| 3 | Manipulación de Datos en Conexiones Remotas a Bases de Datos Relacionales| Crear procedimientos almacenados, funciones, tablas derivadas e importar datos en el contexto de E-Commerce. | 100 | 💚 Concluida |

> El enlace de la práctica 3 apunta a este mismo README, sin crear carpetas adicionales.

---

## 📋 Descripción general

Esta práctica documenta el trabajo con la base de datos relacional **`db_test`**, utilizada en un escenario de **E-Commerce** con MySQL. Se incluyen respaldos SQL, scripts de administración de usuarios y privilegios, consultas de verificación, archivos CSV para carga de datos y una visualización del diccionario de datos y modelo entidad–relación extendido (EER).

La documentación se organiza según los archivos presentes en esta carpeta. Los resultados de ejecución y los totales de registros deben comprobarse en la instancia de MySQL donde se restaure el respaldo.

## 📁 Estructura del proyecto

```text
Practica03/
├── backups/                         # Respaldos históricos de db_test (.sql)
├── docs/
│   └── index.html                   # Explorador/documentación web
├── prompt/
│   ├── Promp.txt
│   └── Prompt_modelo_diccionario.txt
├── queries/
│   └── consultas_verificacion.sql
├── scripts/
│   └── remote_users_privileges_creation.sql
├── seeds/
│   ├── categorias_ecommerce_100.csv
│   ├── categoria_productos_nat.csv
│   └── productos_nuevos_10000_v2.csv
└── readme.md
```

## 🗄️ Respaldos de la base de datos

La carpeta **[backups](./backups/)** contiene respaldos históricos de la base de datos, desde `Respaldo_30092026.sql` hasta `Respaldo_2710.sql`, además de otros respaldos intermedios de octubre.

Como referencia de documentación se revisó **[Respaldo_2710.sql](./backups/Respaldo_2710.sql)**, que contiene definiciones de **25 tablas** y **28 vistas**. Estos conteos corresponden al archivo revisado; no equivalen necesariamente al estado actual de una base restaurada.

> **Precaución:** Restaurar un respaldo puede modificar o reemplazar objetos existentes. Revisar el archivo antes de ejecutarlo y realizar una copia de seguridad.

## 🌐 Usuarios remotos, privilegios y roles

El script **[remote_users_privileges_creation.sql](./scripts/remote_users_privileges_creation.sql)** contiene instrucciones para:

- Crear usuarios de conexión remota y cuentas de aplicación (`app_web` y `app_movil`).
- Definir roles como `superadmin`, `admin`, `seller`, `buyer`, `support` y `user_not_registered`.
- Asignar permisos sobre tablas y procedimientos de `db_test`.
- Establecer roles predeterminados para determinadas cuentas.

**Seguridad:** el script incluye contraseñas de ejemplo y permisos amplios. No debe ejecutarse sin revisarlos, sustituir credenciales y aplicar el principio de mínimo privilegio.

## ⚙️ Procedimientos almacenados y automatización

Los materiales de la práctica incluyen verificaciones y ejemplos de uso de procedimientos almacenados:

- `sp_register_user`: procedimiento de registro de usuarios referenciado en la asignación de permisos.
- `sp_soft_delete_user`: procedimiento referenciado en los permisos del rol de soporte.
- `sp_generar_usuarios_masivos`: procedimiento invocado en los escenarios de inserción masiva del archivo de consultas.

Las definiciones concretas deben verificarse en el respaldo restaurado mediante `SHOW PROCEDURE STATUS` y `SHOW CREATE PROCEDURE`.

## 🧪 Consultas y pruebas de verificación

En **[consultas_verificacion.sql](./queries/consultas_verificacion.sql)** se incluyen consultas para:

1. Listar las tablas y los triggers de `db_test`.
2. Consultar productos por usuario y productos por categoría mediante vistas.
3. Consultar los procedimientos almacenados disponibles.
4. Revisar la trazabilidad de usuarios.
5. Ejecutar tres escenarios de generación masiva de usuarios: **1,000**, **2,000** y **7,222** registros solicitados.
6. Contabilizar usuarios y comprobar rangos de edad y proporciones de estados activos/inactivos.
7. Contar triggers, vistas y vistas de trazabilidad.

> Los tamaños de los escenarios son parámetros de prueba, no una afirmación de que todos los registros se insertaron correctamente. Ejecutar primero en un entorno de pruebas, ya que las llamadas pueden crear datos.

### Consultas rápidas

```sql
USE db_test;

-- Tablas base
SELECT COUNT(*) AS total_tablas
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_test' AND TABLE_TYPE = 'BASE TABLE';

-- Triggers
SELECT COUNT(*) AS total_triggers
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test';

-- Vistas
SELECT COUNT(*) AS total_vistas
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'db_test';

-- Procedimientos
SHOW PROCEDURE STATUS WHERE Db = 'db_test';
```

## 📦 Datos de prueba para E-Commerce

La carpeta **[seeds](./seeds/)** contiene los archivos CSV:

| Archivo | Propósito |
|---|---|
| [categorias_ecommerce_100.csv](./seeds/categorias_ecommerce_100.csv) | Datos de categorías de E-Commerce. |
| [categoria_productos_nat.csv](./seeds/categoria_productos_nat.csv) | Datos relacionados con categorías y productos. |
| [productos_nuevos_10000_v2.csv](./seeds/productos_nuevos_10000_v2.csv) | Datos de productos para pruebas de carga. |

Antes de importar los CSV, comprobar nombres de columnas, codificación, tipos de datos, claves y restricciones de las tablas de destino.

## 📚 Diccionario de datos y modelo EER

Se incluye un explorador web en **[docs/index.html](./docs/index.html)** y los archivos de instrucciones usados para preparar la documentación en **[prompt](./prompt/)**.

**[📖 Consultar diccionario de datos y modelo EER en GitHub Pages](https://nataliamtz123.github.io/Practicas_BDN_240537/)**

> El enlace corresponde al sitio GitHub Pages del repositorio. Para publicar específicamente `Practica03/docs/index.html`, es necesario comprobar la configuración de publicación y la ruta servida por GitHub Pages.

## 🔍 Trazabilidad y auditoría

El archivo de verificación consulta vistas como `vw_trazabilidad_usuarios` y `vw_trazabilidad_productos`, además de contar triggers a través de `information_schema.TRIGGERS`. Estas consultas permiten revisar la trazabilidad disponible después de restaurar y configurar la base de datos.

## ✅ Evidencias y validación

Para documentar los resultados de la práctica se recomienda conservar capturas o salidas de las consultas de conteo, procedimientos, vistas, triggers, pruebas remotas e importación de datos. No se incluyen resultados de ejecución inventados: deben obtenerse directamente de MySQL.

---

**Repositorio:** [Practicas_BDN_240537](https://github.com/NataliaMtz123/Practicas_BDN_240537) · **Rama:** `Practica03` · **Carpeta:** `Practica03`
