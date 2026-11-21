-- ============================================================
-- PRACTICA 04 | SIMULACION Y VALIDACION DE LOS CINCO CASOS
-- Referencia: RespaldoFinal_1811.sql
-- DML comentado: reconstruccion de registros, NO historial de ejecucion.
-- No descomentar en la base restaurada: provocaria duplicados.
-- Los SELECT se pueden ejecutar juntos; los roles son ejemplos sujetos a GRANT.
-- No se crean tablas ni se modifica el esquema.
-- ============================================================
USE db_test;
SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT (SELECT COUNT(*) FROM tb_users) usuarios, (SELECT COUNT(*) FROM tb_people) personas;

-- ============================================================
-- CASO 1
-- ============================================================
-- 1. Registrar usuario mediante procedimiento (ejemplo, no ejecutar de nuevo).
-- SET ROLE 'user_not_registered';
-- CALL sp_register_user('cp1@example.invalid','cp1_demo','CLAVE_DE_PRUEBA','Usuario','Simulado',NULL,'2000-01-01',NULL,'52','0000000000');
-- Revisar parametros, genero y permisos antes de ejecutar.
-- SET ROLE 'buyer';

-- 2. Seleccionar productos en wishlist
-- INSERT INTO `tbd_users_wishlist_products`  VALUES (10249,1,b'1','2026-11-04 00:35:06','2026-11-04 00:35:06');
-- INSERT INTO `tbd_users_wishlist_products`  VALUES (10249,2,b'1','2026-11-04 00:35:06','2026-11-04 00:35:06');
-- INSERT INTO `tbd_users_wishlist_products`  VALUES (10249,3,b'1','2026-11-04 00:35:06','2026-11-04 00:35:06');
-- INSERT INTO `tbd_users_wishlist_products`  VALUES (10249,4,b'1','2026-11-04 00:35:06','2026-11-04 00:35:06');
-- INSERT INTO `tbd_users_wishlist_products`  VALUES (10249,5,b'1','2026-11-04 00:35:06','2026-11-04 00:35:06');

-- 3. Crear carrito
-- INSERT INTO `tb_carts`  VALUES (3,10249,b'1','2026-11-04 00:44:56',NULL);

-- 4. Agregar productos y cantidades
-- INSERT INTO `tbd_carts_items`  VALUES (3,2,1,1,'2026-11-04 02:27:00');
-- INSERT INTO `tbd_carts_items`  VALUES (3,2,2,2,'2026-11-04 02:27:00');
-- INSERT INTO `tbd_carts_items`  VALUES (3,2,3,3,'2026-11-04 02:27:00');
-- INSERT INTO `tbd_carts_items`  VALUES (3,2,4,2,'2026-11-04 02:27:00');
-- INSERT INTO `tbd_carts_items`  VALUES (3,2,5,1,'2026-11-04 02:27:00');

-- 5. Registrar orden inicialmente pendiente
-- INSERT INTO `tb_buyer_orders`  VALUES (1,1,2,22800.00,0.00,'Pending','2026-11-04 02:29:06','2026-11-04 03:48:00');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (5,1,1,'Laptop Lenovo IdeaPad',1,12500.00,'2026-11-04 02:38:55');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (6,1,2,'Mouse Logitech M185',2,350.00,'2026-11-04 02:38:55');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (7,1,3,'Teclado Mecánico RGB',3,850.00,'2026-11-04 02:38:55');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (8,1,4,'Monitor Samsung 24\"',2,3200.00,'2026-11-04 02:38:55');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (9,1,5,'Audífonos Bluetooth',1,650.00,'2026-11-04 02:38:55');

-- 6. Registrar domicilio (datos omitidos por privacidad)
-- SELECT ID,address_label FROM tb_user_addresses WHERE ID=1 AND user_ID=10249;

-- 7. Registrar metodo de pago dependiente
-- INSERT INTO `tbd_user_payment_methods`  VALUES (1,10249,2,'BBVA','0000000000009876','Tarjeta de débito BBVA','9876',1,b'1','2026-11-04 03:14:52',NULL);

