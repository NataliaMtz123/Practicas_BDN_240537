# Reporte de validaci?n ? Modelo EER 2710

Fecha: 28 de octubre de 2026. Esquema: `db_test`. Fuente: `Practica03/backups/Respaldo_2710.sql`.

## Resultado estructural

| Indicador | Resultado |
| --- | ---: |
| Tablas analizadas y representadas | 25 |
| Atributos completos | 226 |
| Relaciones declaradas / FK | 32 |
| Relaciones inferidas opcionales | 5 |
| PK | 25 |
| ?ndices, incluyendo PK y UNIQUE | 65 |
| CHECK | 5 |
| Autorrelaciones SQL | 2 |
| Triggers | 72 |
| Vistas finales | 28 |
| Procedimientos | 3 |
| Funciones | 4 |
| Total de objetos adicionales | 107 |
| Registros verificables exactos | 128,459 |
| Tablas con conteos parciales | 0 |
| Tablas con conteos no disponibles | 0 |

## Conteos por tabla

Los ceros corresponden a tablas creadas y sin filas de carga; no son valores sustituidos para datos desconocidos. Procedencia de todos los conteos: tuplas del respaldo, an?lisis est?tico exacto.

| Tabla | Atributos | Registros | Procedencia |
| --- | ---: | ---: | --- |
| `tb_buyer_orders` | 8 | 0 | Respaldo ? exacto |
| `tb_cancellations` | 11 | 0 | Respaldo ? exacto |
| `tb_carts` | 5 | 0 | Respaldo ? exacto |
| `tb_logs` | 7 | 64,235 | Respaldo ? exacto |
| `tb_payment_methods` | 13 | 0 | Respaldo ? exacto |
| `tb_payment_transactions` | 7 | 0 | Respaldo ? exacto |
| `tb_payments` | 11 | 0 | Respaldo ? exacto |
| `tb_people` | 12 | 10,225 | Respaldo ? exacto |
| `tb_products` | 9 | 15,010 | Respaldo ? exacto |
| `tb_refunds` | 15 | 0 | Respaldo ? exacto |
| `tb_returns` | 14 | 0 | Respaldo ? exacto |
| `tb_shipments` | 13 | 0 | Respaldo ? exacto |
| `tb_user_addresses` | 12 | 0 | Respaldo ? exacto |
| `tb_users` | 8 | 10,233 | Respaldo ? exacto |
| `tbc_categories` | 7 | 100 | Respaldo ? exacto |
| `tbc_payment_methods_types` | 6 | 0 | Respaldo ? exacto |
| `tbd_address_components` | 8 | 0 | Respaldo ? exacto |
| `tbd_cancellation_items` | 9 | 0 | Respaldo ? exacto |
| `tbd_carts_items` | 5 | 0 | Respaldo ? exacto |
| `tbd_order_items` | 8 | 0 | Respaldo ? exacto |
| `tbd_products_categories` | 5 | 28,656 | Respaldo ? exacto |
| `tbd_products_users_providers` | 7 | 0 | Respaldo ? exacto |
| `tbd_return_items` | 10 | 0 | Respaldo ? exacto |
| `tbd_user_payment_methods` | 11 | 0 | Respaldo ? exacto |
| `tbd_users_wishlist_products` | 5 | 0 | Respaldo ? exacto |

## Evidencia y metodolog?a

Análisis estático completo; no se ejecutó SQL. Conteos de tuplas VALUES fuera de literales y rutinas. CREATE TABLE inicializa tablas vacías; no hay mutaciones de datos posteriores fuera de rutinas. Los cuerpos de triggers no se ejecutan ni cuentan como filas.

Todos los cuerpos CREATE TABLE se contrastaron token a token con el inventario existente. Se comprobaron nombres y orden de las 226 columnas, existencia de columnas PK/FK y sus destinos, ?ndices referenciados ?nicos, cardinalidades por nulabilidad y unicidad, cobertura de clasificaciones y dominios. Los conteos se obtuvieron independientemente y coincidieron con el inventario anterior.

El lexer considera cadenas con escapes y comillas dobles de SQL, comentarios versionados, delimitadores de rutinas y profundidad de par?ntesis. Los ALTER encontrados solo habilitan/deshabilitan ?ndices. No hay mutaciones de datos fuera de INSERT VALUES en este respaldo. Si se encuentra una mutaci?n o DDL no soportado se interrumpe la generaci?n, sin asignar un conteo exacto. No se ejecut? SQL ni se conect? a una base real.

SHA-256 original y posterior: `81bde410a5025feb0ecb174c3ca850db7ee0e135713bc67e9b857aa9faee556e`.

## Interpretaciones EER

Las FK, PK, columnas, ?ndices, nulabilidad y restricciones son evidencia SQL. Las categor?as Entidad, Asociativa, Cat?logo y Auditor?a, los prop?sitos funcionales y la naturaleza del dato son interpretaciones marcadas como inferidas o pendientes. No se afirman entidades d?biles, atributos multivalorados ni especializaciones sin respaldo suficiente. La jerarqu?a de categor?as y los componentes de direcci?n aparecen como autorrelaciones declaradas.

