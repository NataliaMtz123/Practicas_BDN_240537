# **Práctica 04 — Pruebas de compra, transacciones y trazabilidad en conexiones remotas a bases de datos relacionales**

# **Prácticas de la asignatura Optativa I: Bases de Datos en la Nube**
## **Ingeniería en Tecnologías de la Información e Innovación Digital**
### **Docente: M.T.I. Marco A. Ramírez Hernández**
**Periodo:** Septiembre – diciembre de 2026

---

## **Tabla de prácticas de la materia**

| No. | Nombre | Descripción | Potenciador | Estatus |
|---|---|---|---:|---|
| 1 | Metodología de Evaluación de la Materia | Transcribir en libreta y comprender la metodología y fechas de evaluación de la asignatura. | 42 | 💚 Concluida |
| 2 | Conexiones Remotas para Bases de Datos SQL | Crear y administrar usuarios y privilegios para conexiones desde internet o redes locales. | 60 | 💚 Concluida |
| 3 | Manipulación de Datos en Conexiones Remotas a Bases de Datos Relacionales | Crear procedimientos almacenados, funciones, tablas derivadas e importar datos en el contexto de E-Commerce. | 100 | 💚 Concluida |
| 4 | Pruebas de compra y transacciones en conexiones remotas | Simular compras, gestionar pedidos, pagos, cancelaciones y reembolsos, verificando la trazabilidad. | 100 | 💚 Concluida |

---

## **📋 Descripción general**

Esta práctica documenta la implementación de escenarios de **E-Commerce** en la base de datos relacional **`db_test`**, mediante MySQL y conexiones remotas. Se trabaja con usuarios registrados, listas de deseos, carritos de compra, órdenes, domicilios, métodos de pago, transacciones, cancelaciones parciales y reembolsos.

El objetivo es comprobar la integridad referencial, los permisos de acceso y la trazabilidad de las operaciones realizadas por los diferentes usuarios del sistema.

## **📁 Estructura del proyecto**

Estructura de referencia para organizar los entregables de la práctica:

```text
Practica04/
├── backups/
│   └── RespaldoFinal_1811.sql        # Respaldo final de db_test
├── diagrama/                       # Atlas del diccionario de datos y modelo EER
└── readme.md                       # Documentación de la práctica
```

> Ajustar las rutas a la estructura real del repositorio si los entregables se encuentran en otras carpetas.

## **🗄️ Respaldos de la base de datos**

El respaldo final de referencia es **[RespaldoFinal_1811.sql](./backups/RespaldoFinal_1811.sql)**. Este archivo permite documentar y reproducir la estructura de la base de datos en un entorno de MySQL.

| Objeto | Cantidad de referencia |
|---|---:|
| Tablas | 25 |
| Triggers | 72 |
| Vistas | 28 |
| Roles | 7 |

Los conteos corresponden a las cantidades de referencia del proyecto y deben comprobarse directamente en el respaldo final restaurado.

> **Precaución:** revisar el contenido del respaldo antes de restaurarlo y realizar una copia de seguridad de la instancia de destino.

## **🌐 Usuarios remotos, privilegios y roles**

La práctica contempla cuentas de aplicación como `app_web` y `app_movil`, así como la asignación de permisos de acuerdo con las actividades de cada usuario.

| Rol | Función prevista |
|---|---|
| `superadmin` | Administración global. |
| `admin` | Administración de los objetos y operaciones autorizadas. |
| `seller` | Gestión de operaciones de venta y atención de pedidos. |
| `buyer` | Operaciones relacionadas con compras y pagos. |
| `support` | Atención y soporte a usuarios. |
| `common_user` | Operaciones generales de usuarios registrados. |
| `user_not_registered` | Acceso inicial y registro de usuarios. |

Los privilegios efectivos deben comprobarse mediante `SHOW GRANTS` y `CURRENT_ROLE()` desde las cuentas utilizadas durante las pruebas.

**Seguridad:** utilizar credenciales individuales, evitar publicar contraseñas y aplicar el principio de mínimo privilegio.

## **⚙️ Manipulación de datos y transacciones**

Las operaciones contempladas incluyen el registro de usuarios, la administración de listas de deseos, la creación de carritos y órdenes, el registro de pagos y el procesamiento de pedidos.

| Tabla | Propósito |
|---|---|
| `tb_users` | Información de usuarios. |
| `tb_people` | Datos personales asociados a los usuarios. |
| `tbd_users_wishlist_products` | Productos agregados a listas de deseos. |
| `tbd_carts_items` | Productos y cantidades de los carritos. |
| `tbb_orders` | Órdenes de compra. |
| `tbd_order_items` | Detalles de las órdenes. |
| `tb_payments` | Registro de pagos. |
| `tb_payment_transactions` | Transacciones asociadas a los pagos. |
| `tb_logs` | Registro de auditoría. |

Las operaciones relacionadas deben preservar la consistencia de los datos. Cuando corresponda, utilizar transacciones con `START TRANSACTION`, `COMMIT` y `ROLLBACK`.

## **🧪 Casos de prueba de E-Commerce**

### **Compra exitosa mediante conexión remota**