-- 8. Registrar pago o cupon
-- INSERT INTO `tb_payment_methods`  VALUES (4,1,10249,2,'SIM-CP1-DEBIT',22800,'MXN','Paid','2026-11-04 03:36:00','Pago simulado único',b'1','2026-11-18 23:35:00',NULL);
-- INSERT INTO `tb_payments`  VALUES (1,1,22800.00,'MXN','Card','BBVA','SIM-BBVA-10249-001','Paid','2026-11-04 03:34:06','2026-11-04 03:36:00','2026-11-04 03:35:24');
-- INSERT INTO `tb_payment_transactions`  VALUES (1,1,'Authorized',22800.00,'AUTH-BBVA-10249-001','Autorizacion bancaria simulada del usuario 10249','2026-11-04 03:35:12');
-- INSERT INTO `tb_payment_transactions`  VALUES (20,1,'Captured',22800,'SIM-CP1-CAPTURE','Captura simulada','2026-11-04 03:36:00');

-- 9. Sistema atiende la orden (rol sujeto a permisos).
-- UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=1;

-- 10. Envio y entrega
-- INSERT INTO `tb_shipments`  VALUES (5,1,1,'SIMULADO','SIM-CP1-ENTREGA',0,'Delivered','2026-11-04 03:40:00',NULL,'2026-11-04 03:48:00',b'1','2026-11-18 23:35:00',NULL);
-- UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=1;

-- CONSULTAS PARA VERIFICAR EL CASO 1 (ejecutables)
SELECT 'CP1: Compra exitosa' AS caso_de_prueba;

SELECT 1 AS caso,u.ID,u.nick,p.person_ID FROM tb_users u LEFT JOIN tb_people p ON p.user_ID=u.ID WHERE u.ID=10249;

SELECT * FROM tb_carts WHERE ID=3 AND user_ID=10249;

SELECT i.*,p.name,p.current_stock,p.status FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=3;

SELECT COUNT(DISTINCT product_ID) productos,MIN(quantity) minimo,MAX(quantity) maximo,COUNT(DISTINCT provider_ID) proveedores FROM tbd_carts_items WHERE cart_ID=3;

SELECT * FROM tb_buyer_orders WHERE ID=1;

SELECT * FROM tbd_order_items WHERE seller_order_ID=1;

SELECT * FROM tb_user_addresses WHERE ID=1 AND user_ID=10249;

SELECT ID,user_ID,provider,label,CHAR_LENGTH(provider_method_ref) longitud FROM tbd_user_payment_methods WHERE user_ID=10249 AND ID IN (1);

SELECT * FROM tb_payment_methods WHERE order_ID=1;

SELECT * FROM tb_payments WHERE order_ID=1;

SELECT t.* FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=1;

SELECT * FROM tb_shipments WHERE buyer_order_ID=1;

SELECT description FROM tb_logs WHERE db_users='SIMULACION' AND description LIKE 'CP1 %';

SELECT * FROM tbd_users_wishlist_products WHERE user_ID=10249;



-- ============================================================
-- CASO 2
-- ============================================================
-- 1. Seleccionar usuario existente: 26.
-- SET ROLE 'buyer';

-- 3. Crear carrito
-- INSERT INTO `tb_carts`  VALUES (7,26,b'1','2026-11-18 16:48:43',NULL);

-- 4. Agregar productos y cantidades
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,1,3,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,2,4,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,3,5,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,4,2,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,5,2,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,6,1,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,7,1,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,8,1,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,9,1,'2026-11-18 16:48:50');
-- INSERT INTO `tbd_carts_items`  VALUES (7,2,10,1,'2026-11-18 16:48:50');

