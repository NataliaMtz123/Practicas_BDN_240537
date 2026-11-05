# Diccionario de datos — Respaldo_2710.sql

**Base de datos:** `db_test` · **Origen:** MySQL 8.0.36 · **Fecha:** 27 de octubre de 2026.

**Fuente:** `Practica03/backups/Respaldo_2710.sql`

**SHA-256:** `81bde410a5025feb0ecb174c3ca850db7ee0e135713bc67e9b857aa9faee556e`

## Alcance, evidencia y convenciones

Análisis estático del archivo completo, exclusivamente en lectura. No se ejecutó SQL ni se contactó a un servidor. Se conservan líneas de evidencia, DDL y cuerpos de objetos. Los propósitos comerciales, clasificación de tablas y descripciones funcionales son **inferencias**, salvo las reglas literalmente impuestas por SQL. No se reproducen datos personales. El diccionario describe el respaldo, no certifica la ejecución de una restauración.

Cada columna es monovalorada en el modelo relacional; la cardinalidad conceptual queda pendiente de validación. Un texto con varios nombres no se considera automáticamente multivalorado. DEFAULT y AUTO_INCREMENT no convierten una columna en atributo derivado. Solo GENERATED se clasifica como derivado; STORED significa además materialización física. Las categorías ENUM son nominales mientras no se demuestre un orden de negocio. Los identificadores numéricos son nominales.

La obligatoriedad deriva de NOT NULL o de pertenecer a la PK. UNIQUE compuesto garantiza la combinación, no la unicidad de cada componente; permite múltiples NULL según la semántica MySQL. NOT NULL no impide cadenas vacías. No declarado distingue ausencia de DEFAULT de DEFAULT NULL explícito. Las características de tipo y rangos describen el dominio técnico MySQL; no suponen un catálogo de negocio.

## Resumen del esquema

| Indicador | Total |
| --- | --- |
| tablas | 25 |
| columnas | 226 |
| relaciones_FK | 32 |
| indices | 65 |
| checks | 5 |
| triggers | 72 |
| vistas | 28 |
| procedimientos | 3 |
| funciones | 4 |
| filas_insertadas | 128459 |

Índices incluyen PRIMARY, UNIQUE y KEY declarados, sin contar nuevamente los utilizados por FK. Las vistas provisionales del dump no son tablas base; solo se cuentan definiciones finales. No se detectan eventos programados ni CREATE INDEX independientes.

## Inventario de tablas

| Tabla | Descripción inferida | Clasificación inferida | Grado | Filas en INSERT | Línea |
| --- | --- | --- | --- | --- | --- |
| tb_buyer_orders | Pedidos desglosados por vendedor | transaccional | 8 | 0 | 27 |
| tb_cancellations | Solicitudes de cancelación | transaccional | 11 | 0 | 169 |
| tb_carts | Carritos de usuarios | maestra/transaccional | 5 | 0 | 286 |
| tb_logs | Bitácora general de operaciones | auditoría | 7 | 64235 | 403 |
| tb_payment_methods | Pagos por tipo de instrumento | transaccional | 13 | 0 | 442 |
| tb_payment_transactions | Eventos de pago | transaccional/detalle | 7 | 0 | 565 |
| tb_payments | Pagos del pedido por vendedor | transaccional | 11 | 0 | 686 |
| tb_people | Información personal de las cuentas | maestra/detalle | 12 | 10225 | 810 |
| tb_products | Productos comercializables | maestra | 9 | 15010 | 937 |
| tb_refunds | Solicitudes de reembolso | transaccional | 15 | 0 | 1076 |
| tb_returns | Solicitudes de devolución | transaccional | 14 | 0 | 1203 |
| tb_shipments | Envíos de pedidos | transaccional | 13 | 0 | 1331 |
| tb_user_addresses | Direcciones de usuarios | maestra | 12 | 0 | 1454 |
| tb_users | Cuentas de usuarios de la aplicación | maestra | 8 | 10233 | 1708 |
| tbc_categories | Categorías jerárquicas de productos | catálogo | 7 | 100 | 1885 |
| tbc_payment_methods_types | Tipos de métodos de pago | catálogo | 6 | 0 | 2013 |
| tbd_address_components | Componentes jerárquicos de una dirección | detalle | 8 | 0 | 2140 |
| tbd_cancellation_items | Partidas de cancelación | detalle | 9 | 0 | 2328 |
| tbd_carts_items | Artículos de carrito por proveedor y producto | detalle/intermedia lógica | 5 | 0 | 2444 |
| tbd_order_items | Partidas de pedidos por vendedor | detalle | 8 | 0 | 2565 |
| tbd_products_categories | Asignación de productos a categorías | intermedia | 5 | 28656 | 2716 |
| tbd_products_users_providers | Vínculos de productos con usuarios proveedores | intermedia | 7 | 0 | 2843 |
| tbd_return_items | Partidas de devolución | detalle | 10 | 0 | 3018 |
| tbd_user_payment_methods | Instrumentos de pago de usuarios | detalle | 11 | 0 | 3139 |
| tbd_users_wishlist_products | Productos deseados por usuarios | intermedia lógica | 5 | 0 | 3311 |

Las filas son tuplas contenidas en INSERT del respaldo, contadas léxicamente respetando cadenas y escapes. Cero indica ausencia de tuplas exportadas, no una garantía sobre una base externa. AUTO_INCREMENT no es el número de filas. La cardinalidad efectiva tras restaurar no se certifica, por dependencias y triggers; no se confunde con multiplicidad entre entidades.

## tb_buyer_orders

**Nombre:** `tb_buyer_orders` · **Evidencia:** línea 27.

**Descripción general (inferida):** Pedidos desglosados por vendedor.