1. Registrar o seleccionar un usuario existente.
2. Agregar cinco productos a su lista de deseos.
3. Crear un carrito de compra.
4. Agregar productos y cantidades al carrito.
5. Generar una orden de compra.
6. Registrar un domicilio y un método de pago.
7. Registrar el pago total y su transacción.
8. Procesar la orden y comprobar su estado atendido.
9. Consultar los registros de trazabilidad correspondientes.

### **Caso de prueba 3 — Compra exitosa con cancelación parcial, ajuste y reembolso parcial**

1. Seleccionar un usuario registrado y crear un carrito con tres productos de la misma categoría, con cantidades entre 1 y 10 unidades.
2. Realizar la orden de compra.
3. Registrar un domicilio alternativo de envío, por ejemplo, `Casa Papas`.
4. Registrar una tarjeta digital simulada Spin de 16 dígitos y su relación con la tabla dependiente.
5. Registrar un único pago en efectivo por el importe total de la compra.
6. Procesar la orden y marcarla como atendida.
7. Cancelar uno de los productos del pedido.
8. Actualizar la orden y recalcular su importe.
9. Registrar el reembolso parcial correspondiente a los productos cancelados.
10. Realizar el envío de los productos restantes.
11. Registrar la recepción del pedido por el cliente.

> Los pasos representan escenarios de prueba. Su ejecución exitosa debe acreditarse mediante resultados de MySQL. Los nombres de estados y las columnas utilizadas deben corresponder al esquema real.

## **🔍 Trazabilidad y auditoría**

Los triggers y las vistas permiten analizar las operaciones realizadas en la base de datos y comprobar los cambios efectuados durante los casos de prueba.

Entre los objetos de referencia se encuentran:

- `tb_logs`: registro de operaciones de auditoría.
- `vw_trazabilidad_users_wishlist_products`: trazabilidad de listas de deseos.
- `vw_trazabilidad_carts`: trazabilidad de carritos.
- `vw_trazabilidad_carts_items`: trazabilidad de productos en carritos.

Se debe comprobar la existencia y definición de estos objetos en el respaldo final, así como la identificación del usuario, la operación y los registros afectados.

## **🧪 Consultas y pruebas de verificación**

```sql
USE db_test;

-- Total de tablas
SELECT COUNT(*) AS total_tablas
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_test'
  AND TABLE_TYPE = 'BASE TABLE';

-- Total de triggers
SELECT COUNT(*) AS total_triggers
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test';

-- Total de vistas
SELECT COUNT(*) AS total_vistas
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'db_test';

-- Vistas de trazabilidad disponibles
SELECT TABLE_NAME
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'db_test'
  AND TABLE_NAME LIKE 'vw_trazabilidad%';

-- Usuario y rol activo
SELECT CURRENT_USER(), CURRENT_ROLE();
SHOW GRANTS;

-- Total de usuarios
SELECT COUNT(*) AS total_usuarios FROM tb_users;

-- Registros de auditoría, órdenes y pagos
SELECT * FROM tb_logs LIMIT 20;
SELECT * FROM tbb_orders LIMIT 20;
SELECT * FROM tb_payments LIMIT 20;
SELECT * FROM tb_payment_transactions LIMIT 20;
```

## **📦 Datos de prueba para E-Commerce**

La base de datos utiliza usuarios y productos simulados para reproducir operaciones comerciales sin utilizar información bancaria real. Se deben verificar las cantidades de registros existentes, las categorías de productos, la disponibilidad y las relaciones entre usuarios, proveedores y productos antes de ejecutar las compras.

## **📚 Diccionario de datos y modelo EER**

La documentación de la base de datos se plantea como un **atlas integrado**, elaborado con apoyo de Codex y Archify a partir de `RespaldoFinal_1811.sql`, que reúne el diccionario de datos y el modelo entidad–relación extendido (EER) en un mismo entregable.

El atlas debe incluir:

- Inventario de tablas, atributos y tipos de datos.
- Clasificación, naturaleza, notación y dominio de los atributos.
- Claves primarias, foráneas, restricciones e índices.
- Relaciones, cardinalidades y entidades asociativas.
- Conteo de registros por tabla.
- Documentación de triggers, vistas y procedimientos existentes.
- Representación gráfica del modelo EER y resultados de validación.

**[📖 Consultar documentación en GitHub Pages](https://nataliamtz123.github.io/Practicas_BDN_240537/)**

> El enlace corresponde al sitio general del repositorio. La publicación específica del atlas de la Práctica 04 y su ruta deben verificarse en GitHub Pages.

## **✅ Evidencias y validación**

| Evidencia | Criterio de validación |
|---|---|
| Conexiones remotas | Acceso mediante usuarios autorizados. |
| Roles y privilegios | Permisos correspondientes a cada operación. |
| Carritos y órdenes | Integridad de productos, cantidades y montos. |
| Pagos y transacciones | Correspondencia entre los importes registrados. |
| Cancelación y reembolso | Ajuste del importe y conservación del historial. |
| Trazabilidad | Registros de las operaciones realizadas. |
| Respaldo final | Restauración y verificación de objetos. |
| Atlas | Correspondencia del diccionario y modelo EER con el respaldo final. |

Los resultados deben respaldarse con capturas o salidas de las consultas ejecutadas en MySQL.

---

**Repositorio:** [Practicas_BDN_240537](https://github.com/NataliaMtz123/Practicas_BDN_240537) · **Rama:** `Practica04` · **Carpeta:** `Practica04`