-- 5. Registrar orden inicialmente pendiente
-- INSERT INTO `tb_buyer_orders`  VALUES (2,7,2,110849.49,150.00,'Pending','2026-11-18 16:49:17','2026-11-18 16:52:04');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (12,2,1,'Laptop Lenovo IdeaPad',3,12500.00,'2026-11-18 16:49:26');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (13,2,2,'Mouse Logitech M185',4,350.00,'2026-11-18 16:49:26');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (14,2,3,'Teclado Mecánico RGB',5,850.00,'2026-11-18 16:49:26');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (15,2,4,'Monitor Samsung 24\"',2,3200.00,'2026-11-18 16:49:26');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (16,2,5,'Audífonos Bluetooth',2,650.00,'2026-11-18 16:49:26');
-- INSERT INTO `tbd_order_items` (ID,seller_order_ID,product_offer_ID,product_name,quantity,unit_price,creation_date) VALUES (26,2,6,'Laptop Dell XPS 13',1,24999,'2026-11-18 23:35:00');
-- INSERT INTO `tbd_order_items` (ID,seller_order_ID,product_offer_ID,product_name,quantity,unit_price,creation_date) VALUES (27,2,7,'Smartphone Samsung S23',1,18500.50,'2026-11-18 23:35:00');
-- INSERT INTO `tbd_order_items` (ID,seller_order_ID,product_offer_ID,product_name,quantity,unit_price,creation_date) VALUES (28,2,8,'Audífonos Sony WH-1000XM5',1,6800,'2026-11-18 23:35:00');
-- INSERT INTO `tbd_order_items` (ID,seller_order_ID,product_offer_ID,product_name,quantity,unit_price,creation_date) VALUES (29,2,9,'Monitor LG 27 Pulgadas',1,7499.99,'2026-11-18 23:35:00');
-- INSERT INTO `tbd_order_items` (ID,seller_order_ID,product_offer_ID,product_name,quantity,unit_price,creation_date) VALUES (30,2,10,'Teclado Mecánico Logitech',1,2200,'2026-11-18 23:35:00');

-- 6. Registrar domicilio (datos omitidos por privacidad)
-- SELECT ID,address_label FROM tb_user_addresses WHERE ID=3 AND user_ID=26;

-- 7. Registrar metodo de pago dependiente
-- INSERT INTO `tbd_user_payment_methods`  VALUES (2,26,5,'Visa Simulated','4532890123456789','Tarjeta de Crédito Personal','6789',1,b'1','2026-11-18 16:50:44',NULL);

-- 8. Registrar pago o cupon
-- INSERT INTO `tb_payment_methods`  VALUES (5,2,26,5,'SIM-CP2-CREDIT',110999.49,'MXN','Authorized','2026-11-18 23:35:00','Cinco mensualidades cobradas, sexta rechazada',b'1','2026-11-18 23:35:00',NULL);
-- INSERT INTO `tb_payments`  VALUES (2,2,110999.49,'MXN','Card','Visa Simulated','PAY-10261-6MONTHS','Authorized','2026-11-18 16:51:08',NULL,NULL);
-- INSERT INTO `tb_payment_transactions`  VALUES (2,2,'Captured',18499.92,'TRX-10261-MS-1','Mensualidad 1 de 6 cobrada con éxito','2026-11-18 16:51:20');
-- INSERT INTO `tb_payment_transactions`  VALUES (3,2,'Captured',18499.92,'TRX-10261-MS-2','Mensualidad 2 de 6 cobrada con éxito','2026-12-18 16:51:20');
-- INSERT INTO `tb_payment_transactions`  VALUES (4,2,'Captured',18499.92,'TRX-10261-MS-3','Mensualidad 3 de 6 cobrada con éxito','2027-01-18 16:51:20');
-- INSERT INTO `tb_payment_transactions`  VALUES (5,2,'Captured',18499.92,'TRX-10261-MS-4','Mensualidad 4 de 6 cobrada con éxito','2027-02-18 16:51:20');
-- INSERT INTO `tb_payment_transactions`  VALUES (6,2,'Captured',18499.92,'TRX-10261-MS-5','Mensualidad 5 de 6 cobrada con éxito','2027-03-18 16:51:20');
-- INSERT INTO `tb_payment_transactions`  VALUES (9,2,'Authorized',18499.92,'TRX-10261-AUTH-1','Transacción 1 de 6 autorizada','2026-11-18 16:51:37');
-- INSERT INTO `tb_payment_transactions`  VALUES (10,2,'Authorized',18499.92,'TRX-10261-AUTH-2','Transacción 2 de 6 autorizada','2026-12-18 16:51:37');
-- INSERT INTO `tb_payment_transactions`  VALUES (11,2,'Authorized',18499.92,'TRX-10261-AUTH-3','Transacción 3 de 6 autorizada','2027-01-18 16:51:37');
-- INSERT INTO `tb_payment_transactions`  VALUES (12,2,'Authorized',18499.92,'TRX-10261-AUTH-4','Transacción 4 de 6 autorizada','2027-02-18 16:51:37');
-- INSERT INTO `tb_payment_transactions`  VALUES (13,2,'Authorized',18499.92,'TRX-10261-AUTH-5','Transacción 5 de 6 autorizada','2027-03-18 16:51:37');
-- INSERT INTO `tb_payment_transactions`  VALUES (16,2,'Failed',18499.89,'TRX-10261-AUTH-6','Límite excedido de crédito','2027-04-18 16:51:40');