**Propósito de negocio (inferido):** Dar seguimiento al cumplimiento y a los importes de una parte del pedido asignada a un vendedor. El nombre buyer no determina por sí solo el comprador; la FK apunta al vendedor.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 8. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_buyer_orders(ID, order_ID, seller_ID, subtotal, shipping_cost, fulfillment_status, creation_date, last_update)`.

**Forma ordinal:** `tb_buyer_orders(A1, A2, A3, A4, A5, A6, A7, A8)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_seller_orders_seller: tb_buyer_orders (seller_ID) → tb_users (ID); véase matriz de cardinalidades; fk_cancellations_order: tb_cancellations (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_payments_buyer_orders: tb_payments (order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_returns_order: tb_returns (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_shipments_order: tb_shipments (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; tbd_order_items_ibfk_1: tbd_order_items (seller_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de pedidos desglosados por vendedor (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `order_ID` | `int unsigned` | Identificador de pedido asociado; sin FK y sin destino declarado; no asumir tb_orders (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `seller_ID` | `int unsigned` | Usuario que participa como vendedor del desglose del pedido; la FK no valida un rol comercial (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `subtotal` | `decimal(12,2)` | Importe parcial del desglose o de la partida; moneda y tratamiento fiscal no determinados (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. Sin CHECK aplicable declarado. |
| A5 | `shipping_cost` | `decimal(12,2)` | Costo de envío asignado al desglose por vendedor; moneda no determinada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. Sin CHECK aplicable declarado. |
| A6 | `fulfillment_status` | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')` | Estado de cumplimiento del pedido por vendedor; los literales constan en el tipo ENUM, sin reglas de transición (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Pending'. Sin CHECK aplicable declarado. |
| A7 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A8 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `order_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `seller_ID` | `No declarado` | fk_seller_orders_seller: (seller_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `subtotal` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL DEFAULT '0.00'` |
| A5 / D5 | `shipping_cost` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL DEFAULT '0.00'` |
| A6 / D6 | `fulfillment_status` | `'Pending'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending'` |
| A7 / D7 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A8 / D8 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| fk_seller_orders_seller | INDEX | ['seller_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_buyer_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `seller_ID` int unsigned NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fulfillment_status` enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `fk_seller_orders_seller` (`seller_ID`),
  CONSTRAINT `fk_seller_orders_seller` FOREIGN KEY (`seller_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_cancellations

**Nombre:** `tb_cancellations` · **Evidencia:** línea 169.

**Descripción general (inferida):** Solicitudes de cancelación.

**Propósito de negocio (inferido):** Gestionar solicitudes de cancelación asociadas a un pedido por vendedor y a un usuario.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 11. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_cancellations(ID, buyer_order_ID, user_ID, cancellation_reason, cancellation_status, requested_date, resolved_date, resolution_notes, status, creation_date, last_update)`.

**Forma ordinal:** `tb_cancellations(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_cancellations_order: tb_cancellations (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_cancellations_user: tb_cancellations (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_refunds_cancellation: tb_refunds (cancellation_ID) → tb_cancellations (ID); véase matriz de cardinalidades; fk_cancellation_items_cancellation: tbd_cancellation_items (cancellation_ID) → tb_cancellations (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de solicitudes de cancelación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `buyer_order_ID` | `int unsigned` | Pedido por vendedor al que se vincula el registro (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `cancellation_reason` | `varchar(500)` | Motivo declarado de la cancelación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `cancellation_status` | `enum('Requested','Approved','Rejected','Completed')` | Estado del proceso de cancellation según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Requested','Approved','Rejected','Completed'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Requested'. Sin CHECK aplicable declarado. |
| A6 | `requested_date` | `datetime` | Momento de solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A7 | `resolved_date` | `datetime` | Momento de resolución (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `resolution_notes` | `text` | Observaciones sobre la resolución de la solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A9 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A10 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A11 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `buyer_order_ID` | `No declarado` | fk_cancellations_order: (buyer_order_ID) → tb_buyer_orders (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `user_ID` | `No declarado` | fk_cancellations_user: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `cancellation_reason` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `cancellation_status` | `'Requested'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Requested','Approved','Rejected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested'` |
| A6 / D6 | `requested_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A7 / D7 | `resolved_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A8 / D8 | `resolution_notes` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A9 / D9 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A10 / D10 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A11 / D11 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_cancellation_order | INDEX | ['buyer_order_ID'] |
| idx_cancellation_user | INDEX | ['user_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_cancellations` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `user_ID` int unsigned NOT NULL,
  `cancellation_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cancellation_status` enum('Requested','Approved','Rejected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_cancellation_order` (`buyer_order_ID`),
  KEY `idx_cancellation_user` (`user_ID`),
  CONSTRAINT `fk_cancellations_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_cancellations_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_carts

**Nombre:** `tb_carts` · **Evidencia:** línea 286.

**Descripción general (inferida):** Carritos de usuarios.

**Propósito de negocio (inferido):** Conservar un carrito por usuario como máximo y servir de cabecera lógica para sus artículos.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** maestra/transaccional.

**Grado:** 5. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_carts(ID, user_ID, status, creation_date, last_update)`.

**Forma ordinal:** `tb_carts(A1, A2, A3, A4, A5)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** tb_carts_ibfk_1: tb_carts (user_ID) → tb_users (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de carritos de usuarios (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK, UNIQUE (uk_cart_user: user_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK, UNIQUE (uk_cart_user: user_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | 1 bit; 0 a 1. NULL permitido. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A4 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A5 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `user_ID` | `No declarado` | tb_carts_ibfk_1: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) DEFAULT b'1'` |
| A4 / D4 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A5 / D5 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| uk_cart_user | UNIQUE | ['user_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned NOT NULL,
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_cart_user` (`user_ID`),
  CONSTRAINT `tb_carts_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_logs

**Nombre:** `tb_logs` · **Evidencia:** línea 403.

**Descripción general (inferida):** Bitácora general de operaciones.

**Propósito de negocio (inferido):** Registrar operaciones y la cuenta de conexión que las realizó; soportar las consultas de trazabilidad.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** auditoría.

**Grado:** 7. **Cardinalidad de datos exportados:** 64235 tuplas.

**Esquema formal:** `tb_logs(ID, table_name, operation, db_users, description, operation_date, operation_status)`.

**Forma ordinal:** `tb_logs(A1, A2, A3, A4, A5, A6, A7)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** ninguna.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int` | Identificador que distingue cada registro de bitácora general de operaciones (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango -2147483648 a 2147483647. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `table_name` | `varchar(100)` | Nombre textual de la tabla afectada por la operación de bitácora (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 100 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `operation` | `enum('Create','Read','Update','Delete')` | Clase de operación de bitácora entre Create, Read, Update y Delete; no demuestra que todas sean capturadas automáticamente (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Create','Read','Update','Delete'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `db_users` | `varchar(80)` | Cuenta de conexión a MySQL asociada a la operación; distinta de una FK a usuarios de la aplicación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 80 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `description` | `text` | Texto descriptivo de bitácora general de operaciones (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `operation_date` | `datetime` | Momento en que se registra la operación en la bitácora (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A7 | `operation_status` | `bit(1)` | Indicador asociado al resultado o estado de la operación auditada; convención completa no determinada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | 1 bit; 0 a 1. NULL permitido. DEFAULT b'1'. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `table_name` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A3 / D3 | `operation` | `No declarado` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Create','Read','Update','Delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `db_users` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `description` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A6 / D6 | `operation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A7 / D7 | `operation_status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) DEFAULT b'1'` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `operation` enum('Create','Read','Update','Delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `db_users` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=64240 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_payment_methods

**Nombre:** `tb_payment_methods` · **Evidencia:** línea 442.

**Descripción general (inferida):** Pagos por tipo de instrumento.

**Propósito de negocio (inferido):** Registrar importe, usuario, tipo de instrumento y seguimiento del pago; su coexistencia con tb_payments requiere validación funcional.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 13. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_payment_methods(ID, order_ID, user_ID, payment_method_type_ID, payment_reference, amount, currency, payment_status, payment_date, notes, status, creation_date, last_update)`.

**Forma ordinal:** `tb_payment_methods(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_payment_methods_type: tb_payment_methods (payment_method_type_ID) → tbc_payment_methods_types (ID); véase matriz de cardinalidades; fk_payment_methods_user: tb_payment_methods (user_ID) → tb_users (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. CONSTRAINT `chk_payment_methods_amount` CHECK ((`amount` > 0)) No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de pagos por tipo de instrumento (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `order_ID` | `int unsigned` | Identificador de pedido asociado; sin FK y sin destino declarado; no asumir tb_orders (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `payment_method_type_ID` | `int unsigned` | Tipo de método que clasifica el instrumento de pago del usuario (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `payment_reference` | `varchar(150)` | Referencia textual del pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A6 | `amount` | `decimal(12,2)` | Importe de la operación; alcance fiscal y conciliación pendientes (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT No declarado. CONSTRAINT `chk_payment_methods_amount` CHECK ((`amount` > 0)) |
| A7 | `currency` | `char(3)` | Código de moneda; MXN es el valor predeterminado, no un catálogo cerrado ni validación ISO (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 3 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT 'MXN'. Sin CHECK aplicable declarado. |
| A8 | `payment_status` | `enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded')` | Estado del proceso de payment según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Pending'. Sin CHECK aplicable declarado. |
| A9 | `payment_date` | `datetime` | Momento del pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A10 | `notes` | `text` | Notas descriptivas de la operación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A11 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A12 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A13 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `order_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `user_ID` | `No declarado` | fk_payment_methods_user: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `payment_method_type_ID` | `No declarado` | fk_payment_methods_type: (payment_method_type_ID) → tbc_payment_methods_types (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A5 / D5 | `payment_reference` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) DEFAULT NULL` |
| A6 / D6 | `amount` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL` |
| A7 / D7 | `currency` | `'MXN'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `char(3) NOT NULL DEFAULT 'MXN'` |
| A8 / D8 | `payment_status` | `'Pending'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded') NOT NULL DEFAULT 'Pending'` |
| A9 / D9 | `payment_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A10 / D10 | `notes` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text` |
| A11 / D11 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A12 / D12 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A13 / D13 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_payment_methods_order | INDEX | ['order_ID'] |
| idx_payment_methods_user | INDEX | ['user_ID'] |
| idx_payment_methods_type | INDEX | ['payment_method_type_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_payment_methods` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `user_ID` int unsigned NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `payment_reference` varchar(150) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'MXN',
  `payment_status` enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded') NOT NULL DEFAULT 'Pending',
  `payment_date` datetime DEFAULT NULL,
  `notes` text,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_payment_methods_order` (`order_ID`),
  KEY `idx_payment_methods_user` (`user_ID`),
  KEY `idx_payment_methods_type` (`payment_method_type_ID`),
  CONSTRAINT `fk_payment_methods_type` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`),
  CONSTRAINT `fk_payment_methods_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `chk_payment_methods_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_payment_transactions

**Nombre:** `tb_payment_transactions` · **Evidencia:** línea 565.

**Descripción general (inferida):** Eventos de pago.

**Propósito de negocio (inferido):** Conservar eventos e importes asociados a un pago.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional/detalle.

**Grado:** 7. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_payment_transactions(ID, payment_ID, event_type, amount, event_reference, remarks, creation_date)`.

**Forma ordinal:** `tb_payment_transactions(A1, A2, A3, A4, A5, A6, A7)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_transactions_payments: tb_payment_transactions (payment_ID) → tb_payments (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de eventos de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `payment_ID` | `int unsigned` | Pago al que corresponde el evento o reintegro (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `event_type` | `enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded')` | Categoría del evento de pago; no implica un orden estadístico (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `amount` | `decimal(12,2)` | Importe de la operación; alcance fiscal y conciliación pendientes (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `event_reference` | `varchar(150)` | Referencia externa del evento de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A6 | `remarks` | `text` | Observaciones del evento (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A7 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `payment_ID` | `No declarado` | fk_transactions_payments: (payment_ID) → tb_payments (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `event_type` | `No declarado` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `amount` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL` |
| A5 / D5 | `event_reference` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A6 / D6 | `remarks` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A7 / D7 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| fk_transactions_payments | INDEX | ['payment_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_payment_transactions` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `event_type` enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `event_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `fk_transactions_payments` (`payment_ID`),
  CONSTRAINT `fk_transactions_payments` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_payments

**Nombre:** `tb_payments` · **Evidencia:** línea 686.

**Descripción general (inferida):** Pagos del pedido por vendedor.

**Propósito de negocio (inferido):** Gestionar cobros y referencias de proveedor asociados a tb_buyer_orders.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 11. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_payments(ID, order_ID, amount, currency, payment_method, provider, provider_reference, payment_status, creation_date, paid_date, last_update)`.

**Forma ordinal:** `tb_payments(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_transactions_payments: tb_payment_transactions (payment_ID) → tb_payments (ID); véase matriz de cardinalidades; fk_payments_buyer_orders: tb_payments (order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_refunds_payment: tb_refunds (payment_ID) → tb_payments (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de pagos del pedido por vendedor (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `order_ID` | `int unsigned` | Identificador de pedido asociado; FK a tb_buyer_orders.ID (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `amount` | `decimal(12,2)` | Importe de la operación; alcance fiscal y conciliación pendientes (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `currency` | `char(3)` | Código de moneda; MXN es el valor predeterminado, no un catálogo cerrado ni validación ISO (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 3 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT 'MXN'. Sin CHECK aplicable declarado. |
| A5 | `payment_method` | `enum('Card','SPEI','Transfer','Cash')` | Modalidad de pago elegida dentro del ENUM (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Card','SPEI','Transfer','Cash'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `provider` | `varchar(50)` | Nombre o código del proveedor que gestiona el instrumento de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; UNIQUE (uk_payment_reference: provider, provider_reference) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_payment_reference: provider, provider_reference) | Sí | Máximo 50 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `provider_reference` | `varchar(150)` | Referencia externa asignada por el proveedor (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; UNIQUE (uk_payment_reference: provider, provider_reference) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_payment_reference: provider, provider_reference) | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `payment_status` | `enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded')` | Estado del proceso de payment según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Pending'. Sin CHECK aplicable declarado. |
| A9 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A10 | `paid_date` | `datetime` | Momento en que se registra el pago como realizado (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A11 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `order_ID` | `No declarado` | fk_payments_buyer_orders: (order_ID) → tb_buyer_orders (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `amount` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL` |
| A4 / D4 | `currency` | `'MXN'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN'` |
| A5 / D5 | `payment_method` | `No declarado` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Card','SPEI','Transfer','Cash') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A6 / D6 | `provider` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A7 / D7 | `provider_reference` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A8 / D8 | `payment_status` | `'Pending'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending'` |
| A9 / D9 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A10 / D10 | `paid_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A11 / D11 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| uk_payment_reference | UNIQUE | ['provider', 'provider_reference'] |
| fk_payments_buyer_orders | INDEX | ['order_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_payments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN',
  `payment_method` enum('Card','SPEI','Transfer','Cash') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `provider_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `payment_status` enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid_date` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_payment_reference` (`provider`,`provider_reference`),
  KEY `fk_payments_buyer_orders` (`order_ID`),
  CONSTRAINT `fk_payments_buyer_orders` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_people

**Nombre:** `tb_people` · **Evidencia:** línea 810.

**Descripción general (inferida):** Información personal de las cuentas.

**Propósito de negocio (inferido):** Ampliar cada cuenta con un perfil personal opcional y como máximo uno por usuario.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (person_ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** maestra/detalle.

**Grado:** 12. **Cardinalidad de datos exportados:** 10225 tuplas.

**Esquema formal:** `tb_people(person_ID, user_ID, courtesy_title, given_names, family_names, birth_date, gender_ID, country_code, phone, status, creation_date, last_update)`.

**Forma ordinal:** `tb_people(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_persons_user: tb_people (user_ID) → tb_users (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `person_ID` | `bigint unsigned` | Identificador del perfil personal (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: person_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: person_ID) | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK, UNIQUE (uk_persons_user: user_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK, UNIQUE (uk_persons_user: user_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `courtesy_title` | `varchar(50)` | Tratamiento de cortesía de la persona (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 50 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A4 | `given_names` | `varchar(150)` | Nombres de pila de la persona (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `family_names` | `varchar(150)` | Apellidos de la persona (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A6 | `birth_date` | `date` | Fecha de nacimiento declarada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; día). No es conteo ni categoría nominal. | No | Sí | DATE, resolución de día; rango ordinario 1000-01-01 a 9999-12-31; fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `gender_ID` | `tinyint unsigned` | Código de género sin catálogo ni FK declarados (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | No | Sí | 8 bits; rango 0 a 255. El ancho entre paréntesis, si existe, no restringe el rango. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `country_code` | `char(2)` | Código de país de dos caracteres; no se impone estándar ISO (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 2 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A9 | `phone` | `varchar(25)` | Teléfono de contacto sin validación de formato (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 25 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A10 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A11 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A12 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `person_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `user_ID` | `No declarado` | fk_persons_user: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `courtesy_title` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A4 / D4 | `given_names` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `family_names` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A6 / D6 | `birth_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `date DEFAULT NULL` |
| A7 / D7 | `gender_ID` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `tinyint unsigned DEFAULT NULL` |
| A8 / D8 | `country_code` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A9 / D9 | `phone` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A10 / D10 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A11 / D11 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A12 / D12 | `last_update` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['person_ID'] |
| uk_persons_user | UNIQUE | ['user_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_people` (
  `person_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned NOT NULL,
  `courtesy_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `given_names` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `family_names` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender_ID` tinyint unsigned DEFAULT NULL,
  `country_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`person_ID`),
  UNIQUE KEY `uk_persons_user` (`user_ID`),
  CONSTRAINT `fk_persons_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10229 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_products

**Nombre:** `tb_products` · **Evidencia:** línea 937.

**Descripción general (inferida):** Productos comercializables.

**Propósito de negocio (inferido):** Mantener la descripción comercial, SKU, precio y existencias actuales de cada producto.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** maestra.

**Grado:** 9. **Cardinalidad de datos exportados:** 15010 tuplas.

**Esquema formal:** `tb_products(ID, SKU, name, description, current_price, current_stock, status, creation_date, last_update)`.

**Forma ordinal:** `tb_products(A1, A2, A3, A4, A5, A6, A7, A8, A9)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_product: tbd_products_categories (product_ID) → tb_products (ID); véase matriz de cardinalidades; fk_products2: tbd_products_users_providers (product_ID) → tb_products (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de productos comercializables (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `SKU` | `varchar(50)` | Código comercial que distingue de forma única cada producto (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (SKU: SKU) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (SKU: SKU) | No | Máximo 50 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `name` | `varchar(250)` | Nombre visible de productos comercializables (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 250 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `description` | `text` | Texto descriptivo de productos comercializables (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `current_price` | `decimal(10,2)` | Precio actual del producto; moneda, impuestos y vigencia comercial no determinados (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 10, escala 2; rango -99999999.99 a 99999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. Sin CHECK aplicable declarado. |
| A6 | `current_stock` | `int unsigned` | Cantidad de existencias actuales del producto; unidad de medida no determinada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '0'. Sin CHECK aplicable declarado. |
| A7 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | 1 bit; 0 a 1. NULL permitido. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A8 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A9 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `SKU` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A3 / D3 | `name` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `description` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A5 / D5 | `current_price` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(10,2) NOT NULL DEFAULT '0.00'` |
| A6 / D6 | `current_stock` | `'0'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL DEFAULT '0'` |
| A7 / D7 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) DEFAULT b'1'` |
| A8 / D8 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A9 / D9 | `last_update` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| SKU | UNIQUE | ['SKU'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=24585 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_refunds

**Nombre:** `tb_refunds` · **Evidencia:** línea 1076.

**Descripción general (inferida):** Solicitudes de reembolso.

**Propósito de negocio (inferido):** Registrar reintegros asociados a pagos y, opcionalmente, a cancelaciones o devoluciones.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 15. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_refunds(ID, payment_ID, cancellation_ID, return_ID, amount, currency, refund_reason, refund_status, provider_reference, requested_date, processed_date, resolution_notes, status, creation_date, last_update)`.

**Forma ordinal:** `tb_refunds(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_refunds_cancellation: tb_refunds (cancellation_ID) → tb_cancellations (ID); véase matriz de cardinalidades; fk_refunds_payment: tb_refunds (payment_ID) → tb_payments (ID); véase matriz de cardinalidades; fk_refunds_return: tb_refunds (return_ID) → tb_returns (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de solicitudes de reembolso (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `payment_ID` | `int unsigned` | Pago al que corresponde el evento o reintegro (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `cancellation_ID` | `int unsigned` | Solicitud de cancelación vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | Sí | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A4 | `return_ID` | `int unsigned` | Solicitud de devolución vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | Sí | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A5 | `amount` | `decimal(12,2)` | Importe de la operación; alcance fiscal y conciliación pendientes (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `currency` | `char(3)` | Código de moneda; MXN es el valor predeterminado, no un catálogo cerrado ni validación ISO (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 3 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT 'MXN'. Sin CHECK aplicable declarado. |
| A7 | `refund_reason` | `varchar(500)` | Motivo declarado del reembolso (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A8 | `refund_status` | `enum('Requested','Approved','Processing','Completed','Rejected','Failed')` | Estado del proceso de refund según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Requested','Approved','Processing','Completed','Rejected','Failed'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Requested'. Sin CHECK aplicable declarado. |
| A9 | `provider_reference` | `varchar(150)` | Referencia externa asignada por el proveedor (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A10 | `requested_date` | `datetime` | Momento de solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A11 | `processed_date` | `datetime` | Momento de procesamiento (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A12 | `resolution_notes` | `text` | Observaciones sobre la resolución de la solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A13 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A14 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A15 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `payment_ID` | `No declarado` | fk_refunds_payment: (payment_ID) → tb_payments (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `cancellation_ID` | `NULL` | fk_refunds_cancellation: (cancellation_ID) → tb_cancellations (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned DEFAULT NULL` |
| A4 / D4 | `return_ID` | `NULL` | fk_refunds_return: (return_ID) → tb_returns (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned DEFAULT NULL` |
| A5 / D5 | `amount` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL` |
| A6 / D6 | `currency` | `'MXN'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN'` |
| A7 / D7 | `refund_reason` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A8 / D8 | `refund_status` | `'Requested'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Requested','Approved','Processing','Completed','Rejected','Failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested'` |
| A9 / D9 | `provider_reference` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A10 / D10 | `requested_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A11 / D11 | `processed_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A12 / D12 | `resolution_notes` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A13 / D13 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A14 / D14 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A15 / D15 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_refund_payment | INDEX | ['payment_ID'] |
| idx_refund_cancellation | INDEX | ['cancellation_ID'] |
| idx_refund_return | INDEX | ['return_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_refunds` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `cancellation_ID` int unsigned DEFAULT NULL,
  `return_ID` int unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `refund_status` enum('Requested','Approved','Processing','Completed','Rejected','Failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `provider_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_refund_payment` (`payment_ID`),
  KEY `idx_refund_cancellation` (`cancellation_ID`),
  KEY `idx_refund_return` (`return_ID`),
  CONSTRAINT `fk_refunds_cancellation` FOREIGN KEY (`cancellation_ID`) REFERENCES `tb_cancellations` (`ID`),
  CONSTRAINT `fk_refunds_payment` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`),
  CONSTRAINT `fk_refunds_return` FOREIGN KEY (`return_ID`) REFERENCES `tb_returns` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_returns

**Nombre:** `tb_returns` · **Evidencia:** línea 1203.

**Descripción general (inferida):** Solicitudes de devolución.

**Propósito de negocio (inferido):** Gestionar devolución de unidades, pedido, partida y usuario solicitante.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 14. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_returns(ID, buyer_order_ID, order_item_ID, user_ID, quantity, return_reason, return_status, requested_date, received_date, resolved_date, resolution_notes, status, creation_date, last_update)`.

**Forma ordinal:** `tb_returns(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_refunds_return: tb_refunds (return_ID) → tb_returns (ID); véase matriz de cardinalidades; fk_returns_item: tb_returns (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades; fk_returns_order: tb_returns (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_returns_user: tb_returns (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_return_items_return: tbd_return_items (return_ID) → tb_returns (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de solicitudes de devolución (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `buyer_order_ID` | `int unsigned` | Pedido por vendedor al que se vincula el registro (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `order_item_ID` | `int unsigned` | Partida del pedido vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `quantity` | `int unsigned` | Cantidad de unidades del producto incluidas en el carrito o partida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '1'. Sin CHECK aplicable declarado. |
| A6 | `return_reason` | `varchar(500)` | Motivo declarado de la devolución (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A7 | `return_status` | `enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed')` | Estado del proceso de return según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Requested'. Sin CHECK aplicable declarado. |
| A8 | `requested_date` | `datetime` | Momento de solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A9 | `received_date` | `datetime` | Momento de recepción (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A10 | `resolved_date` | `datetime` | Momento de resolución (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A11 | `resolution_notes` | `text` | Observaciones sobre la resolución de la solicitud (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A12 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A13 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A14 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `buyer_order_ID` | `No declarado` | fk_returns_order: (buyer_order_ID) → tb_buyer_orders (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `order_item_ID` | `No declarado` | fk_returns_item: (order_item_ID) → tbd_order_items (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `user_ID` | `No declarado` | fk_returns_user: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A5 / D5 | `quantity` | `'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL DEFAULT '1'` |
| A6 / D6 | `return_reason` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A7 / D7 | `return_status` | `'Requested'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested'` |
| A8 / D8 | `requested_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A9 / D9 | `received_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A10 / D10 | `resolved_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A11 / D11 | `resolution_notes` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A12 / D12 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A13 / D13 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A14 / D14 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_return_order | INDEX | ['buyer_order_ID'] |
| idx_return_item | INDEX | ['order_item_ID'] |
| idx_return_user | INDEX | ['user_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_returns` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `user_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `return_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `return_status` enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `received_date` datetime DEFAULT NULL,
  `resolved_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_return_order` (`buyer_order_ID`),
  KEY `idx_return_item` (`order_item_ID`),
  KEY `idx_return_user` (`user_ID`),
  CONSTRAINT `fk_returns_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`),
  CONSTRAINT `fk_returns_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_returns_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_shipments

**Nombre:** `tb_shipments` · **Evidencia:** línea 1331.

**Descripción general (inferida):** Envíos de pedidos.

**Propósito de negocio (inferido):** Dar seguimiento a transportista, guía, dirección y entrega de un pedido por vendedor.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** transaccional.

**Grado:** 13. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_shipments(ID, buyer_order_ID, address_ID, carrier, tracking_number, shipping_cost, shipment_status, shipped_date, estimated_delivery_date, delivered_date, status, creation_date, last_update)`.

**Forma ordinal:** `tb_shipments(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_shipments_address: tb_shipments (address_ID) → tb_user_addresses (ID); véase matriz de cardinalidades; fk_shipments_order: tb_shipments (buyer_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de envíos de pedidos (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `buyer_order_ID` | `int unsigned` | Pedido por vendedor al que se vincula el registro (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `address_ID` | `bigint unsigned` | Dirección de destino del envío, referenciada en tb_user_addresses.ID (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `carrier` | `varchar(100)` | Nombre o código del transportista (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; UNIQUE (uk_shipment_tracking: carrier, tracking_number) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_shipment_tracking: carrier, tracking_number) | Sí | Máximo 100 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A5 | `tracking_number` | `varchar(150)` | Número o referencia de seguimiento del envío (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; UNIQUE (uk_shipment_tracking: carrier, tracking_number) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_shipment_tracking: carrier, tracking_number) | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A6 | `shipping_cost` | `decimal(12,2)` | Costo de envío asignado al desglose por vendedor; moneda no determinada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. Sin CHECK aplicable declarado. |
| A7 | `shipment_status` | `enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned')` | Estado del proceso de shipment según los literales ENUM; no declara transiciones ni un orden estadístico total (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Pending'. Sin CHECK aplicable declarado. |
| A8 | `shipped_date` | `datetime` | Momento de despacho (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A9 | `estimated_delivery_date` | `datetime` | Fecha y hora estimadas para entrega (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A10 | `delivered_date` | `datetime` | Momento de entrega (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A11 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A12 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A13 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `buyer_order_ID` | `No declarado` | fk_shipments_order: (buyer_order_ID) → tb_buyer_orders (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `address_ID` | `No declarado` | fk_shipments_address: (address_ID) → tb_user_addresses (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL` |
| A4 / D4 | `carrier` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A5 / D5 | `tracking_number` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A6 / D6 | `shipping_cost` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL DEFAULT '0.00'` |
| A7 / D7 | `shipment_status` | `'Pending'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending'` |
| A8 / D8 | `shipped_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A9 / D9 | `estimated_delivery_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A10 / D10 | `delivered_date` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A11 / D11 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A12 / D12 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A13 / D13 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| uk_shipment_tracking | UNIQUE | ['carrier', 'tracking_number'] |
| idx_shipment_order | INDEX | ['buyer_order_ID'] |
| idx_shipment_address | INDEX | ['address_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_shipments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `address_ID` bigint unsigned NOT NULL,
  `carrier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tracking_number` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipment_status` enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `shipped_date` datetime DEFAULT NULL,
  `estimated_delivery_date` datetime DEFAULT NULL,
  `delivered_date` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_shipment_tracking` (`carrier`,`tracking_number`),
  KEY `idx_shipment_order` (`buyer_order_ID`),
  KEY `idx_shipment_address` (`address_ID`),
  CONSTRAINT `fk_shipments_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`),
  CONSTRAINT `fk_shipments_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_user_addresses

**Nombre:** `tb_user_addresses` · **Evidencia:** línea 1454.

**Descripción general (inferida):** Direcciones de usuarios.

**Propósito de negocio (inferido):** Administrar destinos de entrega, destinatario y coordenadas asociados a una cuenta.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** maestra.

**Grado:** 12. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tb_user_addresses(ID, user_ID, address_label, recipient_name, recipient_phone, delivery_instructions, latitude, longitude, is_default, status, creation_date, last_update)`.

**Forma ordinal:** `tb_user_addresses(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_shipments_address: tb_shipments (address_ID) → tb_user_addresses (ID); véase matriz de cardinalidades; fk_addresses_user: tb_user_addresses (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_component_address: tbd_address_components (address_ID) → tb_user_addresses (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `bigint unsigned` | Identificador que distingue cada registro de direcciones de usuarios (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `address_label` | `varchar(100)` | Etiqueta reconocible por el usuario para distinguir una dirección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 100 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `recipient_name` | `varchar(150)` | Nombre del destinatario de la entrega en esta dirección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 150 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A5 | `recipient_phone` | `varchar(25)` | Teléfono de contacto del destinatario; se conserva como texto sin validación de formato (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 25 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A6 | `delivery_instructions` | `varchar(500)` | Indicaciones de entrega asociadas a la dirección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `latitude` | `decimal(10,7)` | Coordenada de latitud propuesta para la dirección; no existe CHECK que imponga el intervalo geográfico (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cuantitativa continua (inferencia funcional): coordenada medida y discretizada por la escala SQL. | No | Sí | Precisión 10, escala 7; rango -999.9999999 a 999.9999999; decimal exacto. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `longitude` | `decimal(10,7)` | Coordenada de longitud propuesta para la dirección; no existe CHECK que imponga el intervalo geográfico (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cuantitativa continua (inferencia funcional): coordenada medida y discretizada por la escala SQL. | No | Sí | Precisión 10, escala 7; rango -999.9999999 a 999.9999999; decimal exacto. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A9 | `is_default` | `tinyint(1)` | Indicador propuesto de selección predeterminada de dirección o método de pago; 0 y 1 no están limitados mediante CHECK (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 8 bits; rango -128 a 127. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '0'. Sin CHECK aplicable declarado. |
| A10 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A11 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A12 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `user_ID` | `No declarado` | fk_addresses_user: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `address_label` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `recipient_name` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A5 / D5 | `recipient_phone` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A6 / D6 | `delivery_instructions` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A7 / D7 | `latitude` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(10,7) DEFAULT NULL` |
| A8 / D8 | `longitude` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(10,7) DEFAULT NULL` |
| A9 / D9 | `is_default` | `'0'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `tinyint(1) NOT NULL DEFAULT '0'` |
| A10 / D10 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A11 / D11 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A12 / D12 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_user_addresses | INDEX | ['user_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_user_addresses` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned NOT NULL,
  `address_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `recipient_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `recipient_phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `delivery_instructions` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_user_addresses` (`user_ID`),
  CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tb_users

**Nombre:** `tb_users` · **Evidencia:** línea 1708.

**Descripción general (inferida):** Cuentas de usuarios de la aplicación.

**Propósito de negocio (inferido):** Mantener identidad de acceso y estado de cuentas que participan en carritos, direcciones y provisión de productos.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** maestra.

**Grado:** 8. **Cardinalidad de datos exportados:** 10233 tuplas.

**Esquema formal:** `tb_users(ID, email, nick, password, creation_date, last_update, last_login, status)`.

**Forma ordinal:** `tb_users(A1, A2, A3, A4, A5, A6, A7, A8)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_seller_orders_seller: tb_buyer_orders (seller_ID) → tb_users (ID); véase matriz de cardinalidades; fk_cancellations_user: tb_cancellations (user_ID) → tb_users (ID); véase matriz de cardinalidades; tb_carts_ibfk_1: tb_carts (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_payment_methods_user: tb_payment_methods (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_persons_user: tb_people (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_returns_user: tb_returns (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_addresses_user: tb_user_addresses (user_ID) → tb_users (ID); véase matriz de cardinalidades; fk_user1: tbd_products_users_providers (user_ID) → tb_users (ID); véase matriz de cardinalidades; tbd_user_payment_methods_ibfk_1: tbd_user_payment_methods (user_ID) → tb_users (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de cuentas de usuarios de la aplicación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `email` | `varchar(80)` | Dirección de correo utilizada para distinguir la cuenta de usuario; no se valida su sintaxis (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (email: email) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (email: email) | No | Máximo 80 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `nick` | `varchar(100)` | Alias único de la cuenta de usuario (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (nickname: nick) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (nickname: nick) | No | Máximo 100 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `password` | `varchar(255)` | Representación de credencial: sp_register_user escribe MD5(p_password) y sp_generar_usuarios_masivos escribe SHA2(...,256); no se impone un algoritmo único a todos los registros (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 255 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A6 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A7 | `last_login` | `datetime` | Momento registrado del último acceso de la cuenta; no hay actualización automática declarada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `email` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A3 / D3 | `nick` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `password` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A6 / D6 | `last_update` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |
| A7 / D7 | `last_login` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL` |
| A8 / D8 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| email | UNIQUE | ['email'] |
| nickname | UNIQUE | ['nick'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tb_users` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nick` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=10249 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbc_categories

**Nombre:** `tbc_categories` · **Evidencia:** línea 1885.

**Descripción general (inferida):** Categorías jerárquicas de productos.

**Propósito de negocio (inferido):** Organizar productos en categorías con una categoría superior opcional.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** catálogo.

**Grado:** 7. **Cardinalidad de datos exportados:** 100 tuplas.

**Esquema formal:** `tbc_categories(ID, name, description, sup_id_category, status, creation_date, last_update)`.

**Forma ordinal:** `tbc_categories(A1, A2, A3, A4, A5, A6, A7)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_superior_category: tbc_categories (sup_id_category) → tbc_categories (ID); véase matriz de cardinalidades; fk_category: tbd_products_categories (category_ID) → tbc_categories (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de categorías jerárquicas de productos (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `name` | `varchar(120)` | Nombre visible de categorías jerárquicas de productos (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (name: name) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (name: name) | No | Máximo 120 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `description` | `text` | Texto descriptivo de categorías jerárquicas de productos (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `sup_id_category` | `int unsigned` | Categoría superior opcional que estructura la jerarquía del catálogo (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | Sí | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A5 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A6 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A7 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `name` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A3 / D3 | `description` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci` |
| A4 / D4 | `sup_id_category` | `NULL` | fk_superior_category: (sup_id_category) → tbc_categories (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned DEFAULT NULL` |
| A5 / D5 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A6 / D6 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A7 / D7 | `last_update` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| name | UNIQUE | ['name'] |
| fk_superior_category | INDEX | ['sup_id_category'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbc_categories` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sup_id_category` int unsigned DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_superior_category` (`sup_id_category`),
  CONSTRAINT `fk_superior_category` FOREIGN KEY (`sup_id_category`) REFERENCES `tbc_categories` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbc_payment_methods_types

**Nombre:** `tbc_payment_methods_types` · **Evidencia:** línea 2013.

**Descripción general (inferida):** Tipos de métodos de pago.

**Propósito de negocio (inferido):** Clasificar los instrumentos de pago registrados por los usuarios mediante códigos únicos.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** catálogo.

**Grado:** 6. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbc_payment_methods_types(ID, code, description, status, creation_date, last_update)`.

**Forma ordinal:** `tbc_payment_methods_types(A1, A2, A3, A4, A5, A6)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_payment_methods_type: tb_payment_methods (payment_method_type_ID) → tbc_payment_methods_types (ID); véase matriz de cardinalidades; tbd_user_payment_methods_ibfk_2: tbd_user_payment_methods (payment_method_type_ID) → tbc_payment_methods_types (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de tipos de métodos de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `code` | `varchar(30)` | Código único que identifica un tipo de método de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (code_UNIQUE: code) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (code_UNIQUE: code) | No | Máximo 30 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `description` | `text` | Texto descriptivo de tipos de métodos de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | TEXT: hasta 65 535 bytes; caracteres efectivos dependen de codificación utf8mb4; cotejamiento utf8mb4_0900_ai_ci. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A5 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A6 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `code` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A3 / D3 | `description` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A5 / D5 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A6 / D6 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| code_UNIQUE | UNIQUE | ['code'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbc_payment_methods_types` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_address_components

**Nombre:** `tbd_address_components` · **Evidencia:** línea 2140.

**Descripción general (inferida):** Componentes jerárquicos de una dirección.

**Propósito de negocio (inferido):** Descomponer direcciones en componentes tipificados y organizar su jerarquía dentro de la misma dirección.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle.

**Grado:** 8. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_address_components(ID, address_ID, value, component_type, status, address_sup_ID, creation_date, last_update)`.

**Forma ordinal:** `tbd_address_components(A1, A2, A3, A4, A5, A6, A7, A8)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_component_address: tbd_address_components (address_ID) → tb_user_addresses (ID); véase matriz de cardinalidades; fk_component_parent: tbd_address_components (address_ID, address_sup_ID) → tbd_address_components (address_ID, ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `bigint unsigned` | Identificador que distingue cada registro de componentes jerárquicos de una dirección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID; uk_address_component: address_ID, ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID; uk_address_component: address_ID, ID) | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `address_ID` | `bigint unsigned` | Dirección a la que pertenece el componente (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK, UNIQUE (uk_address_component: address_ID, ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK, UNIQUE (uk_address_component: address_ID, ID) | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `value` | `varchar(255)` | Contenido textual del componente de dirección; significado concreto depende de component_type (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 255 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `component_type` | `varchar(50)` | Nombre del tipo de componente de dirección; sin catálogo ni enumeración de valores autorizados (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 50 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A6 | `address_sup_ID` | `bigint unsigned` | Componente superior opcional dentro de la misma dirección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | Sí | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A8 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `address_ID` | `No declarado` | fk_component_address: (address_ID) → tb_user_addresses (ID) [tupla completa]; fk_component_parent: (address_ID, address_sup_ID) → tbd_address_components (address_ID, ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL` |
| A3 / D3 | `value` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A4 / D4 | `component_type` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A6 / D6 | `address_sup_ID` | `NULL` | fk_component_parent: (address_ID, address_sup_ID) → tbd_address_components (address_ID, ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned DEFAULT NULL` |
| A7 / D7 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A8 / D8 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| uk_address_component | UNIQUE | ['address_ID', 'ID'] |
| idx_address_parent | INDEX | ['address_ID', 'address_sup_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_address_components` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `address_ID` bigint unsigned NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `component_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `address_sup_ID` bigint unsigned DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_address_component` (`address_ID`,`ID`),
  KEY `idx_address_parent` (`address_ID`,`address_sup_ID`),
  CONSTRAINT `fk_component_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`),
  CONSTRAINT `fk_component_parent` FOREIGN KEY (`address_ID`, `address_sup_ID`) REFERENCES `tbd_address_components` (`address_ID`, `ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_cancellation_items

**Nombre:** `tbd_cancellation_items` · **Evidencia:** línea 2328.

**Descripción general (inferida):** Partidas de cancelación.

**Propósito de negocio (inferido):** Desglosar cantidades e importes unitarios de partidas objeto de cancelación.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle.

**Grado:** 9. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_cancellation_items(ID, cancellation_ID, order_item_ID, quantity, unit_amount, item_reason, status, creation_date, last_update)`.

**Forma ordinal:** `tbd_cancellation_items(A1, A2, A3, A4, A5, A6, A7, A8, A9)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_cancellation_items_cancellation: tbd_cancellation_items (cancellation_ID) → tb_cancellations (ID); véase matriz de cardinalidades; fk_cancellation_items_order_item: tbd_cancellation_items (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. CONSTRAINT `chk_cancellation_items_amount` CHECK ((`unit_amount` >= 0)) CONSTRAINT `chk_cancellation_items_quantity` CHECK ((`quantity` > 0)) No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de partidas de cancelación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `cancellation_ID` | `int unsigned` | Solicitud de cancelación vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `order_item_ID` | `int unsigned` | Partida del pedido vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `quantity` | `int unsigned` | Cantidad de unidades del producto incluidas en el carrito o partida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '1'. CONSTRAINT `chk_cancellation_items_quantity` CHECK ((`quantity` > 0)) |
| A5 | `unit_amount` | `decimal(12,2)` | Importe por unidad de la partida afectada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. CONSTRAINT `chk_cancellation_items_amount` CHECK ((`unit_amount` >= 0)) |
| A6 | `item_reason` | `varchar(500)` | Motivo específico de la partida afectada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A8 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A9 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `cancellation_ID` | `No declarado` | fk_cancellation_items_cancellation: (cancellation_ID) → tb_cancellations (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `order_item_ID` | `No declarado` | fk_cancellation_items_order_item: (order_item_ID) → tbd_order_items (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `quantity` | `'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL DEFAULT '1'` |
| A5 / D5 | `unit_amount` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL DEFAULT '0.00'` |
| A6 / D6 | `item_reason` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) DEFAULT NULL` |
| A7 / D7 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A8 / D8 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A9 / D9 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_cancellation_items_cancellation | INDEX | ['cancellation_ID'] |
| idx_cancellation_items_order_item | INDEX | ['order_item_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_cancellation_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `cancellation_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `item_reason` varchar(500) DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_cancellation_items_cancellation` (`cancellation_ID`),
  KEY `idx_cancellation_items_order_item` (`order_item_ID`),
  CONSTRAINT `fk_cancellation_items_cancellation` FOREIGN KEY (`cancellation_ID`) REFERENCES `tb_cancellations` (`ID`),
  CONSTRAINT `fk_cancellation_items_order_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`),
  CONSTRAINT `chk_cancellation_items_amount` CHECK ((`unit_amount` >= 0)),
  CONSTRAINT `chk_cancellation_items_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_carts_items

**Nombre:** `tbd_carts_items` · **Evidencia:** línea 2444.

**Descripción general (inferida):** Artículos de carrito por proveedor y producto.

**Propósito de negocio (inferido):** Representar la cantidad seleccionada de un producto ofrecido por un proveedor dentro de un carrito; no existen FK que aseguren esa interpretación.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (cart_ID, provider_ID, product_ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle/intermedia lógica.

**Grado:** 5. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_carts_items(cart_ID, provider_ID, product_ID, quantity, creation_date)`.

**Forma ordinal:** `tbd_carts_items(A1, A2, A3, A4, A5)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** ninguna.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `cart_ID` | `int` | Carrito al que parece pertenecer la selección de producto; sin FK (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | No | 32 bits; rango -2147483648 a 2147483647. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `provider_ID` | `int` | Proveedor asociado a la selección del carrito; su correspondencia con tb_users es inferida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | No | 32 bits; rango -2147483648 a 2147483647. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `product_ID` | `int` | Producto incluido en la asociación o selección representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: cart_ID, provider_ID, product_ID) | No | 32 bits; rango -2147483648 a 2147483647. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `quantity` | `int` | Cantidad de unidades del producto incluidas en el carrito o partida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango -2147483648 a 2147483647. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `cart_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int NOT NULL` |
| A2 / D2 | `provider_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int NOT NULL` |
| A3 / D3 | `product_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int NOT NULL` |
| A4 / D4 | `quantity` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int NOT NULL` |
| A5 / D5 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['cart_ID', 'provider_ID', 'product_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_carts_items` (
  `cart_ID` int NOT NULL,
  `provider_ID` int NOT NULL,
  `product_ID` int NOT NULL,
  `quantity` int NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_ID`,`provider_ID`,`product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_order_items

**Nombre:** `tbd_order_items` · **Evidencia:** línea 2565.

**Descripción general (inferida):** Partidas de pedidos por vendedor.

**Propósito de negocio (inferido):** Conservar cantidades, nombre de producto y precio unitario de las partidas y calcular su subtotal.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle.

**Grado:** 8. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_order_items(ID, seller_order_ID, product_offer_ID, product_name, quantity, unit_price, subtotal, creation_date)`.

**Forma ordinal:** `tbd_order_items(A1, A2, A3, A4, A5, A6, A7, A8)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_returns_item: tb_returns (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades; fk_cancellation_items_order_item: tbd_cancellation_items (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades; tbd_order_items_ibfk_1: tbd_order_items (seller_order_ID) → tb_buyer_orders (ID); véase matriz de cardinalidades; fk_return_items_order_item: tbd_return_items (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de partidas de pedidos por vendedor (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `seller_order_ID` | `int unsigned` | Desglose del pedido por vendedor al que pertenece la partida, referenciado en tb_buyer_orders (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `product_offer_ID` | `int unsigned` | Oferta comercial asociada a la partida; no hay entidad de ofertas ni FK que determine su destino (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `product_name` | `varchar(255)` | Nombre del producto conservado en la partida; su uso como instantánea histórica es inferido (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Máximo 255 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `quantity` | `int unsigned` | Cantidad de unidades del producto incluidas en el carrito o partida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `unit_price` | `decimal(12,2)` | Precio por unidad conservado en la partida del pedido; moneda no determinada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A7 | `subtotal` | `decimal(12,2)` | Importe parcial del desglose o de la partida; moneda y tratamiento fiscal no determinados (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); derivado y almacenado (GENERATED STORED); opcional; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | Sí | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NULL permitido. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A8 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `seller_order_ID` | `No declarado` | tbd_order_items_ibfk_1: (seller_order_ID) → tb_buyer_orders (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `product_offer_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `product_name` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `quantity` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A6 / D6 | `unit_price` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL` |
| A7 / D7 | `subtotal` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED` |
| A8 / D8 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| seller_order_ID | INDEX | ['seller_order_ID'] |
| product_offer_ID | INDEX | ['product_offer_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_order_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `seller_order_ID` int unsigned NOT NULL,
  `product_offer_ID` int unsigned NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `seller_order_ID` (`seller_order_ID`),
  KEY `product_offer_ID` (`product_offer_ID`),
  CONSTRAINT `tbd_order_items_ibfk_1` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_products_categories

**Nombre:** `tbd_products_categories` · **Evidencia:** línea 2716.

**Descripción general (inferida):** Asignación de productos a categorías.

**Propósito de negocio (inferido):** Clasificar un producto en varias categorías y reunir varios productos en cada categoría.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (category_ID, product_ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** intermedia.

**Grado:** 5. **Cardinalidad de datos exportados:** 28656 tuplas.

**Esquema formal:** `tbd_products_categories(category_ID, product_ID, status, creation_date, last_update)`.

**Forma ordinal:** `tbd_products_categories(A1, A2, A3, A4, A5)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_category: tbd_products_categories (category_ID) → tbc_categories (ID); véase matriz de cardinalidades; fk_product: tbd_products_categories (product_ID) → tb_products (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `category_ID` | `int unsigned` | Categoría asignada al producto en esta asociación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, FK, UNIQUE (PRIMARY: category_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, FK, UNIQUE (PRIMARY: category_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `product_ID` | `int unsigned` | Producto incluido en la asociación o selección representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, FK, UNIQUE (PRIMARY: category_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, FK, UNIQUE (PRIMARY: category_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A4 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A5 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `category_ID` | `No declarado` | fk_category: (category_ID) → tbc_categories (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A2 / D2 | `product_ID` | `No declarado` | fk_product: (product_ID) → tb_products (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A4 / D4 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A5 / D5 | `last_update` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['category_ID', 'product_ID'] |
| fk_product | INDEX | ['product_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_products_categories` (
  `category_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_ID`,`product_ID`),
  KEY `fk_product` (`product_ID`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_ID`) REFERENCES `tbc_categories` (`ID`),
  CONSTRAINT `fk_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_products_users_providers

**Nombre:** `tbd_products_users_providers` · **Evidencia:** línea 2843.

**Descripción general (inferida):** Vínculos de productos con usuarios proveedores.

**Propósito de negocio (inferido):** Asociar usuarios con productos y registrar el tipo de participación comercial y fecha de disponibilidad.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (user_ID, product_ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** intermedia.

**Grado:** 7. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_products_users_providers(user_ID, product_ID, type_ownership, status, avalaible_date, creation_date, last_update)`.

**Forma ordinal:** `tbd_products_users_providers(A1, A2, A3, A4, A5, A6, A7)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_products2: tbd_products_users_providers (product_ID) → tb_products (ID); véase matriz de cardinalidades; fk_user1: tbd_products_users_providers (user_ID) → tb_users (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, FK, UNIQUE (PRIMARY: user_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, FK, UNIQUE (PRIMARY: user_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `product_ID` | `int unsigned` | Producto incluido en la asociación o selección representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, FK, UNIQUE (PRIMARY: user_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, FK, UNIQUE (PRIMARY: user_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `type_ownership` | `enum('Owner','Reseller','Distributor')` | Tipo de participación del usuario respecto al producto: Owner, Reseller o Distributor; admite ausencia de clasificación (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Conjunto declarado: enum('Owner','Reseller','Distributor'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A4 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A5 | `avalaible_date` | `datetime` | Fecha y hora de disponibilidad del producto para el usuario proveedor; se conserva la grafía original (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A7 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `user_ID` | `No declarado` | fk_user1: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A2 / D2 | `product_ID` | `No declarado` | fk_products2: (product_ID) → tb_products (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `type_ownership` | `NULL` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Owner','Reseller','Distributor') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A4 / D4 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A5 / D5 | `avalaible_date` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL` |
| A6 / D6 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A7 / D7 | `last_update` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['user_ID', 'product_ID'] |
| fk_products2 | INDEX | ['product_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_products_users_providers` (
  `user_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `type_ownership` enum('Owner','Reseller','Distributor') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `avalaible_date` datetime NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `fk_products2` (`product_ID`),
  CONSTRAINT `fk_products2` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`),
  CONSTRAINT `fk_user1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_return_items

**Nombre:** `tbd_return_items` · **Evidencia:** línea 3018.

**Descripción general (inferida):** Partidas de devolución.

**Propósito de negocio (inferido):** Desglosar partidas devueltas, unidades, importe y condición declarada.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle.

**Grado:** 10. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_return_items(ID, return_ID, order_item_ID, quantity, unit_amount, item_reason, item_condition, status, creation_date, last_update)`.

**Forma ordinal:** `tbd_return_items(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** fk_return_items_order_item: tbd_return_items (order_item_ID) → tbd_order_items (ID); véase matriz de cardinalidades; fk_return_items_return: tbd_return_items (return_ID) → tb_returns (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. CONSTRAINT `chk_return_items_amount` CHECK ((`unit_amount` >= 0)) CONSTRAINT `chk_return_items_quantity` CHECK ((`quantity` > 0)) No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `int unsigned` | Identificador que distingue cada registro de partidas de devolución (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `return_ID` | `int unsigned` | Solicitud de devolución vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `order_item_ID` | `int unsigned` | Partida del pedido vinculada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `quantity` | `int unsigned` | Cantidad de unidades del producto incluidas en el carrito o partida (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa discreta (inferencia): cuenta unidades; unidad de stock pendiente de validación. | No | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '1'. CONSTRAINT `chk_return_items_quantity` CHECK ((`quantity` > 0)) |
| A5 | `unit_amount` | `decimal(12,2)` | Importe por unidad de la partida afectada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cuantitativa continua (inferencia funcional): importe tratado como magnitud, registrado con resolución decimal fija; monetariamente discreto a esa escala. | No | No | Precisión 12, escala 2; rango -9999999999.99 a 9999999999.99; decimal exacto. NOT NULL. DEFAULT '0.00'. CONSTRAINT `chk_return_items_amount` CHECK ((`unit_amount` >= 0)) |
| A6 | `item_reason` | `varchar(500)` | Motivo específico de la partida afectada (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 500 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `item_condition` | `enum('Unknown','New','Opened','Damaged')` | Condición declarada de la partida devuelta; sin orden total demostrable (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | Conjunto declarado: enum('Unknown','New','Opened','Damaged'); entradas inválidas dependen del SQL_MODE; ENUM no demuestra orden funcional. NOT NULL. DEFAULT 'Unknown'. Sin CHECK aplicable declarado. |
| A8 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A9 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A10 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `return_ID` | `No declarado` | fk_return_items_return: (return_ID) → tb_returns (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `order_item_ID` | `No declarado` | fk_return_items_order_item: (order_item_ID) → tbd_order_items (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `quantity` | `'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL DEFAULT '1'` |
| A5 / D5 | `unit_amount` | `'0.00'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `decimal(12,2) NOT NULL DEFAULT '0.00'` |
| A6 / D6 | `item_reason` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(500) DEFAULT NULL` |
| A7 / D7 | `item_condition` | `'Unknown'` | Sin FK | Estados/categorías literales del ENUM confirmados; transiciones y significado operativo pendientes. | `enum('Unknown','New','Opened','Damaged') NOT NULL DEFAULT 'Unknown'` |
| A8 / D8 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A9 / D9 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A10 / D10 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| idx_return_items_return | INDEX | ['return_ID'] |
| idx_return_items_order_item | INDEX | ['order_item_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_return_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `return_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `item_reason` varchar(500) DEFAULT NULL,
  `item_condition` enum('Unknown','New','Opened','Damaged') NOT NULL DEFAULT 'Unknown',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_return_items_return` (`return_ID`),
  KEY `idx_return_items_order_item` (`order_item_ID`),
  CONSTRAINT `fk_return_items_order_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`),
  CONSTRAINT `fk_return_items_return` FOREIGN KEY (`return_ID`) REFERENCES `tb_returns` (`ID`),
  CONSTRAINT `chk_return_items_amount` CHECK ((`unit_amount` >= 0)),
  CONSTRAINT `chk_return_items_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_user_payment_methods

**Nombre:** `tbd_user_payment_methods` · **Evidencia:** línea 3139.

**Descripción general (inferida):** Instrumentos de pago de usuarios.

**Propósito de negocio (inferido):** Vincular referencias de instrumentos gestionadas por proveedores de pago con cuentas y tipos de método.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** detalle.

**Grado:** 11. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_user_payment_methods(ID, user_ID, payment_method_type_ID, provider, provider_method_ref, label, last_four, is_default, status, creation_date, last_update)`.

**Forma ordinal:** `tbd_user_payment_methods(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** tbd_user_payment_methods_ibfk_1: tbd_user_payment_methods (user_ID) → tb_users (ID); véase matriz de cardinalidades; tbd_user_payment_methods_ibfk_2: tbd_user_payment_methods (payment_method_type_ID) → tbc_payment_methods_types (ID); véase matriz de cardinalidades.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `ID` | `bigint unsigned` | Identificador que distingue cada registro de instrumentos de pago de usuarios (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: ID) | No | 64 bits; rango 0 a 18446744073709551615. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `payment_method_type_ID` | `int unsigned` | Tipo de método que clasifica el instrumento de pago del usuario (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; FK | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | FK | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A4 | `provider` | `varchar(60)` | Nombre o código del proveedor que gestiona el instrumento de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (uk_provider_method: provider, provider_method_ref) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_provider_method: provider, provider_method_ref) | No | Máximo 60 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A5 | `provider_method_ref` | `varchar(255)` | Referencia del instrumento dentro del proveedor de pagos; no se determina si es token ni su mecanismo de protección (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; UNIQUE (uk_provider_method: provider, provider_method_ref) | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | UNIQUE (uk_provider_method: provider, provider_method_ref) | No | Máximo 255 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A6 | `label` | `varchar(100)` | Etiqueta opcional para reconocer el instrumento de pago (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 100 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A7 | `last_four` | `char(4)` | Cuatro caracteres finales del instrumento de pago; no existe CHECK de contenido numérico (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | Sí | Máximo 4 caracteres; utf8mb4, cotejamiento utf8mb4_0900_ai_ci; sin patrón de formato declarado. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |
| A8 | `is_default` | `tinyint` | Indicador propuesto de selección predeterminada de dirección o método de pago; 0 y 1 no están limitados mediante CHECK (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 8 bits; rango -128 a 127. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT '0'. Sin CHECK aplicable declarado. |
| A9 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A10 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A11 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; opcional; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | Sí | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NULL permitido. DEFAULT NULL. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bigint unsigned NOT NULL AUTO_INCREMENT` |
| A2 / D2 | `user_ID` | `No declarado` | tbd_user_payment_methods_ibfk_1: (user_ID) → tb_users (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `payment_method_type_ID` | `No declarado` | tbd_user_payment_methods_ibfk_2: (payment_method_type_ID) → tbc_payment_methods_types (ID) [tupla completa] | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A4 / D4 | `provider` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A5 / D5 | `provider_method_ref` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL` |
| A6 / D6 | `label` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A7 / D7 | `last_four` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL` |
| A8 / D8 | `is_default` | `'0'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `tinyint NOT NULL DEFAULT '0'` |
| A9 / D9 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A10 / D10 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A11 / D11 | `last_update` | `NULL` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['ID'] |
| uk_provider_method | UNIQUE | ['provider', 'provider_method_ref'] |
| user_ID | INDEX | ['user_ID'] |
| payment_method_type_ID | INDEX | ['payment_method_type_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_user_payment_methods` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `provider` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `provider_method_ref` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `last_four` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_default` tinyint NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_provider_method` (`provider`,`provider_method_ref`),
  KEY `user_ID` (`user_ID`),
  KEY `payment_method_type_ID` (`payment_method_type_ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_2` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## tbd_users_wishlist_products

**Nombre:** `tbd_users_wishlist_products` · **Evidencia:** línea 3311.

**Descripción general (inferida):** Productos deseados por usuarios.

**Propósito de negocio (inferido):** Representar preferencias de productos por usuario; la integridad de los vínculos no está declarada con FK.

**Propósito técnico:** relación base InnoDB; mantiene identidad mediante PK (user_ID, product_ID), índices y restricciones indicados abajo.

**Clasificación (inferida):** intermedia lógica.

**Grado:** 5. **Cardinalidad de datos exportados:** 0 tuplas.

**Esquema formal:** `tbd_users_wishlist_products(user_ID, product_ID, status, creation_date, last_update)`.

**Forma ordinal:** `tbd_users_wishlist_products(A1, A2, A3, A4, A5)`. Cada Ai se identifica abajo; su dominio Di corresponde al dominio técnico y restricciones de la misma fila.

**Relaciones declaradas:** ninguna.

**Reglas confirmadas:** unicidad y obligatoriedad de la PK; restricciones de columnas, FK e índices reproducidos. No declara CHECK. No se deducen validaciones de aplicación ni dependencias funcionales adicionales.

| Posición | Atributo | Tipo SQL | Descripción | Clasificación | Naturaleza | PK/FK | NULL | Dominio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | `user_ID` | `int unsigned` | Usuario al que pertenece o con el que se asocia la entidad de esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: user_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: user_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A2 | `product_ID` | `int unsigned` | Producto incluido en la asociación o selección representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; PK, UNIQUE (PRIMARY: user_ID, product_ID) | Cualitativa nominal (inferencia): identifica o referencia una entidad; su código numérico no expresa cantidad. | PK, UNIQUE (PRIMARY: user_ID, product_ID) | No | 32 bits; rango 0 a 4294967295. El ancho entre paréntesis, si existe, no restringe el rango. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |
| A3 | `status` | `bit(1)` | Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Cualitativa nominal (inferencia): etiqueta, texto, código o categoría sin orden total de negocio demostrado. | No | No | 1 bit; 0 a 1. NOT NULL. DEFAULT b'1'. Sin CHECK aplicable declarado. |
| A4 | `creation_date` | `datetime` | Momento de creación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT CURRENT_TIMESTAMP. Sin CHECK aplicable declarado. |
| A5 | `last_update` | `datetime` | Marca temporal de modificación de la entidad representada por esta tabla (interpretación funcional inferida). | Monovalorado relacional (conceptual pendiente); almacenado; obligatorio; no clave | Temporal (escala de intervalo; diferencias de tiempo interpretables; segundo). No es conteo ni categoría nominal. | No | No | DATETIME, precisión fraccionaria 0, resolución de segundo; rango ordinario 1000-01-01 00:00:00 a 9999-12-31 23:59:59; sin zona horaria. Fechas cero dependen del SQL_MODE. NOT NULL. DEFAULT No declarado. Sin CHECK aplicable declarado. |

| Posición / dominio | Atributo | DEFAULT | Referencia completa | Dominio de negocio | Restricciones y definición exacta |
| --- | --- | --- | --- | --- | --- |
| A1 / D1 | `user_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A2 / D2 | `product_ID` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `int unsigned NOT NULL` |
| A3 / D3 | `status` | `b'1'` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `bit(1) NOT NULL DEFAULT b'1'` |
| A4 / D4 | `creation_date` | `CURRENT_TIMESTAMP` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| A5 / D5 | `last_update` | `No declarado` | Sin FK | Significado funcional inferido según descripción; catálogo o límites de negocio adicionales pendientes. | `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

**Índices:**

| Nombre | Clase | Columnas en orden |
| --- | --- | --- |
| PRIMARY | PK | ['user_ID', 'product_ID'] |

<details><summary>DDL original completo</summary>

```sql
CREATE TABLE `tbd_users_wishlist_products` (
  `user_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

</details>

## Matriz de relaciones y cardinalidades

La FK exige padre para tuplas completas no NULL. No obliga a que un padre tenga hijos; una FK compuesta puede omitir la comprobación si cualquier componente es NULL. Las autorrelaciones no impiden ciclos. Todas las acciones omitidas quedan como NO ACTION (InnoDB: RESTRICT).

| FK | Origen | Destino | Cardinalidad | ON DELETE | ON UPDATE |
| --- | --- | --- | --- | --- | --- |
| fk_seller_orders_seller | tb_buyer_orders (seller_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_cancellations_order | tb_cancellations (buyer_order_ID) | tb_buyer_orders (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_cancellations_user | tb_cancellations (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| tb_carts_ibfk_1 | tb_carts (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..1; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_payment_methods_type | tb_payment_methods (payment_method_type_ID) | tbc_payment_methods_types (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_payment_methods_user | tb_payment_methods (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_transactions_payments | tb_payment_transactions (payment_ID) | tb_payments (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_payments_buyer_orders | tb_payments (order_ID) | tb_buyer_orders (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_persons_user | tb_people (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..1; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_refunds_cancellation | tb_refunds (cancellation_ID) | tb_cancellations (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 0..1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_refunds_payment | tb_refunds (payment_ID) | tb_payments (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_refunds_return | tb_refunds (return_ID) | tb_returns (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 0..1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_returns_item | tb_returns (order_item_ID) | tbd_order_items (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_returns_order | tb_returns (buyer_order_ID) | tb_buyer_orders (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_returns_user | tb_returns (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_shipments_address | tb_shipments (address_ID) | tb_user_addresses (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_shipments_order | tb_shipments (buyer_order_ID) | tb_buyer_orders (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_addresses_user | tb_user_addresses (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_superior_category | tbc_categories (sup_id_category) | tbc_categories (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 0..1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_component_address | tbd_address_components (address_ID) | tb_user_addresses (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_component_parent | tbd_address_components (address_ID, address_sup_ID) | tbd_address_components (address_ID, ID) | Padre → hijos: 1 a 0..N; hijo → padre: 0..1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_cancellation_items_cancellation | tbd_cancellation_items (cancellation_ID) | tb_cancellations (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_cancellation_items_order_item | tbd_cancellation_items (order_item_ID) | tbd_order_items (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| tbd_order_items_ibfk_1 | tbd_order_items (seller_order_ID) | tb_buyer_orders (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_category | tbd_products_categories (category_ID) | tbc_categories (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_product | tbd_products_categories (product_ID) | tb_products (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_products2 | tbd_products_users_providers (product_ID) | tb_products (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_user1 | tbd_products_users_providers (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_return_items_order_item | tbd_return_items (order_item_ID) | tbd_order_items (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| fk_return_items_return | tbd_return_items (return_ID) | tb_returns (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| tbd_user_payment_methods_ibfk_1 | tbd_user_payment_methods (user_ID) | tb_users (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |
| tbd_user_payment_methods_ibfk_2 | tbd_user_payment_methods (payment_method_type_ID) | tbc_payment_methods_types (ID) | Padre → hijos: 1 a 0..N; hijo → padre: 1 | No explícita; NO ACTION (InnoDB: RESTRICT) | No explícita; NO ACTION (InnoDB: RESTRICT) |

**N:M confirmadas:** productos/categorías mediante tbd_products_categories; usuarios/productos mediante tbd_products_users_providers. Otras tablas de detalle enlazan entidades, pero la clave sustituta no impide repetir parejas.

**Asociaciones inferidas sin FK:** tbd_carts_items.cart_ID → tb_carts.ID; provider_ID → tb_users.ID; product_ID → tb_products.ID (además existen diferencias de signo INT/UNSIGNED). tbd_users_wishlist_products.user_ID → tb_users.ID y product_ID → tb_products.ID. Son candidatas, sin cardinalidad referencial exigida. tb_buyer_orders.order_ID y tb_payment_methods.order_ID no tienen destino declarado; product_offer_ID tampoco. No se inventa tabla de pedidos generales ni de ofertas.

## Objetos programables y vistas

Se reproducen definiciones completas como evidencia. Las dependencias no prueban que los objetos puedan ejecutarse en un servidor concreto. USER() identifica una conexión, no necesariamente al usuario de negocio. Las vistas son relaciones virtuales: sus expresiones son derivadas y no se suman a las columnas de tablas base.

### trg_buyer_orders_after_insert

Línea 59. AFTER INSERT por fila en tb_buyer_orders. Escribe en w_trazabilidad_buyer_orders. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_buyer_orders_after_insert` AFTER INSERT ON `tb_buyer_orders` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_buyer_orders` (
        `buyer_order_ID`,
        `accion`,
        `order_ID`,
        `seller_ID`,
        `subtotal_nuevo`,
        `shipping_cost_nuevo`,
        `fulfillment_status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'INSERT',
        NEW.order_ID,
        NEW.seller_ID,
        NEW.subtotal,
        NEW.shipping_cost,
        NEW.fulfillment_status,
        USER()
    );
END
```

</details>

### trg_buyer_orders_after_update

Línea 94. AFTER UPDATE por fila en tb_buyer_orders. Escribe en w_trazabilidad_buyer_orders. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_buyer_orders_after_update` AFTER UPDATE ON `tb_buyer_orders` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_buyer_orders` (
        `buyer_order_ID`,
        `accion`,
        `order_ID`,
        `seller_ID`,
        `subtotal_anterior`,
        `subtotal_nuevo`,
        `shipping_cost_anterior`,
        `shipping_cost_nuevo`,
        `fulfillment_status_anterior`,
        `fulfillment_status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'UPDATE',
        NEW.order_ID,
        NEW.seller_ID,
        OLD.subtotal,
        NEW.subtotal,
        OLD.shipping_cost,
        NEW.shipping_cost,
        OLD.fulfillment_status,
        NEW.fulfillment_status,
        USER()
    );
END
```

</details>

### trg_buyer_orders_after_delete

Línea 135. AFTER DELETE por fila en tb_buyer_orders. Escribe en w_trazabilidad_buyer_orders. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_buyer_orders_after_delete` AFTER DELETE ON `tb_buyer_orders` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_buyer_orders` (
        `buyer_order_ID`,
        `accion`,
        `order_ID`,
        `seller_ID`,
        `subtotal_anterior`,
        `shipping_cost_anterior`,
        `fulfillment_status_anterior`,
        `usuario`
    ) VALUES (
        OLD.ID,
        'DELETE',
        OLD.order_ID,
        OLD.seller_ID,
        OLD.subtotal,
        OLD.shipping_cost,
        OLD.fulfillment_status,
        USER()
    );
END
```

</details>

### trg_cancellations_after_insert

Línea 206. AFTER INSERT por fila en tb_cancellations. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellations_after_insert` AFTER INSERT ON `tb_cancellations` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_cancellations', 'Create', USER(),
         CONCAT('Cancelacion creada. ID=', NEW.ID,
                ', pedido=', NEW.buyer_order_ID,
                ', usuario=', NEW.user_ID,
                ', estado=', NEW.cancellation_status,
                ', motivo=', NEW.cancellation_reason),
         NOW(), b'1');
END
```

</details>

### trg_cancellations_after_update

Línea 233. AFTER UPDATE por fila en tb_cancellations. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellations_after_update` AFTER UPDATE ON `tb_cancellations` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_cancellations', 'Update', USER(),
         CONCAT('Cancelacion ID=', NEW.ID,
                ', pedido=', NEW.buyer_order_ID,
                ', estado: ', OLD.cancellation_status, ' -> ',
                NEW.cancellation_status,
                ', motivo: ', OLD.cancellation_reason, ' -> ',
                NEW.cancellation_reason),
         NOW(), b'1');
END
```

</details>

### trg_cancellations_after_delete

Línea 261. AFTER DELETE por fila en tb_cancellations. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellations_after_delete` AFTER DELETE ON `tb_cancellations` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_cancellations', 'Delete', USER(),
         CONCAT('Cancelacion eliminada. ID=', OLD.ID,
                ', pedido=', OLD.buyer_order_ID,
                ', usuario=', OLD.user_ID,
                ', estado=', OLD.cancellation_status),
         NOW(), b'1');
END
```

</details>

### trg_carts_after_insert

Línea 315. AFTER INSERT por fila en tb_carts. Escribe en w_trazabilidad_carts. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_after_insert` AFTER INSERT ON `tb_carts` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts` (
        `cart_ID`,
        `accion`,
        `user_ID`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'INSERT',
        NEW.user_ID,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_carts_after_update

Línea 344. AFTER UPDATE por fila en tb_carts. Escribe en w_trazabilidad_carts. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_after_update` AFTER UPDATE ON `tb_carts` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts` (
        `cart_ID`,
        `accion`,
        `user_ID`,
        `status_anterior`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'UPDATE',
        NEW.user_ID,
        OLD.status,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_carts_after_delete

Línea 375. AFTER DELETE por fila en tb_carts. Escribe en w_trazabilidad_carts. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_after_delete` AFTER DELETE ON `tb_carts` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts` (
        `cart_ID`,
        `accion`,
        `user_ID`,
        `status_anterior`,
        `usuario`
    ) VALUES (
        OLD.ID,
        'DELETE',
        OLD.user_ID,
        OLD.status,
        USER()
    );
END
```

</details>

### trg_payment_methods_ai

Línea 483. AFTER INSERT por fila en tb_payment_methods. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_ai` AFTER INSERT ON `tb_payment_methods` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tb_payment_methods', 'Create', USER(),
     CONCAT('Registro de pago creado. ID=', NEW.ID,
       ', pedido=', NEW.order_ID,
       ', usuario=', NEW.user_ID,
       ', tipo=', NEW.payment_method_type_ID,
       ', importe=', NEW.amount, ' ', NEW.currency,
       ', estado=', NEW.payment_status),
     NOW(), b'1');
END
```

</details>

### trg_payment_methods_au

Línea 511. AFTER UPDATE por fila en tb_payment_methods. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_au` AFTER UPDATE ON `tb_payment_methods` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tb_payment_methods', 'Update', USER(),
     CONCAT('Registro de pago ID=', NEW.ID,
       ', estado: ', OLD.payment_status, ' -> ',
       NEW.payment_status,
       ', importe: ', OLD.amount, ' -> ', NEW.amount,
       ', referencia: ',
       COALESCE(OLD.payment_reference, 'N/D'), ' -> ',
       COALESCE(NEW.payment_reference, 'N/D')),
     NOW(), b'1');
END
```

</details>

### trg_payment_methods_ad

Línea 540. AFTER DELETE por fila en tb_payment_methods. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_ad` AFTER DELETE ON `tb_payment_methods` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tb_payment_methods', 'Delete', USER(),
     CONCAT('Registro de pago eliminado. ID=', OLD.ID,
       ', pedido=', OLD.order_ID,
       ', importe=', OLD.amount, ' ', OLD.currency,
       ', estado=', OLD.payment_status),
     NOW(), b'1');
END
```

</details>

### trg_payment_transactions_ai

Línea 596. AFTER INSERT por fila en tb_payment_transactions. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_transactions_ai` AFTER INSERT ON `tb_payment_transactions` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payment_transactions', 'Create', USER(),
         CONCAT(
             'Transacción creada. ID=', NEW.ID,
             ', pago relacionado=', NEW.payment_ID,
             ', evento=', NEW.event_type,
             ', importe=', NEW.amount,
             ', referencia=', COALESCE(NEW.event_reference, 'N/A')
         ),
         NOW(), b'1');
END
```

</details>

### trg_payment_transactions_au

Línea 625. AFTER UPDATE por fila en tb_payment_transactions. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_transactions_au` AFTER UPDATE ON `tb_payment_transactions` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payment_transactions', 'Update', USER(),
         CONCAT(
             'Transacción actualizada. ID=', NEW.ID,
             ', pago relacionado=', NEW.payment_ID,
             ', evento anterior=', OLD.event_type,
             ', evento nuevo=', NEW.event_type,
             ', importe anterior=', OLD.amount,
             ', importe nuevo=', NEW.amount,
             ', referencia nueva=',
             COALESCE(NEW.event_reference, 'N/A')
         ),
         NOW(), b'1');
END
```

</details>

### trg_payment_transactions_ad

Línea 657. AFTER DELETE por fila en tb_payment_transactions. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_transactions_ad` AFTER DELETE ON `tb_payment_transactions` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payment_transactions', 'Delete', USER(),
         CONCAT(
             'Transacción eliminada. ID=', OLD.ID,
             ', pago relacionado=', OLD.payment_ID,
             ', evento=', OLD.event_type,
             ', importe=', OLD.amount,
             ', referencia=',
             COALESCE(OLD.event_reference, 'N/A')
         ),
         NOW(), b'1');
END
```

</details>

### trg_payments_ai

Línea 722. AFTER INSERT por fila en tb_payments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payments_ai` AFTER INSERT ON `tb_payments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payments', 'Create', USER(),
         CONCAT(
             'Pago creado. ID=', NEW.ID,
             ', pedido=', NEW.order_ID,
             ', importe=', NEW.amount, ' ', NEW.currency,
             ', método=', NEW.payment_method,
             ', estado=', NEW.payment_status
         ),
         NOW(), b'1');
END
```

</details>

### trg_payments_au

Línea 751. AFTER UPDATE por fila en tb_payments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payments_au` AFTER UPDATE ON `tb_payments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payments', 'Update', USER(),
         CONCAT(
             'Pago actualizado. ID=', NEW.ID,
             ', pedido=', NEW.order_ID,
             ', importe anterior=', OLD.amount, ' ', OLD.currency,
             ', importe nuevo=', NEW.amount, ' ', NEW.currency,
             ', estado anterior=', OLD.payment_status,
             ', estado nuevo=', NEW.payment_status,
             ', método nuevo=', NEW.payment_method
         ),
         NOW(), b'1');
END
```

</details>

### trg_payments_ad

Línea 782. AFTER DELETE por fila en tb_payments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payments_ad` AFTER DELETE ON `tb_payments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_payments', 'Delete', USER(),
         CONCAT(
             'Pago eliminado. ID=', OLD.ID,
             ', pedido=', OLD.order_ID,
             ', importe=', OLD.amount, ' ', OLD.currency,
             ', método=', OLD.payment_method,
             ', estado=', OLD.payment_status
         ),
         NOW(), b'1');
END
```

</details>

### trg_people_after_insert

Línea 848. AFTER INSERT por fila en tb_people. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_people_after_insert` AFTER INSERT ON `tb_people` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_status
    )
    VALUES (
        'tb_people',
        'Create',
        USER(),
        CONCAT('Registro creado. ID=', NEW.person_ID, ', user_ID=', NEW.user_ID),
        b'1'
    );
END
```

</details>

### trg_people_after_update

Línea 878. AFTER UPDATE por fila en tb_people. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_people_after_update` AFTER UPDATE ON `tb_people` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_status
    )
    VALUES (
        'tb_people',
        'Update',
        USER(),
        CONCAT('Registro actualizado. ID=', NEW.person_ID, ', user_ID=', NEW.user_ID),
        b'1'
    );
END
```

</details>

### trg_people_after_delete

Línea 908. AFTER DELETE por fila en tb_people. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_people_after_delete` AFTER DELETE ON `tb_people` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_status
    )
    VALUES (
        'tb_people',
        'Delete',
        USER(),
        CONCAT('Registro eliminado. ID=', OLD.person_ID, ', user_ID=', OLD.user_ID),
        b'1'
    );
END
```

</details>

### trg_products_after_insert

Línea 972. AFTER INSERT por fila en tb_products. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT(
            'Producto creado (Rol Vendedor). ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', Nombre=', NEW.name
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_products_after_update

Línea 1008. AFTER UPDATE por fila en tb_products. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT(
            'Producto actualizado (Rol Vendedor). ID=', NEW.ID
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_products_after_delete

Línea 1042. AFTER DELETE por fila en tb_products. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT(
            'Producto eliminado (Rol Vendedor). ID=', OLD.ID,
            ', SKU=', OLD.SKU
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_refunds_after_insert

Línea 1119. AFTER INSERT por fila en tb_refunds. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_refunds_after_insert` AFTER INSERT ON `tb_refunds` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_refunds', 'Create', USER(),
         CONCAT('Reembolso creado. ID=', NEW.ID,
                ', pago=', NEW.payment_ID,
                ', cancelacion=', COALESCE(NEW.cancellation_ID, 'N/A'),
                ', devolucion=', COALESCE(NEW.return_ID, 'N/A'),
                ', importe=', NEW.amount, ' ', NEW.currency,
                ', estado=', NEW.refund_status),
         NOW(), b'1');
END
```

</details>

### trg_refunds_after_update

Línea 1147. AFTER UPDATE por fila en tb_refunds. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_refunds_after_update` AFTER UPDATE ON `tb_refunds` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_refunds', 'Update', USER(),
         CONCAT('Reembolso ID=', NEW.ID,
                ', pago=', NEW.payment_ID,
                ', estado: ', OLD.refund_status, ' -> ',
                NEW.refund_status,
                ', importe: ', OLD.amount, ' -> ',
                NEW.amount, ' ', NEW.currency,
                ', referencia: ',
                COALESCE(OLD.provider_reference, 'N/D'), ' -> ',
                COALESCE(NEW.provider_reference, 'N/D')),
         NOW(), b'1');
END
```

</details>

### trg_refunds_after_delete

Línea 1178. AFTER DELETE por fila en tb_refunds. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_refunds_after_delete` AFTER DELETE ON `tb_refunds` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_refunds', 'Delete', USER(),
         CONCAT('Reembolso eliminado. ID=', OLD.ID,
                ', pago=', OLD.payment_ID,
                ', importe=', OLD.amount, ' ', OLD.currency,
                ', estado=', OLD.refund_status),
         NOW(), b'1');
END
```

</details>

### trg_returns_after_insert

Línea 1245. AFTER INSERT por fila en tb_returns. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_returns_after_insert` AFTER INSERT ON `tb_returns` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_returns', 'Create', USER(),
         CONCAT('Devolucion creada. ID=', NEW.ID,
                ', pedido=', NEW.buyer_order_ID,
                ', articulo=', NEW.order_item_ID,
                ', usuario=', NEW.user_ID,
                ', cantidad=', NEW.quantity,
                ', estado=', NEW.return_status,
                ', motivo=', NEW.return_reason),
         NOW(), b'1');
END
```

</details>

### trg_returns_after_update

Línea 1274. AFTER UPDATE por fila en tb_returns. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_returns_after_update` AFTER UPDATE ON `tb_returns` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_returns', 'Update', USER(),
         CONCAT('Devolucion ID=', NEW.ID,
                ', pedido=', NEW.buyer_order_ID,
                ', articulo=', NEW.order_item_ID,
                ', estado: ', OLD.return_status, ' -> ',
                NEW.return_status,
                ', cantidad: ', OLD.quantity, ' -> ',
                NEW.quantity,
                ', motivo: ', OLD.return_reason, ' -> ',
                NEW.return_reason),
         NOW(), b'1');
END
```

</details>

### trg_returns_after_delete

Línea 1305. AFTER DELETE por fila en tb_returns. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_returns_after_delete` AFTER DELETE ON `tb_returns` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_returns', 'Delete', USER(),
         CONCAT('Devolucion eliminada. ID=', OLD.ID,
                ', pedido=', OLD.buyer_order_ID,
                ', articulo=', OLD.order_item_ID,
                ', cantidad=', OLD.quantity,
                ', estado=', OLD.return_status),
         NOW(), b'1');
END
```

</details>

### trg_shipments_after_insert

Línea 1371. AFTER INSERT por fila en tb_shipments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_shipments_after_insert` AFTER INSERT ON `tb_shipments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_shipments', 'Create', USER(),
         CONCAT('Envio creado. ID=', NEW.ID,
                ', pedido=', NEW.buyer_order_ID,
                ', direccion=', NEW.address_ID,
                ', transportista=', COALESCE(NEW.carrier, 'N/D'),
                ', rastreo=', COALESCE(NEW.tracking_number, 'N/D'),
                ', estado=', NEW.shipment_status),
         NOW(), b'1');
END
```

</details>

### trg_shipments_after_update

Línea 1399. AFTER UPDATE por fila en tb_shipments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_shipments_after_update` AFTER UPDATE ON `tb_shipments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_shipments', 'Update', USER(),
         CONCAT('Envio ID=', NEW.ID,
                ', estado: ', OLD.shipment_status, ' -> ',
                NEW.shipment_status,
                ', rastreo: ',
                COALESCE(OLD.tracking_number, 'N/D'), ' -> ',
                COALESCE(NEW.tracking_number, 'N/D'),
                ', costo: ', OLD.shipping_cost, ' -> ',
                NEW.shipping_cost),
         NOW(), b'1');
END
```

</details>

### trg_shipments_after_delete

Línea 1429. AFTER DELETE por fila en tb_shipments. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_shipments_after_delete` AFTER DELETE ON `tb_shipments` FOR EACH ROW BEGIN
    INSERT INTO tb_logs
        (table_name, operation, db_users, description,
         operation_date, operation_status)
    VALUES
        ('tb_shipments', 'Delete', USER(),
         CONCAT('Envio eliminado. ID=', OLD.ID,
                ', pedido=', OLD.buyer_order_ID,
                ', rastreo=', COALESCE(OLD.tracking_number, 'N/D'),
                ', estado=', OLD.shipment_status),
         NOW(), b'1');
END
```

</details>

### trg_user_addresses_after_insert

Línea 1490. AFTER INSERT por fila en tb_user_addresses. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_addresses_after_insert` AFTER INSERT ON `tb_user_addresses` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_user_addresses',
        'Create',
        USER(),
        CONCAT(
            'Direccion creada. ID=', NEW.ID,
            ', user_ID=', NEW.user_ID,
            ', address_label=', NEW.address_label,
            ', recipient_name=', COALESCE(NEW.recipient_name, 'NULL'),
            ', recipient_phone=', COALESCE(NEW.recipient_phone, 'NULL'),
            ', delivery_instructions=', COALESCE(NEW.delivery_instructions, 'NULL'),
            ', latitude=', COALESCE(CAST(NEW.latitude AS CHAR), 'NULL'),
            ', longitude=', COALESCE(CAST(NEW.longitude AS CHAR), 'NULL'),
            ', is_default=', NEW.is_default,
            ', status=', NEW.status + 0
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_user_addresses_after_update

Línea 1532. AFTER UPDATE por fila en tb_user_addresses. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_addresses_after_update` AFTER UPDATE ON `tb_user_addresses` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_user_addresses',
        'Update',
        USER(),
        CONCAT(
            'Direccion actualizada. ID=', NEW.ID,
            '. Cambios: ',
            CONCAT_WS(
                ', ',
                IF(
                    NOT (OLD.user_ID <=> NEW.user_ID),
                    CONCAT('user_ID: [', OLD.user_ID, '] -> [', NEW.user_ID, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.address_label <=> NEW.address_label),
                    CONCAT('address_label: [', OLD.address_label, '] -> [', NEW.address_label, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.recipient_name <=> NEW.recipient_name),
                    CONCAT(
                        'recipient_name: [',
                        COALESCE(OLD.recipient_name, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.recipient_name, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.recipient_phone <=> NEW.recipient_phone),
                    CONCAT(
                        'recipient_phone: [',
                        COALESCE(OLD.recipient_phone, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.recipient_phone, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.delivery_instructions <=> NEW.delivery_instructions),
                    CONCAT(
                        'delivery_instructions: [',
                        COALESCE(OLD.delivery_instructions, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.delivery_instructions, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.latitude <=> NEW.latitude),
                    CONCAT(
                        'latitude: [',
                        COALESCE(CAST(OLD.latitude AS CHAR), 'NULL'),
                        '] -> [',
                        COALESCE(CAST(NEW.latitude AS CHAR), 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.longitude <=> NEW.longitude),
                    CONCAT(
                        'longitude: [',
                        COALESCE(CAST(OLD.longitude AS CHAR), 'NULL'),
                        '] -> [',
                        COALESCE(CAST(NEW.longitude AS CHAR), 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.is_default <=> NEW.is_default),
                    CONCAT(
                        'is_default: [',
                        OLD.is_default,
                        '] -> [',
                        NEW.is_default,
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.status <=> NEW.status),
                    CONCAT(
                        'status: [',
                        OLD.status + 0,
                        '] -> [',
                        NEW.status + 0,
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.last_update <=> NEW.last_update),
                    CONCAT(
                        'last_update: [',
                        COALESCE(CAST(OLD.last_update AS CHAR), 'NULL'),
                        '] -> [',
                        COALESCE(CAST(NEW.last_update AS CHAR), 'NULL'),
                        ']'
                    ),
                    NULL
                )
            )
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_user_addresses_after_delete

Línea 1667. AFTER DELETE por fila en tb_user_addresses. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_addresses_after_delete` AFTER DELETE ON `tb_user_addresses` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_user_addresses',
        'Delete',
        USER(),
        CONCAT(
            'Direccion eliminada. ID=', OLD.ID,
            ', user_ID=', OLD.user_ID,
            ', address_label=', OLD.address_label,
            ', recipient_name=', COALESCE(OLD.recipient_name, 'NULL'),
            ', recipient_phone=', COALESCE(OLD.recipient_phone, 'NULL'),
            ', delivery_instructions=', COALESCE(OLD.delivery_instructions, 'NULL'),
            ', latitude=', COALESCE(CAST(OLD.latitude AS CHAR), 'NULL'),
            ', longitude=', COALESCE(CAST(OLD.longitude AS CHAR), 'NULL'),
            ', is_default=', OLD.is_default,
            ', status=', OLD.status + 0
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_users_after_insert

Línea 1743. AFTER INSERT por fila en tb_users. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Create',
        USER(),
        CONCAT(
            'Usuario creado. ID=', NEW.ID,
            ', email=', NEW.email,
            ', nick=', NEW.nick
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_users_after_update

Línea 1779. AFTER UPDATE por fila en tb_users. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Update',
        USER(),
        CONCAT(
            'Usuario actualizado. ID=', NEW.ID,
            '. Cambios: ',
            CONCAT_WS(
                ', ',
                IF(
                    NOT (OLD.email <=> NEW.email),
                    CONCAT(
                        'email: [',
                        COALESCE(OLD.email, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.email, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.nick <=> NEW.nick),
                    CONCAT(
                        'nickname: [',
                        COALESCE(OLD.nick, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.nick, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.status <=> NEW.status),
                    CONCAT(
                        'status: [',
                        COALESCE(OLD.status + 0, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.status + 0, 'NULL'),
                        ']'
                    ),
                    NULL
                )
            )
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_users_after_delete

Línea 1850. AFTER DELETE por fila en tb_users. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CONCAT(
            'Usuario eliminado. ID=', OLD.ID,
            ', email=', OLD.email,
            ', nick=', OLD.nick
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_categories_after_insert

Línea 1918. AFTER INSERT por fila en tbc_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_categories_after_insert` AFTER INSERT ON `tbc_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbc_categories',
        'Create',
        USER(),
        CONCAT('Se insertó la categoría con ID: ', NEW.ID, ', Nombre: ', NEW.name),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_categories_after_update

Línea 1950. AFTER UPDATE por fila en tbc_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_categories_after_update` AFTER UPDATE ON `tbc_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbc_categories',
        'Update',
        USER(),
        CONCAT('Se actualizó la categoría ID: ', NEW.ID, '. Nombre anterior: ', OLD.name, ' -> Nombre nuevo: ', NEW.name),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_categories_after_delete

Línea 1982. AFTER DELETE por fila en tbc_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_categories_after_delete` AFTER DELETE ON `tbc_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbc_categories',
        'Delete',
        USER(),
        CONCAT('Se eliminó la categoría ID: ', OLD.ID, ', Nombre: ', OLD.name),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_payment_methods_types_after_insert

Línea 2042. AFTER INSERT por fila en tbc_payment_methods_types. Escribe en w_trazabilidad_payment_methods_types. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_types_after_insert` AFTER INSERT ON `tbc_payment_methods_types` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_payment_methods_types` (
        `payment_method_type_ID`,
        `accion`,
        `code_nuevo`,
        `description_nueva`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'INSERT',
        NEW.code,
        NEW.description,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_payment_methods_types_after_update

Línea 2073. AFTER UPDATE por fila en tbc_payment_methods_types. Escribe en w_trazabilidad_payment_methods_types. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_types_after_update` AFTER UPDATE ON `tbc_payment_methods_types` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_payment_methods_types` (
        `payment_method_type_ID`,
        `accion`,
        `code_anterior`,
        `code_nuevo`,
        `description_anterior`,
        `description_nueva`,
        `status_anterior`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'UPDATE',
        OLD.code,
        NEW.code,
        OLD.description,
        NEW.description,
        OLD.status,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_payment_methods_types_after_delete

Línea 2110. AFTER DELETE por fila en tbc_payment_methods_types. Escribe en w_trazabilidad_payment_methods_types. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_payment_methods_types_after_delete` AFTER DELETE ON `tbc_payment_methods_types` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_payment_methods_types` (
        `payment_method_type_ID`,
        `accion`,
        `code_anterior`,
        `description_anterior`,
        `status_anterior`,
        `usuario`
    ) VALUES (
        OLD.ID,
        'DELETE',
        OLD.code,
        OLD.description,
        OLD.status,
        USER()
    );
END
```

</details>

### trg_address_components_after_insert

Línea 2174. AFTER INSERT por fila en tbd_address_components. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_address_components_after_insert` AFTER INSERT ON `tbd_address_components` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_address_components',
        'Create',
        USER(),
        CONCAT(
            'Componente creado. ID=', NEW.ID,
            ', address_ID=', NEW.address_ID,
            ', value=', NEW.value,
            ', component_type=', NEW.component_type,
            ', status=', NEW.status + 0,
            ', address_sup_ID=', COALESCE(NEW.address_sup_ID, 'NULL')
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_address_components_after_update

Línea 2212. AFTER UPDATE por fila en tbd_address_components. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_address_components_after_update` AFTER UPDATE ON `tbd_address_components` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_address_components',
        'Update',
        USER(),
        CONCAT(
            'Componente actualizado. ID=', NEW.ID,
            '. Cambios: ',
            CONCAT_WS(
                ', ',
                IF(
                    NOT (OLD.address_ID <=> NEW.address_ID),
                    CONCAT('address_ID: [', OLD.address_ID, '] -> [', NEW.address_ID, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.value <=> NEW.value),
                    CONCAT('value: [', OLD.value, '] -> [', NEW.value, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.component_type <=> NEW.component_type),
                    CONCAT('component_type: [', OLD.component_type, '] -> [', NEW.component_type, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.status <=> NEW.status),
                    CONCAT('status: [', OLD.status + 0, '] -> [', NEW.status + 0, ']'),
                    NULL
                ),
                IF(
                    NOT (OLD.address_sup_ID <=> NEW.address_sup_ID),
                    CONCAT(
                        'address_sup_ID: [',
                        COALESCE(CAST(OLD.address_sup_ID AS CHAR), 'NULL'),
                        '] -> [',
                        COALESCE(CAST(NEW.address_sup_ID AS CHAR), 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.last_update <=> NEW.last_update),
                    CONCAT(
                        'last_update: [',
                        COALESCE(CAST(OLD.last_update AS CHAR), 'NULL'),
                        '] -> [',
                        COALESCE(CAST(NEW.last_update AS CHAR), 'NULL'),
                        ']'
                    ),
                    NULL
                )
            )
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_address_components_after_delete

Línea 2291. AFTER DELETE por fila en tbd_address_components. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_address_components_after_delete` AFTER DELETE ON `tbd_address_components` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`,
        `operation_date`,
        `operation_status`
    ) VALUES (
        'tb_address_components',
        'Delete',
        USER(),
        CONCAT(
            'Componente eliminado. ID=', OLD.ID,
            ', address_ID=', OLD.address_ID,
            ', value=', OLD.value,
            ', component_type=', OLD.component_type,
            ', status=', OLD.status + 0,
            ', address_sup_ID=', COALESCE(OLD.address_sup_ID, 'NULL')
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_cancellation_items_ai

Línea 2365. AFTER INSERT por fila en tbd_cancellation_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellation_items_ai` AFTER INSERT ON `tbd_cancellation_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_cancellation_items', 'Create', USER(),
     CONCAT('Articulo de cancelacion creado. ID=', NEW.ID,
       ', cancelacion=', NEW.cancellation_ID,
       ', articulo de pedido=', NEW.order_item_ID,
       ', cantidad=', NEW.quantity,
       ', importe unitario=', NEW.unit_amount),
     NOW(), b'1');
END
```

</details>

### trg_cancellation_items_au

Línea 2392. AFTER UPDATE por fila en tbd_cancellation_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellation_items_au` AFTER UPDATE ON `tbd_cancellation_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_cancellation_items', 'Update', USER(),
     CONCAT('Articulo de cancelacion ID=', NEW.ID,
       ', cancelacion=', NEW.cancellation_ID,
       ', cantidad: ', OLD.quantity, ' -> ', NEW.quantity,
       ', importe unitario: ', OLD.unit_amount, ' -> ',
       NEW.unit_amount),
     NOW(), b'1');
END
```

</details>

### trg_cancellation_items_ad

Línea 2419. AFTER DELETE por fila en tbd_cancellation_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_cancellation_items_ad` AFTER DELETE ON `tbd_cancellation_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_cancellation_items', 'Delete', USER(),
     CONCAT('Articulo de cancelacion eliminado. ID=', OLD.ID,
       ', cancelacion=', OLD.cancellation_ID,
       ', articulo de pedido=', OLD.order_item_ID,
       ', cantidad=', OLD.quantity),
     NOW(), b'1');
END
```

</details>

### trg_carts_items_after_insert

Línea 2471. AFTER INSERT por fila en tbd_carts_items. Escribe en w_trazabilidad_carts_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_items_after_insert` AFTER INSERT ON `tbd_carts_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts_items` (
        `cart_ID`,
        `provider_ID`,
        `product_ID`,
        `accion`,
        `quantity_nueva`,
        `usuario`
    ) VALUES (
        NEW.cart_ID,
        NEW.provider_ID,
        NEW.product_ID,
        'INSERT',
        NEW.quantity,
        USER()
    );
END
```

</details>

### trg_carts_items_after_update

Línea 2502. AFTER UPDATE por fila en tbd_carts_items. Escribe en w_trazabilidad_carts_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_items_after_update` AFTER UPDATE ON `tbd_carts_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts_items` (
        `cart_ID`,
        `provider_ID`,
        `product_ID`,
        `accion`,
        `quantity_anterior`,
        `quantity_nueva`,
        `usuario`
    ) VALUES (
        NEW.cart_ID,
        NEW.provider_ID,
        NEW.product_ID,
        'UPDATE',
        OLD.quantity,
        NEW.quantity,
        USER()
    );
END
```

</details>

### trg_carts_items_after_delete

Línea 2535. AFTER DELETE por fila en tbd_carts_items. Escribe en w_trazabilidad_carts_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_carts_items_after_delete` AFTER DELETE ON `tbd_carts_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_carts_items` (
        `cart_ID`,
        `provider_ID`,
        `product_ID`,
        `accion`,
        `quantity_anterior`,
        `usuario`
    ) VALUES (
        OLD.cart_ID,
        OLD.provider_ID,
        OLD.product_ID,
        'DELETE',
        OLD.quantity,
        USER()
    );
END
```

</details>

### trg_order_items_after_insert

Línea 2598. AFTER INSERT por fila en tbd_order_items. Escribe en w_trazabilidad_order_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_order_items_after_insert` AFTER INSERT ON `tbd_order_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_order_items` (
        `order_item_ID`,
        `accion`,
        `seller_order_ID`,
        `product_offer_ID`,
        `product_name_nuevo`,
        `quantity_nueva`,
        `unit_price_nuevo`,
        `subtotal_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'INSERT',
        NEW.seller_order_ID,
        NEW.product_offer_ID,
        NEW.product_name,
        NEW.quantity,
        NEW.unit_price,
        NEW.subtotal,
        USER()
    );
END
```

</details>

### trg_order_items_after_update

Línea 2635. AFTER UPDATE por fila en tbd_order_items. Escribe en w_trazabilidad_order_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_order_items_after_update` AFTER UPDATE ON `tbd_order_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_order_items` (
        `order_item_ID`,
        `accion`,
        `seller_order_ID`,
        `product_offer_ID`,
        `product_name_anterior`,
        `product_name_nuevo`,
        `quantity_anterior`,
        `quantity_nueva`,
        `unit_price_anterior`,
        `unit_price_nuevo`,
        `subtotal_anterior`,
        `subtotal_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'UPDATE',
        NEW.seller_order_ID,
        NEW.product_offer_ID,
        OLD.product_name,
        NEW.product_name,
        OLD.quantity,
        NEW.quantity,
        OLD.unit_price,
        NEW.unit_price,
        OLD.subtotal,
        NEW.subtotal,
        USER()
    );
END
```

</details>

### trg_order_items_after_delete

Línea 2680. AFTER DELETE por fila en tbd_order_items. Escribe en w_trazabilidad_order_items. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_order_items_after_delete` AFTER DELETE ON `tbd_order_items` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_order_items` (
        `order_item_ID`,
        `accion`,
        `seller_order_ID`,
        `product_offer_ID`,
        `product_name_anterior`,
        `quantity_anterior`,
        `unit_price_anterior`,
        `subtotal_anterior`,
        `usuario`
    ) VALUES (
        OLD.ID,
        'DELETE',
        OLD.seller_order_ID,
        OLD.product_offer_ID,
        OLD.product_name,
        OLD.quantity,
        OLD.unit_price,
        OLD.subtotal,
        USER()
    );
END
```

</details>

### trg_products_categories_after_insert

Línea 2748. AFTER INSERT por fila en tbd_products_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_categories_after_insert` AFTER INSERT ON `tbd_products_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_categories',
        'Create',
        USER(),
        CONCAT('Se asoció la Categoría ID: ', NEW.category_ID, ' con el Producto ID: ', NEW.product_ID),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_products_categories_after_update

Línea 2780. AFTER UPDATE por fila en tbd_products_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_categories_after_update` AFTER UPDATE ON `tbd_products_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_categories',
        'Update',
        USER(),
        CONCAT('Se actualizó la relación Categoría ID: ', NEW.category_ID, ' / Producto ID: ', NEW.product_ID, '. Estado anterior: ', OLD.status, ' -> Estado nuevo: ', NEW.status),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_products_categories_after_delete

Línea 2812. AFTER DELETE por fila en tbd_products_categories. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_categories_after_delete` AFTER DELETE ON `tbd_products_categories` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_categories',
        'Delete',
        USER(),
        CONCAT('Se eliminó la relación de Categoría ID: ', OLD.category_ID, ' con el Producto ID: ', OLD.product_ID),
        NOW(),
        b'1'
    );
END
```

</details>

### trg_products_users_providers_after_insert

Línea 2875. AFTER INSERT por fila en tbd_products_users_providers. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_users_providers_after_insert` AFTER INSERT ON `tbd_products_users_providers` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_users_providers',
        'Create',
        USER(),
        CONCAT(
            'Asignación creada. user_ID=', NEW.user_ID,
            ', product_ID=', NEW.product_ID,
            ', type_ownership=', NEW.type_ownership
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_products_users_providers_after_update

Línea 2911. AFTER UPDATE por fila en tbd_products_users_providers. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_users_providers_after_update` AFTER UPDATE ON `tbd_products_users_providers` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_users_providers',
        'Update',
        USER(),
        CONCAT(
            'Asignación actualizada. user_ID=', NEW.user_ID,
            ', product_ID=', NEW.product_ID,
            '. Cambios: ',
            CONCAT_WS(
                ', ',
                IF(
                    NOT (OLD.type_ownership <=> NEW.type_ownership),
                    CONCAT(
                        'type_ownership: [',
                        COALESCE(OLD.type_ownership, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.type_ownership, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.status <=> NEW.status),
                    CONCAT(
                        'status: [',
                        COALESCE(OLD.status + 0, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.status + 0, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.avalaible_date <=> NEW.avalaible_date),
                    CONCAT(
                        'avalaible_date: [',
                        COALESCE(OLD.avalaible_date, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.avalaible_date, 'NULL'),
                        ']'
                    ),
                    NULL
                )
            )
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_products_users_providers_after_delete

Línea 2983. AFTER DELETE por fila en tbd_products_users_providers. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_products_users_providers_after_delete` AFTER DELETE ON `tbd_products_users_providers` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tbd_products_users_providers',
        'Delete',
        USER(),
        CONCAT(
            'Asignación eliminada. user_ID=', OLD.user_ID,
            ', product_ID=', OLD.product_ID,
            ', type_ownership=', OLD.type_ownership
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END
```

</details>

### trg_return_items_ai

Línea 3056. AFTER INSERT por fila en tbd_return_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_return_items_ai` AFTER INSERT ON `tbd_return_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_return_items', 'Create', USER(),
     CONCAT('Articulo de devolucion creado. ID=', NEW.ID,
       ', devolucion=', NEW.return_ID,
       ', articulo de pedido=', NEW.order_item_ID,
       ', cantidad=', NEW.quantity,
       ', importe unitario=', NEW.unit_amount,
       ', condicion=', NEW.item_condition),
     NOW(), b'1');
END
```

</details>

### trg_return_items_au

Línea 3084. AFTER UPDATE por fila en tbd_return_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_return_items_au` AFTER UPDATE ON `tbd_return_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_return_items', 'Update', USER(),
     CONCAT('Articulo de devolucion ID=', NEW.ID,
       ', devolucion=', NEW.return_ID,
       ', cantidad: ', OLD.quantity, ' -> ', NEW.quantity,
       ', importe unitario: ', OLD.unit_amount, ' -> ',
       NEW.unit_amount,
       ', condicion: ', OLD.item_condition, ' -> ',
       NEW.item_condition),
     NOW(), b'1');
END
```

</details>

### trg_return_items_ad

Línea 3113. AFTER DELETE por fila en tbd_return_items. Escribe en tb_logs. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_return_items_ad` AFTER DELETE ON `tbd_return_items` FOR EACH ROW BEGIN
  INSERT INTO tb_logs
    (table_name, operation, db_users, description,
     operation_date, operation_status)
  VALUES
    ('tbd_return_items', 'Delete', USER(),
     CONCAT('Articulo de devolucion eliminado. ID=', OLD.ID,
       ', devolucion=', OLD.return_ID,
       ', articulo de pedido=', OLD.order_item_ID,
       ', cantidad=', OLD.quantity,
       ', condicion=', OLD.item_condition),
     NOW(), b'1');
END
```

</details>

### trg_user_payment_methods_after_insert

Línea 3177. AFTER INSERT por fila en tbd_user_payment_methods. Escribe en w_trazabilidad_user_payment_methods. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_payment_methods_after_insert` AFTER INSERT ON `tbd_user_payment_methods` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_user_payment_methods` (
        `user_payment_method_ID`,
        `accion`,
        `user_ID`,
        `payment_method_type_ID`,
        `provider_nuevo`,
        `provider_method_ref_nuevo`,
        `label_nuevo`,
        `last_four_nuevo`,
        `is_default_nuevo`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'INSERT',
        NEW.user_ID,
        NEW.payment_method_type_ID,
        NEW.provider,
        NEW.provider_method_ref,
        NEW.label,
        NEW.last_four,
        NEW.is_default,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_user_payment_methods_after_update

Línea 3218. AFTER UPDATE por fila en tbd_user_payment_methods. Escribe en w_trazabilidad_user_payment_methods. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_payment_methods_after_update` AFTER UPDATE ON `tbd_user_payment_methods` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_user_payment_methods` (
        `user_payment_method_ID`,
        `accion`,
        `user_ID`,
        `payment_method_type_ID`,
        `provider_anterior`,
        `provider_nuevo`,
        `provider_method_ref_anterior`,
        `provider_method_ref_nuevo`,
        `label_anterior`,
        `label_nuevo`,
        `last_four_anterior`,
        `last_four_nuevo`,
        `is_default_anterior`,
        `is_default_nuevo`,
        `status_anterior`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.ID,
        'UPDATE',
        NEW.user_ID,
        NEW.payment_method_type_ID,
        OLD.provider,
        NEW.provider,
        OLD.provider_method_ref,
        NEW.provider_method_ref,
        OLD.label,
        NEW.label,
        OLD.last_four,
        NEW.last_four,
        OLD.is_default,
        NEW.is_default,
        OLD.status,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_user_payment_methods_after_delete

Línea 3271. AFTER DELETE por fila en tbd_user_payment_methods. Escribe en w_trazabilidad_user_payment_methods. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_user_payment_methods_after_delete` AFTER DELETE ON `tbd_user_payment_methods` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_user_payment_methods` (
        `user_payment_method_ID`,
        `accion`,
        `user_ID`,
        `payment_method_type_ID`,
        `provider_anterior`,
        `provider_method_ref_anterior`,
        `label_anterior`,
        `last_four_anterior`,
        `is_default_anterior`,
        `status_anterior`,
        `usuario`
    ) VALUES (
        OLD.ID,
        'DELETE',
        OLD.user_ID,
        OLD.payment_method_type_ID,
        OLD.provider,
        OLD.provider_method_ref,
        OLD.label,
        OLD.last_four,
        OLD.is_default,
        OLD.status,
        USER()
    );
END
```

</details>

### trg_users_wishlist_products_after_insert

Línea 3338. AFTER INSERT por fila en tbd_users_wishlist_products. Escribe en w_trazabilidad_users_wishlist_products. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_wishlist_products_after_insert` AFTER INSERT ON `tbd_users_wishlist_products` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_users_wishlist_products` (
        `user_ID`,
        `product_ID`,
        `accion`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.user_ID,
        NEW.product_ID,
        'INSERT',
        NEW.status,
        USER()
    );
END
```

</details>

### trg_users_wishlist_products_after_update

Línea 3367. AFTER UPDATE por fila en tbd_users_wishlist_products. Escribe en w_trazabilidad_users_wishlist_products. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_wishlist_products_after_update` AFTER UPDATE ON `tbd_users_wishlist_products` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_users_wishlist_products` (
        `user_ID`,
        `product_ID`,
        `accion`,
        `status_anterior`,
        `status_nuevo`,
        `usuario`
    ) VALUES (
        NEW.user_ID,
        NEW.product_ID,
        'UPDATE',
        OLD.status,
        NEW.status,
        USER()
    );
END
```

</details>

### trg_users_wishlist_products_after_delete

Línea 3398. AFTER DELETE por fila en tbd_users_wishlist_products. Escribe en w_trazabilidad_users_wishlist_products. Valores y condiciones exactos en el cuerpo; no se presupone auditoría de todas las columnas.

<details><summary>Definición SQL íntegra</summary>

```sql
TRIGGER `trg_users_wishlist_products_after_delete` AFTER DELETE ON `tbd_users_wishlist_products` FOR EACH ROW BEGIN
    INSERT INTO `w_trazabilidad_users_wishlist_products` (
        `user_ID`,
        `product_ID`,
        `accion`,
        `status_anterior`,
        `usuario`
    ) VALUES (
        OLD.user_ID,
        OLD.product_ID,
        'DELETE',
        OLD.status,
        USER()
    );
END
```

</details>

### fn_apellido_prueba

**Tipo:** FUNCTION. **Línea:** 3960. Función auxiliar para producir datos de prueba; parámetros, tipo devuelto y reglas exactas se conservan en la definición. Recibe p_num INT, devuelve VARCHAR(150) utf8mb4. NO SQL, DETERMINISTIC. ELT(1+MOD(p_num,10),...) selecciona uno de diez apellidos; no valida NULL ni negativos.

**Dependencias léxicas:** . Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`natalia.carrasco`@`%` FUNCTION `fn_apellido_prueba`(p_num INT) RETURNS varchar(150) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
BEGIN
    RETURN ELT(
        1 + MOD(p_num, 10),
        'Smith', 'Johnson', 'Williams', 'Brown',
        'Jones', 'Garcia', 'Miller', 'Davis',
        'Wilson', 'Anderson'
    );
END ;;
```

### fn_estado_prueba

**Tipo:** FUNCTION. **Línea:** 3986. Función auxiliar para producir datos de prueba; parámetros, tipo devuelto y reglas exactas se conservan en la definición. Recibe posición INT, total INT y porcentaje DECIMAL(5,2); devuelve TINYINT. NO SQL, DETERMINISTIC. Devuelve 1 si posición <= ROUND(total*porcentaje/100,0), y 0 en otro caso. No valida el rango de entradas dentro de la función.

**Dependencias léxicas:** . Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`natalia.carrasco`@`%` FUNCTION `fn_estado_prueba`(
    p_posicion INT,
    p_total INT,
    p_porcentaje_activos DECIMAL(5,2)
) RETURNS tinyint
    NO SQL
    DETERMINISTIC
BEGIN
    IF p_posicion <= ROUND(
        p_total * p_porcentaje_activos / 100, 0
    ) THEN
        RETURN 1;
    END IF;

    RETURN 0;
END ;;
```

### fn_fecha_nacimiento_prueba

**Tipo:** FUNCTION. **Línea:** 4017. Función auxiliar para producir datos de prueba; parámetros, tipo devuelto y reglas exactas se conservan en la definición. Recibe edades mínima/máxima y p_num como INT; devuelve DATE. NO SQL. Calcula edad mínima + MOD(p_num, edad máxima - mínima + 1) y la resta de CURDATE(). Depende de la fecha de ejecución, no declara DETERMINISTIC; no valida entradas internamente.

**Dependencias léxicas:** . Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`natalia.carrasco`@`%` FUNCTION `fn_fecha_nacimiento_prueba`(
    p_edad_min INT,
    p_edad_max INT,
    p_num INT
) RETURNS date
    NO SQL
BEGIN
    DECLARE v_edad INT;
    DECLARE v_fecha DATE;

    SET v_edad = p_edad_min +
        MOD(p_num, p_edad_max - p_edad_min + 1);

    SET v_fecha = DATE_SUB(
        CURDATE(),
        INTERVAL v_edad YEAR
    );

    RETURN v_fecha;
END ;;
```

### fn_nombre_prueba

**Tipo:** FUNCTION. **Línea:** 4052. Función auxiliar para producir datos de prueba; parámetros, tipo devuelto y reglas exactas se conservan en la definición. Recibe p_num INT, devuelve VARCHAR(150) utf8mb4. NO SQL, DETERMINISTIC. ELT(1+MOD(p_num,10),...) selecciona uno de diez nombres; no valida NULL ni negativos.

**Dependencias léxicas:** . Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`natalia.carrasco`@`%` FUNCTION `fn_nombre_prueba`(p_num INT) RETURNS varchar(150) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
BEGIN
    RETURN ELT(
        1 + MOD(p_num, 10),
        'James', 'Emily', 'Michael', 'Olivia',
        'Daniel', 'Sophia', 'William', 'Emma',
        'Alexander', 'Charlotte'
    );
END ;;
```

### sp_generar_usuarios_masivos

**Tipo:** PROCEDURE. **Línea:** 4078. Generación masiva de cuentas y perfiles de prueba mediante funciones auxiliares. Seis parámetros IN. Valida cantidad 1..50000, edades 18..100 y orden mínimo/máximo, porcentaje 0..100, país de dos letras y etiqueta alfanumérica/guion bajo de 1..20 caracteres. Una transacción con ROLLBACK/RESIGNAL cubre el bucle de cuentas y perfiles; utiliza las cuatro funciones fn_*_prueba, UUID, SHA2(...,256), país en mayúsculas y proporción determinista de activos. Devuelve resumen e identificador de lote. Esas validaciones solo aplican a esta ruta de escritura, no son CHECK de tablas.

**Dependencias léxicas:** tb_people, tb_users. Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`natalia.carrasco`@`%` PROCEDURE `sp_generar_usuarios_masivos`(
    IN p_prueba VARCHAR(20),
    IN p_cantidad INT,
    IN p_pais CHAR(2),
    IN p_edad_min INT,
    IN p_edad_max INT,
    IN p_porcentaje_activos DECIMAL(5,2)
)
BEGIN
    DECLARE v_i INT DEFAULT 1;
    DECLARE v_user_id INT UNSIGNED;
    DECLARE v_identificador VARCHAR(64);
    DECLARE v_nick VARCHAR(100);
    DECLARE v_email VARCHAR(80);
    DECLARE v_nombre VARCHAR(150);
    DECLARE v_apellido VARCHAR(150);
    DECLARE v_fecha DATE;
    DECLARE v_estado TINYINT;
    DECLARE v_activos INT DEFAULT 0;
    DECLARE v_inactivos INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_cantidad IS NULL OR p_cantidad < 1
       OR p_cantidad > 50000
       OR p_edad_min IS NULL
       OR p_edad_max IS NULL
       OR p_edad_min < 18
       OR p_edad_max < p_edad_min
       OR p_edad_max > 100
       OR p_porcentaje_activos IS NULL
       OR p_porcentaje_activos < 0
       OR p_porcentaje_activos > 100
       OR p_pais IS NULL
       OR p_pais NOT REGEXP '^[A-Za-z]{2}$'
       OR p_prueba IS NULL
       OR p_prueba NOT REGEXP '^[A-Za-z0-9_]{1,20}$'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametros de generacion invalidos';
    END IF;

    SET v_identificador = REPLACE(UUID(), '-', '');

    START TRANSACTION;

    WHILE v_i <= p_cantidad DO

        SET v_nombre = fn_nombre_prueba(v_i);
        SET v_apellido = fn_apellido_prueba(v_i);
        SET v_fecha = fn_fecha_nacimiento_prueba(
            p_edad_min, p_edad_max, v_i
        );

        SET v_estado = fn_estado_prueba(
            v_i, p_cantidad, p_porcentaje_activos
        );

        SET v_nick = CONCAT(
            'test_', p_prueba, '_',
            LEFT(v_identificador, 12), '_', v_i
        );

        SET v_email = CONCAT(
            v_nick, '@example.com'
        );

        INSERT INTO tb_users (
            email,
            nick,
            password,
            status
        )
        VALUES (
            v_email,
            v_nick,
            SHA2(CONCAT(UUID(), v_nick), 256),
            IF(v_estado = 1, b'1', b'0')
        );

        SET v_user_id = LAST_INSERT_ID();

        INSERT INTO tb_people (
            user_ID,
            courtesy_title,
            given_names,
            family_names,
            birth_date,
            gender_ID,
            country_code,
            phone,
            status
        )
        VALUES (
            v_user_id,
            NULL,
            v_nombre,
            v_apellido,
            v_fecha,
            NULL,
            UPPER(p_pais),
            NULL,
            IF(v_estado = 1, b'1', b'0')
        );

        IF v_estado = 1 THEN
            SET v_activos = v_activos + 1;
        ELSE
            SET v_inactivos = v_inactivos + 1;
        END IF;

        SET v_i = v_i + 1;

    END WHILE;

    COMMIT;

    SELECT
        p_prueba AS prueba,
        p_cantidad AS usuarios_generados,
        v_activos AS usuarios_activos,
        v_inactivos AS usuarios_inactivos,
        UPPER(p_pais) AS pais,
        p_edad_min AS edad_minima,
        p_edad_max AS edad_maxima,
        v_identificador AS identificador_lote,
        'Generacion completada' AS resultado;

END ;;
```

### sp_register_user

**Tipo:** PROCEDURE. **Línea:** 4226. Registro de cuenta y perfil; consultar validaciones, manejo transaccional y respuestas exactas en el cuerpo. Diez parámetros IN documentados abajo. START TRANSACTION y COMMIT abarcan las inserciones de tb_users y tb_people; EXIT HANDLER ejecuta ROLLBACK y RESIGNAL ante SQLEXCEPTION. Guarda MD5(p_password), captura LAST_INSERT_ID() y devuelve user_ID y mensaje. No incorpora validación explícita de formato de email o teléfono.

**Dependencias léxicas:** tb_people, tb_users. Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_user`(
    IN p_email VARCHAR(80),
    IN p_nick VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_given_names VARCHAR(150),
    IN p_family_names VARCHAR(150),
    IN p_courtesy_title VARCHAR(50),
    IN p_birth_date DATE,
    IN p_gender_ID TINYINT UNSIGNED,
    IN p_country_code CHAR(2),
    IN p_phone VARCHAR(25)
)
BEGIN

    DECLARE v_user_ID INT UNSIGNED;

    /* MANEJO DE ERRORES */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    /* REGISTRAR DATOS EN TB_USERS */
    INSERT INTO tb_users (
        email,
        nick,
        password
    )
    VALUES (
        p_email,
        p_nick,
        MD5(p_password)
    );

    /* OBTENER ID DEL USUARIO */
    SET v_user_ID = LAST_INSERT_ID();

    /* REGISTRAR DATOS EN TB_PEOPLE */
    INSERT INTO tb_people (
        user_ID,
        courtesy_title,
        given_names,
        family_names,
        birth_date,
        gender_ID,
        country_code,
        phone
    )
    VALUES (
        v_user_ID,
        p_courtesy_title,
        p_given_names,
        p_family_names,
        p_birth_date,
        p_gender_ID,
        p_country_code,
        p_phone
    );

    COMMIT;

    /* MENSAJE DE CONFIRMACION */
    SELECT
        v_user_ID AS user_ID,
        'Usuario registrado correctamente' AS mensaje;

END ;;
```

### sp_soft_delete_user

**Tipo:** PROCEDURE. **Línea:** 4311. Baja lógica de usuario: valida permisos y estado, actualiza status y registra bitácora; no equivale a DELETE físico. Recibe p_user_id INT UNSIGNED. Consulta roles admin/support/superadmin en mysql.role_edges, valida identificador, existencia y estado, cambia status de 1 a 0, comprueba ROW_COUNT(), inserta Delete en tb_logs y devuelve resultado. SIGNAL 45000 informa rechazos. No contiene transacción propia ni manejador de excepciones; la atomicidad entre sentencias depende del llamador. El UPDATE puede activar además el trigger de usuarios.

**Dependencias léxicas:** mysql.role_edges, tb_logs, tb_users, v_exists, v_has_role. Parámetros, modos, características, seguridad y valores de retorno: definición íntegra siguiente.

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_soft_delete_user`(
    IN p_user_id INT UNSIGNED
)
    MODIFIES SQL DATA
BEGIN
    DECLARE v_db_user VARCHAR(32);
    DECLARE v_has_role INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 0;
    DECLARE v_status TINYINT DEFAULT NULL;
    DECLARE v_affected INT DEFAULT 0;

    -- 1. Identificar usuario de conexión
    SET v_db_user = SUBSTRING_INDEX(USER(), '@', 1);

    -- 2. Verificar roles autorizados asignados
    SELECT COUNT(*)
    INTO v_has_role
    FROM mysql.role_edges re
    WHERE re.TO_USER = v_db_user
      AND re.TO_HOST = '%'
      AND re.FROM_HOST = '%'
      AND re.FROM_USER IN (
          'superadmin',
          'admin',
          'support'
      );

    IF v_has_role = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acceso denegado: rol no autorizado';
    END IF;

    -- 3. Validar identificador
    IF p_user_id IS NULL OR p_user_id = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El identificador del usuario es inválido';
    END IF;

    -- 4. Comprobar existencia y estado
    SELECT COUNT(*), MAX(status + 0)
    INTO v_exists, v_status
    FROM tb_users
    WHERE ID = p_user_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario especificado no existe';
    END IF;

    -- 5. Comprobar estado actual
    IF v_status = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ya se encuentra inactivo';
    END IF;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario tiene un estado inválido';
    END IF;

    -- 6. Eliminación lógica
    UPDATE tb_users
    SET status = b'0'
    WHERE ID = p_user_id
      AND status = b'1';

    SET v_affected = ROW_COUNT();

    IF v_affected <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pudo desactivar el usuario';
    END IF;

    -- 7. Registrar auditoría en tb_logs usando 'db_users' en plural
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_status
    )
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CONCAT('Desactivación lógica del usuario ID: ', p_user_id, ' ejecutada por ', v_db_user),
        b'1'
    );

    -- 8. Confirmación
    SELECT
        'Usuario desactivado correctamente' AS mensaje,
        p_user_id AS user_id,
        v_db_user AS ejecutado_por,
        'Inactivo' AS estado_actual,
        CURRENT_TIMESTAMP AS fecha_operacion;

END ;;
```

### vw_total_products_by_category

**Vista definitiva**, línea 4428. **Dependencias:** tb_products, tbc_categories, tbd_products_categories. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Agrupa productos por jerarquía de categorías; inspeccionar la CTE y agregaciones.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_total_products_by_category` AS with recursive `categoryhierarchy` as (select `tbc_categories`.`ID` AS `category_ID`,cast(`tbc_categories`.`name` as char(500) charset utf8mb4) AS `category_path`,1 AS `category_level` from `tbc_categories` where (`tbc_categories`.`sup_id_category` is null) union all select `c`.`ID` AS `category_ID`,concat(`h`.`category_path`,' -> ',`c`.`name`) AS `category_path`,(`h`.`category_level` + 1) AS `category_level` from (`tbc_categories` `c` join `categoryhierarchy` `h` on((`c`.`sup_id_category` = `h`.`category_ID`)))) select `ch`.`category_ID` AS `category_ID`,`ch`.`category_path` AS `category_path`,`ch`.`category_level` AS `category_level`,count(`pc`.`product_ID`) AS `total_products`,sum((case when (`pc`.`status` = 1) then 1 else 0 end)) AS `total_active_products`,sum((case when (`pc`.`status` = 0) then 1 else 0 end)) AS `total_inactive_products`,0 AS `total_uncategorized_products` from (`categoryhierarchy` `ch` left join `tbd_products_categories` `pc` on((`ch`.`category_ID` = `pc`.`category_ID`))) group by `ch`.`category_ID`,`ch`.`category_path`,`ch`.`category_level` union all select NULL AS `category_ID`,'Sin categoría' AS `category_path`,0 AS `category_level`,count(`p`.`ID`) AS `total_products`,sum((case when (`p`.`status` = 1) then 1 else 0 end)) AS `total_active_products`,sum((case when (`p`.`status` = 0) then 1 else 0 end)) AS `total_inactive_products`,count(`p`.`ID`) AS `total_uncategorized_products` from (`tb_products` `p` left join `tbd_products_categories` `pc` on((`p`.`ID` = `pc`.`product_ID`))) where (`pc`.`product_ID` is null);
```

</details>

### vw_trazabilidad_address_components

**Vista definitiva**, línea 4446. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_address_components` AS select 1 AS `log_id`,1 AS `address_component_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_buyer_orders

**Vista definitiva**, línea 4464. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_buyer_orders` AS select 1 AS `log_id`,1 AS `buyer_order_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_cancellation_items

**Vista definitiva**, línea 4482. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_cancellation_items` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tbd_cancellation_items');
```

</details>

### vw_trazabilidad_cancellations

**Vista definitiva**, línea 4500. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_cancellations` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_cancellations');
```

</details>

### vw_trazabilidad_carts

**Vista definitiva**, línea 4518. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_carts` AS select 1 AS `log_id`,1 AS `cart_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_carts_items

**Vista definitiva**, línea 4536. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_carts_items` AS select 1 AS `log_id`,1 AS `cart_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_categorias

**Vista definitiva**, línea 4554. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_categorias` AS select 1 AS `log_id`,1 AS `category_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_general

**Vista definitiva**, línea 4572. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_general` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` in ('tb_users','tb_people'));
```

</details>

### vw_trazabilidad_order_items

**Vista definitiva**, línea 4590. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_order_items` AS select 1 AS `log_id`,1 AS `order_item_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_orders

**Vista definitiva**, línea 4608. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_orders` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_orders');
```

</details>

### vw_trazabilidad_payment_methods

**Vista definitiva**, línea 4626. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_payment_methods` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_payment_methods');
```

</details>

### vw_trazabilidad_payment_methods_types

**Vista definitiva**, línea 4644. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_payment_methods_types` AS select 1 AS `log_id`,1 AS `payment_method_type_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_people

**Vista definitiva**, línea 4662. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_people` AS select 1 AS `log_id`,1 AS `person_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_productos

**Vista definitiva**, línea 4680. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_productos` AS select 1 AS `id`,1 AS `name`,1 AS `description`,1 AS `inserted_by`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`;
```

</details>

### vw_trazabilidad_productos_proveedores

**Vista definitiva**, línea 4698. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_productos_proveedores` AS select 1 AS `log_id`,1 AS `accion`,1 AS `realizado_por`,1 AS `detalle`,1 AS `fecha_operacion`;
```

</details>

### vw_trazabilidad_refunds

**Vista definitiva**, línea 4716. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_refunds` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_refunds');
```

</details>

### vw_trazabilidad_return_items

**Vista definitiva**, línea 4734. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_return_items` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tbd_return_items');
```

</details>

### vw_trazabilidad_returns

**Vista definitiva**, línea 4752. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_returns` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_returns');
```

</details>

### vw_trazabilidad_shipments

**Vista definitiva**, línea 4770. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_shipments` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `usuario_bd`,`tb_logs`.`description` AS `descripcion`,`tb_logs`.`operation_date` AS `fecha_operacion`,`tb_logs`.`operation_status` AS `estado` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_shipments');
```

</details>

### vw_trazabilidad_tb_payment_transactions

**Vista definitiva**, línea 4788. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_tb_payment_transactions` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `db_users`,`tb_logs`.`description` AS `description`,`tb_logs`.`operation_date` AS `operation_date`,`tb_logs`.`operation_status` AS `operation_status` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_payment_transactions');
```

</details>

### vw_trazabilidad_tb_products

**Vista definitiva**, línea 4806. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_tb_products` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `db_users`,`tb_logs`.`description` AS `description`,`tb_logs`.`operation_date` AS `operation_date`,`tb_logs`.`operation_status` AS `operation_status` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_products');
```

</details>

### vw_trazabilidad_tb_users

**Vista definitiva**, línea 4824. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_tb_users` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `db_users`,`tb_logs`.`description` AS `description`,`tb_logs`.`operation_date` AS `operation_date`,`tb_logs`.`operation_status` AS `operation_status` from `tb_logs` where (`tb_logs`.`table_name` = 'tb_users');
```

</details>

### vw_trazabilidad_tbd_products_categories

**Vista definitiva**, línea 4842. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_tbd_products_categories` AS select `tb_logs`.`ID` AS `log_id`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `db_users`,`tb_logs`.`description` AS `description`,`tb_logs`.`operation_date` AS `operation_date`,`tb_logs`.`operation_status` AS `operation_status` from `tb_logs` where (`tb_logs`.`table_name` = 'tbd_products_categories');
```

</details>

### vw_trazabilidad_user_addresses

**Vista definitiva**, línea 4860. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_user_addresses` AS select 1 AS `log_id`,1 AS `user_address_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_user_payment_methods

**Vista definitiva**, línea 4878. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_user_payment_methods` AS select 1 AS `log_id`,1 AS `user_payment_method_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_users_wishlist_products

**Vista definitiva**, línea 4896. **Dependencias:** . Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_users_wishlist_products` AS select 1 AS `log_id`,1 AS `user_id`,1 AS `operation`,1 AS `db_user`,1 AS `username`,1 AS `roles`,1 AS `operation_description`,1 AS `operation_date`,1 AS `operation_status`;
```

</details>

### vw_trazabilidad_usuarios

**Vista definitiva**, línea 4914. **Dependencias:** tb_logs. Proyección, alias, expresiones, filtros, uniones y agrupación documentados íntegramente abajo. ALGORITHM=UNDEFINED, SQL SECURITY DEFINER según el dump; tipos de resultados no inferidos como tipos físicos. Consulta de trazabilidad; su cobertura está limitada por fuentes y filtros SQL, sin garantía de historia integral.

<details><summary>Consulta completa</summary>

```sql
CREATE VIEW `vw_trazabilidad_usuarios` AS select `tb_logs`.`ID` AS `ID`,`tb_logs`.`table_name` AS `table_name`,`tb_logs`.`operation` AS `operation`,`tb_logs`.`db_users` AS `db_users`,`tb_logs`.`description` AS `description`,`tb_logs`.`operation_date` AS `operation_date`,`tb_logs`.`operation_status` AS `operation_status` from `tb_logs` where ((`tb_logs`.`table_name` = 'tb_users') and (`tb_logs`.`operation_status` = 0x01));
```

</details>

## Hallazgos, normalización y pendientes de interpretación

1. Destinos de auditoría sin CREATE TABLE: w_trazabilidad_buyer_orders, w_trazabilidad_carts, w_trazabilidad_carts_items, w_trazabilidad_order_items, w_trazabilidad_payment_methods_types, w_trazabilidad_user_payment_methods, w_trazabilidad_users_wishlist_products. No se inventan sus columnas; triggers dependientes pueden fallar.

2. Dependencia externa mysql.role_edges: permisos y roles del servidor no se reconstruyen a partir de este respaldo.

3. No hay FK para pedidos generales ni ofertas. tb_payments y tb_payment_methods coexisten sin equivalencia formal demostrada.

4. No se imponen CHECK de latitud/longitud en este respaldo; no atribuirle las restricciones de respaldos anteriores.

5. Moneda MXN es un DEFAULT, no una validación ISO ni moneda obligatoria para importes sin columna currency. No se prueban impuestos ni unidades de inventario.

6. Indicadores BIT e is_default: significado funcional pendiente, salvo usos explícitos en rutinas. No se impone un único predeterminado por usuario ni is_default en 0/1.

7. No hay regla declarada de coherencia entre cabecera y detalle de devoluciones/cancelaciones, límites frente a unidades compradas, suma de pagos/reembolsos ni secuencia cronológica de fechas.

8. No se demuestran dependencias funcionales completas para certificar 3FN/BCNF. PK compuestas y tablas puente favorecen separación de asociaciones; textos de auditoría no sustituyen FK.

9. Clasificación conceptual monovalorado/multivalorado, semántica comercial de estados, género, formato de credenciales y políticas de retención requieren responsables del sistema.

## Validación final

Cobertura estructural: 100 % de tablas y columnas. Todos los atributos tienen posición, clasificación, naturaleza justificada, dominio técnico, nulabilidad, DEFAULT y referencia o ausencia de FK. Las inferencias se identifican; no se añadieron tablas ni restricciones. La validación verifica inventario y documentación, no el comportamiento de MySQL. El SHA-256 del respaldo se comprobó antes y después.