Las relaciones identificadoras se determinan cuando todas las columnas FK pertenecen a la PK hija. Las asociaciones N:M se representan mediante tablas puente y sus enlaces; no se agrega una FK directa ficticia entre los extremos.

| Relaci?n candidata (no FK) | Justificaci?n / l?mite |
| --- | --- |
| `tbd_carts_items.cart_ID` ? `tb_carts.ID` | Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla. |
| `tbd_carts_items.provider_ID` ? `tb_users.ID` | Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla. |
| `tbd_carts_items.product_ID` ? `tb_products.ID` | Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla. |
| `tbd_users_wishlist_products.user_ID` ? `tb_users.ID` | Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla. |
| `tbd_users_wishlist_products.product_ID` ? `tb_products.ID` | Nombre de columna y estructura asociativa; no equivale a una FK. Comparar tipos antes de implementarla. |

## Validaci?n de aplicaci?n

- Compilaci?n de producci?n con TypeScript y Vite.
- Validaci?n automatizada de estructura, conteos, clasificaciones, privacidad y huella del respaldo.
- Cuatro pruebas del lexer: escapes/comillas, comentarios ejecutables, delimitadores de triggers y restricciones anidadas.
- Dos pruebas de navegador con Microsoft Edge headless: b?squeda por columna, filtros, selecci?n, expansi?n, rutas, enfoque, hip?tesis, selecci?n de relaci?n, cambio de tema, di?logo estad?stico y descarga JSON; arrastre, persistencia, zoom, descarga SVG/PNG y viewport m?vil de 390 ? 844.
- Capturas de escritorio de 1440 ? 1000 y m?vil, y PNG exportado revisados visualmente.
- Sin errores JavaScript observados en la prueba principal. No se afirma medici?n de 60 FPS ni compatibilidad universal.
- El an?lisis de privacidad no encontr? correos, hashes de contrase?as, cuentas DEFINER ni filas originales en los metadatos p?blicos.

## Funcionalidades y archivos

La implementaci?n y la estructura modular completa se describen en [README.md](README.md). El modelo p?blico est? en `src/data/model.json`; la aplicaci?n compilada en `dist/`. Incluye navegaci?n React Flow, minimapa, layout Dagre, atributos expandibles, inspector, filtros, b?squeda, dependencias, rutas, enfoque, temas, leyenda, estad?sticas, trazabilidad y exportaciones PNG/SVG/JSON.

## Limitaciones e integridad

Análisis estático; no verifica restauración, integridad de filas ni comportamiento en servidor.

Los conteos describen el contenido representado por el dump; no certifican que restaurarlo ejecute correctamente todos sus objetos. No se verific? integridad de filas contra un servidor. La inspecci?n estructural no demuestra normalizaci?n ni reglas comerciales. Los datos personales originales nunca forman parte del frontend.

- Destinos de auditoría sin CREATE TABLE: w_trazabilidad_buyer_orders, w_trazabilidad_carts, w_trazabilidad_carts_items, w_trazabilidad_order_items, w_trazabilidad_payment_methods_types, w_trazabilidad_user_payment_methods, w_trazabilidad_users_wishlist_products. No se inventan sus columnas; triggers dependientes pueden fallar.
- Dependencia externa mysql.role_edges: permisos y roles del servidor no se reconstruyen a partir de este respaldo.
- No hay FK para pedidos generales ni ofertas. tb_payments y tb_payment_methods coexisten sin equivalencia formal demostrada.
- No se imponen CHECK de latitud/longitud en este respaldo; no atribuirle las restricciones de respaldos anteriores.
- Moneda MXN es un DEFAULT, no una validación ISO ni moneda obligatoria para importes sin columna currency. No se prueban impuestos ni unidades de inventario.
- Indicadores BIT e is_default: significado funcional pendiente, salvo usos explícitos en rutinas. No se impone un único predeterminado por usuario ni is_default en 0/1.
- No hay regla declarada de coherencia entre cabecera y detalle de devoluciones/cancelaciones, límites frente a unidades compradas, suma de pagos/reembolsos ni secuencia cronológica de fechas.
- No se demuestran dependencias funcionales completas para certificar 3FN/BCNF. PK compuestas y tablas puente favorecen separación de asociaciones; textos de auditoría no sustituyen FK.
- Clasificación conceptual monovalorado/multivalorado, semántica comercial de estados, género, formato de credenciales y políticas de retención requieren responsables del sistema.

## Ejecutar y publicar

Desde `modelo-eer-2710/`: `npm ci`, `npm run dev`. Producci?n: `npm run build` y `npm run preview`. Pruebas: `npm run test:e2e`.

Para GitHub Pages, copiar ?nicamente el contenido de `dist/` a la nueva subcarpeta `docs/modelo-eer-2710/` de la fuente de publicaci?n de la rama Practica03, conservando todos los archivos del diccionario. La base configurada es `/Practicas_BDN_240537/modelo-eer-2710/`. No se modificaron la configuraci?n Pages ni archivos existentes. Ver las instrucciones detalladas en README.