-- 9. Sistema atiende la orden (rol sujeto a permisos).
-- UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=2;

-- 10. Entrega inicial
-- INSERT INTO `tb_shipments`  VALUES (1,2,3,'DHL Express','TRK-10261-P8',150.00,'Delivered','2026-11-18 16:52:39',NULL,'2026-11-18 16:52:39',b'1','2026-11-18 16:52:39',NULL);

-- 11. Devolucion por dano
-- INSERT INTO `tb_returns`  VALUES (2,2,16,26,1,'El producto llegó dañado de origen','Completed','2026-11-18 16:53:17',NULL,NULL,'Reenvío de producto de reemplazo autorizado y entregado',b'1','2026-11-18 16:53:17','2026-11-18 16:53:32');
-- INSERT INTO `tbd_return_items`  VALUES (1,2,16,1,650.00,'El producto llegó dañado de origen','Damaged',b'1','2026-11-18 23:30:57',NULL);

-- 12. Reenvio
-- INSERT INTO `tb_shipments`  VALUES (2,2,3,'DHL Express','TRK-10261-REPLACEMENT',0.00,'Delivered','2026-11-18 16:53:37',NULL,'2026-11-18 16:53:37',b'1','2026-11-18 16:53:37',NULL);
-- UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=2;

-- CONSULTAS PARA VERIFICAR EL CASO 2 (ejecutables)
SELECT 'CP2: Credito y devolucion' AS caso_de_prueba;

SELECT 2 AS caso,u.ID,u.nick,p.person_ID FROM tb_users u LEFT JOIN tb_people p ON p.user_ID=u.ID WHERE u.ID=26;

SELECT * FROM tb_carts WHERE ID=7 AND user_ID=26;

SELECT i.*,p.name,p.current_stock,p.status FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=7;

SELECT COUNT(DISTINCT product_ID) productos,MIN(quantity) minimo,MAX(quantity) maximo,COUNT(DISTINCT provider_ID) proveedores FROM tbd_carts_items WHERE cart_ID=7;

SELECT * FROM tb_buyer_orders WHERE ID=2;

SELECT * FROM tbd_order_items WHERE seller_order_ID=2;

SELECT * FROM tb_user_addresses WHERE ID=3 AND user_ID=26;

SELECT ID,user_ID,provider,label,CHAR_LENGTH(provider_method_ref) longitud FROM tbd_user_payment_methods WHERE user_ID=26 AND ID IN (2);

SELECT * FROM tb_payment_methods WHERE order_ID=2;

SELECT * FROM tb_payments WHERE order_ID=2;

SELECT t.* FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=2;

SELECT * FROM tb_shipments WHERE buyer_order_ID=2;

SELECT description FROM tb_logs WHERE db_users='SIMULACION' AND description LIKE 'CP2 %';

SELECT t.event_type,COUNT(*) total FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=2 GROUP BY t.event_type;

SELECT * FROM tb_returns WHERE buyer_order_ID=2;

SELECT i.* FROM tbd_return_items i JOIN tb_returns r ON r.ID=i.return_ID WHERE r.buyer_order_ID=2;



-- ============================================================
-- CASO 3
-- ============================================================
-- 1. Seleccionar usuario existente: 9.
-- SET ROLE 'buyer';

-- 3. Crear carrito
-- INSERT INTO `tb_carts`  VALUES (6,9,b'1','2026-11-18 22:58:50',NULL);

-- 4. Agregar productos y cantidades
-- INSERT INTO `tbd_carts_items`  VALUES (6,2,6,2,'2026-11-18 22:58:58');
-- INSERT INTO `tbd_carts_items`  VALUES (6,2,7,5,'2026-11-18 22:58:58');
-- INSERT INTO `tbd_carts_items`  VALUES (6,2,9,4,'2026-11-18 22:58:58');

-- 5. Registrar orden inicialmente pendiente
-- INSERT INTO `tb_buyer_orders`  VALUES (4,9,2,79997.96,99.00,'Pending','2026-11-18 23:08:06','2026-11-18 23:12:24');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (19,4,6,'Laptop Dell XPS 13',2,24999.00,'2026-11-18 23:08:06');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (20,4,7,'Smartphone Samsung S23',5,18500.50,'2026-11-18 23:08:06');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (21,4,9,'Monitor LG 27 Pulgadas',4,7499.99,'2026-11-18 23:08:06');

-- 6. Registrar domicilio (datos omitidos por privacidad)
-- SELECT ID,address_label FROM tb_user_addresses WHERE ID=5 AND user_ID=9;

-- 7. Registrar metodo de pago dependiente
-- INSERT INTO `tbd_user_payment_methods`  VALUES (3,9,6,'Spin','4213160098765432','Tarjeta Digital Spin','5432',0,b'1','2026-11-18 23:11:38','2026-11-18 23:11:38');

-- 8. Registrar pago o cupon
-- INSERT INTO `tb_payment_methods`  VALUES (1,4,9,1,'CASH-4-CP3',172599.46,'MXN','Paid','2026-11-18 23:12:24','Pago en efectivo caso de prueba 3',b'1','2026-11-18 23:12:24','2026-11-18 23:12:24');
-- INSERT INTO `tb_payments`  VALUES (4,4,172599.46,'MXN','Cash','OXXO Pay','CASH-4-CP3','PartiallyRefunded','2026-11-18 23:12:24','2026-11-18 23:12:24','2026-11-18 23:12:24');
-- INSERT INTO `tb_payment_transactions`  VALUES (17,4,'Captured',172599.46,'TXN-CASH-4','Pago único en efectivo confirmado por el total de la orden','2026-11-18 23:12:24');
-- INSERT INTO `tb_payment_transactions`  VALUES (18,4,'PartiallyRefunded',92502.50,'TXN-REF-4','Reembolso parcial por cancelación de producto ID 7','2026-11-18 23:12:24');

-- 9. Sistema atiende la orden (rol sujeto a permisos).
-- UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=4;

-- 10. Cancelar producto
-- INSERT INTO `tb_cancellations`  VALUES (1,4,9,'El cliente solicitó cancelar el producto ID 7 antes del envío','Completed','2026-11-18 23:12:24','2026-11-18 23:12:24','Cancelación parcial aprobada',b'1','2026-11-18 23:12:24','2026-11-18 23:12:24');
-- INSERT INTO `tbd_cancellation_items`  VALUES (1,1,20,5,18500.50,'Cancelación parcial de ítem antes de despacho',b'1','2026-11-18 23:12:24',NULL);
-- UPDATE tb_buyer_orders SET subtotal=79997.96 WHERE ID=4;

-- 11. Reembolso parcial
-- INSERT INTO `tb_refunds`  VALUES (1,4,1,NULL,92502.50,'MXN','Reembolso por cancelación parcial del producto ID 7','Completed','REF-4-CP3','2026-11-18 23:12:24','2026-11-18 23:12:24','Reembolso procesado exitosamente',b'1','2026-11-18 23:12:24','2026-11-18 23:12:24');

-- 12. Envio y entrega
-- INSERT INTO `tb_shipments`  VALUES (3,4,5,'Estafeta','EST-4-CP3',99.00,'Delivered','2026-11-18 23:12:24','2026-11-20 23:12:24','2026-11-18 23:12:24',b'1','2026-11-18 23:12:24','2026-11-18 23:12:24');
-- UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=4;

-- CONSULTAS PARA VERIFICAR EL CASO 3 (ejecutables)
SELECT 'CP3: Cancelacion parcial' AS caso_de_prueba;

SELECT 3 AS caso,u.ID,u.nick,p.person_ID FROM tb_users u LEFT JOIN tb_people p ON p.user_ID=u.ID WHERE u.ID=9;

SELECT * FROM tb_carts WHERE ID=6 AND user_ID=9;

SELECT i.*,p.name,p.current_stock,p.status FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=6;

SELECT COUNT(DISTINCT product_ID) productos,MIN(quantity) minimo,MAX(quantity) maximo,COUNT(DISTINCT provider_ID) proveedores FROM tbd_carts_items WHERE cart_ID=6;

SELECT * FROM tb_buyer_orders WHERE ID=4;

SELECT * FROM tbd_order_items WHERE seller_order_ID=4;

SELECT * FROM tb_user_addresses WHERE ID=5 AND user_ID=9;

SELECT ID,user_ID,provider,label,CHAR_LENGTH(provider_method_ref) longitud FROM tbd_user_payment_methods WHERE user_ID=9 AND ID IN (3);

SELECT * FROM tb_payment_methods WHERE order_ID=4;

SELECT * FROM tb_payments WHERE order_ID=4;

SELECT t.* FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=4;

SELECT * FROM tb_shipments WHERE buyer_order_ID=4;

SELECT description FROM tb_logs WHERE db_users='SIMULACION' AND description LIKE 'CP3 %';

SELECT category_ID,COUNT(DISTINCT p.product_ID) productos FROM tbd_products_categories p JOIN tbd_carts_items i ON i.product_ID=p.product_ID WHERE i.cart_ID=6 AND p.status=b'1' GROUP BY category_ID HAVING COUNT(DISTINCT p.product_ID)=3;

SELECT r.* FROM tb_refunds r JOIN tb_payments p ON p.ID=r.payment_ID WHERE p.order_ID=4;

SELECT * FROM tb_cancellations WHERE buyer_order_ID=4;

SELECT i.* FROM tbd_cancellation_items i JOIN tb_cancellations c ON c.ID=i.cancellation_ID WHERE c.buyer_order_ID=4;



-- ============================================================
-- CASO 4
-- ============================================================
-- 1. Seleccionar usuario existente: 5.
-- SET ROLE 'buyer';

-- 3. Crear carrito
-- INSERT INTO `tb_carts`  VALUES (8,5,b'1','2026-11-18 23:24:23',NULL);

-- 4. Agregar productos y cantidades
-- INSERT INTO `tbd_carts_items`  VALUES (8,2,1,1,'2026-11-18 23:24:23');
-- INSERT INTO `tbd_carts_items`  VALUES (8,2,2,2,'2026-11-18 23:24:23');
-- INSERT INTO `tbd_carts_items`  VALUES (8,2,3,3,'2026-11-18 23:24:23');

-- 5. Registrar orden inicialmente pendiente
-- INSERT INTO `tb_buyer_orders`  VALUES (5,10,2,15750.00,85.00,'Pending','2026-11-18 23:24:23','2026-11-18 23:24:23');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (22,5,1,'Laptop Lenovo IdeaPad',1,12500.00,'2026-11-18 23:24:23');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (23,5,2,'Mouse Logitech M185',2,350.00,'2026-11-18 23:24:23');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (24,5,3,'Teclado Mecánico RGB',3,850.00,'2026-11-18 23:24:23');

-- 6. Registrar domicilio (datos omitidos por privacidad)
-- SELECT ID,address_label FROM tb_user_addresses WHERE ID=6 AND user_ID=5;

-- 7. Registrar metodo de pago dependiente
-- INSERT INTO `tbd_user_payment_methods`  VALUES (4,5,3,'SPEI','6461801104000012','Cuenta Transferencia SPEI','0012',1,b'1','2026-11-18 23:24:23','2026-11-18 23:24:23');

-- 8. Registrar pago o cupon
-- INSERT INTO `tb_payment_methods`  VALUES (2,5,5,1,'CASH-5-CP4',15835.00,'MXN','Paid','2026-11-18 23:24:23','Pago único en efectivo caso de prueba 4',b'1','2026-11-18 23:24:23','2026-11-18 23:24:23');
-- INSERT INTO `tb_payments`  VALUES (5,5,15835.00,'MXN','Cash','OXXO Pay','CASH-5-CP4','Paid','2026-11-18 23:24:23','2026-11-18 23:24:23','2026-11-18 23:24:23');
-- INSERT INTO `tb_payment_transactions`  VALUES (19,5,'Captured',15835.00,'TXN-CASH-5','Pago único en efectivo por el total de la compra CP4','2026-11-18 23:24:23');

-- 9. Sistema atiende la orden (rol sujeto a permisos).
-- UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=5;

-- 10. Envio y entrega
-- INSERT INTO `tb_shipments`  VALUES (4,5,6,'DHL','DHL-5-CP4',85.00,'Delivered','2026-11-18 23:24:23','2026-11-19 23:24:23','2026-11-18 23:24:23',b'1','2026-11-18 23:24:23','2026-11-18 23:24:23');
-- UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=5;

-- CONSULTAS PARA VERIFICAR EL CASO 4 (ejecutables)
SELECT 'CP4: Punto de recoleccion' AS caso_de_prueba;

SELECT 4 AS caso,u.ID,u.nick,p.person_ID FROM tb_users u LEFT JOIN tb_people p ON p.user_ID=u.ID WHERE u.ID=5;

SELECT * FROM tb_carts WHERE ID=8 AND user_ID=5;

SELECT i.*,p.name,p.current_stock,p.status FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=8;

SELECT COUNT(DISTINCT product_ID) productos,MIN(quantity) minimo,MAX(quantity) maximo,COUNT(DISTINCT provider_ID) proveedores FROM tbd_carts_items WHERE cart_ID=8;

SELECT * FROM tb_buyer_orders WHERE ID=5;

SELECT * FROM tbd_order_items WHERE seller_order_ID=5;

SELECT * FROM tb_user_addresses WHERE ID=6 AND user_ID=5;

SELECT ID,user_ID,provider,label,CHAR_LENGTH(provider_method_ref) longitud FROM tbd_user_payment_methods WHERE user_ID=5 AND ID IN (4);

SELECT * FROM tb_payment_methods WHERE order_ID=5;

SELECT * FROM tb_payments WHERE order_ID=5;

SELECT t.* FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=5;

SELECT * FROM tb_shipments WHERE buyer_order_ID=5;

SELECT description FROM tb_logs WHERE db_users='SIMULACION' AND description LIKE 'CP4 %';



-- ============================================================
-- CASO 5
-- ============================================================
-- 1. Seleccionar usuario existente: 6.
-- SET ROLE 'buyer';

-- 3. Crear carrito
-- INSERT INTO `tb_carts`  VALUES (9,6,b'1','2026-11-18 23:25:21',NULL);

-- 4. Agregar productos y cantidades
-- INSERT INTO `tbd_carts_items`  VALUES (9,2,4,3,'2026-11-18 23:25:21');

-- 5. Registrar orden inicialmente pendiente
-- INSERT INTO `tb_buyer_orders`  VALUES (6,11,2,9600.00,75.00,'Pending','2026-11-18 23:25:21','2026-11-18 23:25:21');
-- INSERT INTO `tbd_order_items` (`ID`, `seller_order_ID`, `product_offer_ID`, `product_name`, `quantity`, `unit_price`, `creation_date`) VALUES (25,6,4,'Monitor Samsung 24\"',3,3200.00,'2026-11-18 23:25:21');

-- 6. Registrar domicilio (datos omitidos por privacidad)
-- SELECT ID,address_label FROM tb_user_addresses WHERE ID=7 AND user_ID=6;

-- 7. Registrar metodo de pago dependiente
-- INSERT INTO `tbd_user_payment_methods`  VALUES (5,6,4,'GiftCoupon','GIFT-2026-9988','Cupón de Regalo $10,000','9988',1,b'0','2026-11-18 23:25:21','2026-11-18 23:25:21');

-- 8. Registrar pago o cupon
-- INSERT INTO `tb_payment_methods`  VALUES (3,6,6,4,'GIFT-2026-9988',9675.00,'MXN','Cancelled','2026-11-18 23:25:21','Cargo anulado: cupón de regalo reasignado al usuario por falta de inventario',b'1','2026-11-18 23:25:21','2026-11-18 23:25:21');
-- No se localizaron registros en tb_payments para este paso.

-- 9. Cancelar por falta de inventario
-- INSERT INTO `tb_cancellations`  VALUES (2,6,6,'Orden no atendida por falta de inventario (solicitadas 3 unidades, disponibles 1)','Completed','2026-11-18 23:25:21','2026-11-18 23:25:21','Sistema cancela orden automáticamente por quiebre de stock',b'1','2026-11-18 23:25:21','2026-11-18 23:25:21');
-- INSERT INTO `tbd_cancellation_items`  VALUES (2,2,25,3,3200.00,'Stock insuficiente en almacén del proveedor',b'1','2026-11-18 23:25:21',NULL);
-- UPDATE tb_buyer_orders SET fulfillment_status='Canceled' WHERE ID=6;

-- 10. Reasignar cupon
-- INSERT INTO `tbd_user_payment_methods`  VALUES (6,6,4,'GiftCoupon','GIFT-2026-9988-REASIG','Cupón de Regalo $10,000 (Reasignado - Disponible)','9988',1,b'1','2026-11-18 23:25:48','2026-11-18 23:25:48');

-- CONSULTAS PARA VERIFICAR EL CASO 5 (ejecutables)
SELECT 'CP5: Inventario insuficiente' AS caso_de_prueba;

SELECT 5 AS caso,u.ID,u.nick,p.person_ID FROM tb_users u LEFT JOIN tb_people p ON p.user_ID=u.ID WHERE u.ID=6;

SELECT * FROM tb_carts WHERE ID=9 AND user_ID=6;

SELECT i.*,p.name,p.current_stock,p.status FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=9;

SELECT COUNT(DISTINCT product_ID) productos,MIN(quantity) minimo,MAX(quantity) maximo,COUNT(DISTINCT provider_ID) proveedores FROM tbd_carts_items WHERE cart_ID=9;

SELECT * FROM tb_buyer_orders WHERE ID=6;

SELECT * FROM tbd_order_items WHERE seller_order_ID=6;

SELECT * FROM tb_user_addresses WHERE ID=7 AND user_ID=6;

SELECT ID,user_ID,provider,label,CHAR_LENGTH(provider_method_ref) longitud FROM tbd_user_payment_methods WHERE user_ID=6 AND ID IN (5,6);

SELECT * FROM tb_payment_methods WHERE order_ID=6;

SELECT * FROM tb_payments WHERE order_ID=6;

SELECT t.* FROM tb_payment_transactions t JOIN tb_payments p ON p.ID=t.payment_ID WHERE p.order_ID=6;

SELECT * FROM tb_shipments WHERE buyer_order_ID=6;

SELECT description FROM tb_logs WHERE db_users='SIMULACION' AND description LIKE 'CP5 %';

SELECT * FROM tb_cancellations WHERE buyer_order_ID=6;

SELECT i.* FROM tbd_cancellation_items i JOIN tb_cancellations c ON c.ID=i.cancellation_ID WHERE c.buyer_order_ID=6;

-- CP5: comparacion con inventario actual (no historico)
SELECT i.product_ID,i.quantity,p.current_stock,CASE WHEN i.quantity>p.current_stock THEN 'INSUFICIENTE ACTUAL' ELSE 'SUFICIENTE ACTUAL' END AS resultado FROM tbd_carts_items i JOIN tb_products p ON p.ID=i.product_ID WHERE i.cart_ID=9;

