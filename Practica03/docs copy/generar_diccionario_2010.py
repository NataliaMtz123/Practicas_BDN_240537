"""Análisis estático: nunca conecta a MySQL ni ejecuta SQL."""
from pathlib import Path
import re, hashlib, json, html

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'Practica03/backups/Respaldo_2010.sql'
raw = SRC.read_bytes()
s = raw.decode('utf-8-sig').replace('\r\n', '\n')
digest = hashlib.sha256(raw).hexdigest()
def line(pos): return s.count('\n', 0, pos)+1
def names(v): return re.findall(r'`([^`]+)`',v)
def code(v): return '`'+str(v).replace('|','&#124;')+'`'
out=[]
def add(v=''): out.append(v)
def table(headers, rows):
    add('| '+' | '.join(headers)+' |\n| '+' | '.join(['---']*len(headers))+' |')
    for row in rows: add('| '+' | '.join(str(x).replace('\n','<br>').replace('|','&#124;') for x in row)+' |')
    add()

meta={
'tb_buyer_orders':('Pedidos desglosados por vendedor','transaccional','Dar seguimiento al cumplimiento y a los importes de una parte del pedido asignada a un vendedor. El nombre buyer no determina por sí solo el comprador; la FK apunta al vendedor.'),
'tb_carts':('Carritos de usuarios','maestra/transaccional','Conservar un carrito por usuario como máximo y servir de cabecera lógica para sus artículos.'),
'tb_logs':('Bitácora general de operaciones','auditoría','Registrar operaciones y la cuenta de conexión que las realizó; soportar las consultas de trazabilidad.'),
'tb_products':('Productos comercializables','maestra','Mantener la descripción comercial, SKU, precio y existencias actuales de cada producto.'),
'tb_user_addresses':('Direcciones de usuarios','maestra','Administrar destinos de entrega, destinatario y coordenadas asociados a una cuenta.'),
'tb_users':('Cuentas de usuarios de la aplicación','maestra','Mantener identidad de acceso y estado de cuentas que participan en carritos, direcciones y provisión de productos.'),
'tbc_categories':('Categorías jerárquicas de productos','catálogo','Organizar productos en categorías con una categoría superior opcional.'),
'tbc_payment_methods_types':('Tipos de métodos de pago','catálogo','Clasificar los instrumentos de pago registrados por los usuarios mediante códigos únicos.'),
'tbd_address_components':('Componentes jerárquicos de una dirección','detalle','Descomponer direcciones en componentes tipificados y organizar su jerarquía dentro de la misma dirección.'),
'tbd_carts_items':('Artículos de carrito por proveedor y producto','detalle/intermedia lógica','Representar la cantidad seleccionada de un producto ofrecido por un proveedor dentro de un carrito; no existen FK que aseguren esa interpretación.'),
'tbd_order_items':('Partidas de pedidos por vendedor','detalle','Conservar cantidades, nombre de producto y precio unitario de las partidas y calcular su subtotal.'),
'tbd_products_categories':('Asignación de productos a categorías','intermedia','Clasificar un producto en varias categorías y reunir varios productos en cada categoría.'),
'tbd_products_users_providers':('Vínculos de productos con usuarios proveedores','intermedia','Asociar usuarios con productos y registrar el tipo de participación comercial y fecha de disponibilidad.'),
'tbd_user_payment_methods':('Instrumentos de pago de usuarios','detalle','Vincular referencias de instrumentos gestionadas por proveedores de pago con cuentas y tipos de método.'),
'tbd_users_wishlist_products':('Productos deseados por usuarios','intermedia lógica','Representar preferencias de productos por usuario; la integridad de los vínculos no está declarada con FK.')}

meaning={
'order_ID':'Pedido general al que parece pertenecer el desglose; la entidad de cabecera no está definida y la referencia no está validada por FK',
'seller_ID':'Usuario que participa como vendedor del desglose del pedido; la FK no valida un rol comercial',
'user_ID':'Usuario al que pertenece o con el que se asocia la entidad de esta tabla',
'product_ID':'Producto incluido en la asociación o selección representada por esta tabla',
'category_ID':'Categoría asignada al producto en esta asociación',
'cart_ID':'Carrito al que parece pertenecer la selección de producto; sin FK',
'provider_ID':'Proveedor asociado a la selección del carrito; su correspondencia con tb_users es inferida',
'seller_order_ID':'Desglose del pedido por vendedor al que pertenece la partida, referenciado en tb_buyer_orders',
'product_offer_ID':'Oferta comercial asociada a la partida; no hay entidad de ofertas ni FK que determine su destino',
'address_ID':'Dirección a la que pertenece el componente',
'address_sup_ID':'Componente superior opcional dentro de la misma dirección',
'sup_id_category':'Categoría superior opcional que estructura la jerarquía del catálogo',
'payment_method_type_ID':'Tipo de método que clasifica el instrumento de pago del usuario',
'SKU':'Código comercial que distingue de forma única cada producto',
'name':'Nombre visible de la entidad descrita por esta tabla',
'description':'Descripción ampliada de la entidad o de la operación auditada según la tabla',
'email':'Dirección de correo utilizada para distinguir la cuenta de usuario; no se valida su sintaxis',
'nick':'Alias único de la cuenta de usuario',
'password':'Representación de la credencial de acceso de la cuenta; el SQL no determina algoritmo de hash ni cifrado',
'current_price':'Precio actual del producto; moneda, impuestos y vigencia comercial no determinados',
'current_stock':'Cantidad de existencias actuales del producto; unidad de medida no determinada',
'subtotal':'Importe parcial del desglose o de la partida; moneda y tratamiento fiscal no determinados',
'shipping_cost':'Costo de envío asignado al desglose por vendedor; moneda no determinada',
'quantity':'Cantidad de unidades del producto incluidas en el carrito o partida',
'unit_price':'Precio por unidad conservado en la partida del pedido; moneda no determinada',
'fulfillment_status':'Estado de cumplimiento del pedido por vendedor; los literales constan en el tipo ENUM, sin reglas de transición',
'creation_date':'Momento de creación de la entidad representada por esta tabla',
'last_update':'Marca temporal de modificación de la entidad representada por esta tabla',
'last_login':'Momento registrado del último acceso de la cuenta; no hay actualización automática declarada',
'operation_date':'Momento en que se registra la operación en la bitácora',
'status':'Indicador de estado de la entidad; el significado de sus bits no se generaliza sin evidencia adicional',
'operation_status':'Indicador asociado al resultado o estado de la operación auditada; convención completa no determinada',
'table_name':'Nombre textual de la tabla afectada por la operación de bitácora',
'operation':'Clase de operación de bitácora entre Create, Read, Update y Delete; no demuestra que todas sean capturadas automáticamente',
'db_users':'Cuenta de conexión a MySQL asociada a la operación; distinta de una FK a usuarios de la aplicación',
'address_label':'Etiqueta reconocible por el usuario para distinguir una dirección',
'recipient_name':'Nombre del destinatario de la entrega en esta dirección',
'recipient_phone':'Teléfono de contacto del destinatario; se conserva como texto sin validación de formato',
'delivery_instructions':'Indicaciones de entrega asociadas a la dirección',
'latitude':'Coordenada de latitud de la dirección, limitada entre -90 y 90',
'longitude':'Coordenada de longitud de la dirección, limitada entre -180 y 180',
'is_default':'Indicador propuesto de selección predeterminada de dirección o método de pago; 0 y 1 no están limitados mediante CHECK',
'code':'Código único que identifica un tipo de método de pago',
'value':'Contenido textual del componente de dirección; significado concreto depende de component_type',
'component_type':'Nombre del tipo de componente de dirección; sin catálogo ni enumeración de valores autorizados',
'product_name':'Nombre del producto conservado en la partida; su uso como instantánea histórica es inferido',
'type_ownership':'Tipo de participación del usuario respecto al producto: Owner, Reseller o Distributor; admite ausencia de clasificación',
'avalaible_date':'Fecha y hora de disponibilidad del producto para el usuario proveedor; se conserva la grafía original',
'provider':'Nombre o código del proveedor que gestiona el instrumento de pago',
'provider_method_ref':'Referencia del instrumento dentro del proveedor de pagos; no se determina si es token ni su mecanismo de protección',
'label':'Etiqueta opcional para reconocer el instrumento de pago',
'last_four':'Cuatro caracteres finales del instrumento de pago; no existe CHECK de contenido numérico'}

tables=[]; fks=[]; indexes=[]; checks=[]
for m in re.finditer(r'CREATE TABLE `([^`]+)` \(\n(.*?)\n\) (ENGINE=.*?);',s,re.S):
    t={'name':m[1],'line':line(m.start()),'ddl':m[0],'options':m[3],'cols':[],'pk':[],'indexes':[],'fks':[],'checks':[]}
    for v in m[2].splitlines():
        v=v.strip().rstrip(',')
        cm=re.match(r'`([^`]+)` (.*)',v)
        if cm:
            n,d=cm.groups(); typ=re.split(r'\s+(?:CHARACTER SET|COLLATE|NOT NULL|NULL|DEFAULT|AUTO_INCREMENT|ON UPDATE|GENERATED)\b',d,1,flags=re.I)[0]
            dm=re.search(r"\bDEFAULT\s+(b'[^']*'|'(?:[^']|'')*'|CURRENT_TIMESTAMP(?:\(\))?|NULL|[^\s,]+)",d,re.I)
            t['cols'].append({'name':n,'raw':d,'type':typ,'null':'NOT NULL' not in d,'default':dm[1] if dm else 'No declarado','ai':'AUTO_INCREMENT' in d})
        elif v.startswith('PRIMARY KEY'):
            t['pk']=names(v); ix=('PRIMARY','PK',names(v)); t['indexes'].append(ix)
        elif re.match(r'(UNIQUE )?KEY ',v):
            nn=names(v); t['indexes'].append((nn[0],'UNIQUE' if v.startswith('UNIQUE') else 'INDEX',nn[1:]))
        elif 'FOREIGN KEY' in v:
            fm=re.match(r'CONSTRAINT `([^`]+)` FOREIGN KEY \((.*?)\) REFERENCES `([^`]+)` \((.*?)\)(.*)',v)
            assert fm, v
            f={'name':fm[1],'source':m[1],'cols':names(fm[2]),'target':fm[3],'refs':names(fm[4]),'raw':v}
            for action in ['DELETE','UPDATE']:
                am=re.search('ON '+action+r' (RESTRICT|CASCADE|SET NULL|NO ACTION|SET DEFAULT)',fm[5]); f[action]=am[1] if am else 'No explícita; NO ACTION (InnoDB: RESTRICT)'
            t['fks'].append(f); fks.append(f)
        elif ' CHECK ' in v: t['checks'].append(v); checks.append((m[1],v))
        else: raise ValueError('DDL no clasificado: '+v)
    indexes.extend((m[1],*i) for i in t['indexes']); tables.append(t)
by={t['name']:t for t in tables}
triggers=list(re.finditer(r'TRIGGER `([^`]+)` (AFTER|BEFORE) (INSERT|UPDATE|DELETE) ON `([^`]+)` FOR EACH ROW (BEGIN.*?END) \*/;;',s,re.S))
views=list(re.finditer(r'/\*!50001 VIEW `([^`]+)` AS (.*?) \*/;',s,re.S))
proc=re.search(r'CREATE DEFINER=.*? PROCEDURE `sp_soft_delete_user`\(.*?END ;;',s,re.S)
assert proc
absent=sorted({n for m in triggers for n in re.findall(r'INSERT INTO\s+`?(\w+)',m[5]) if n not in by})
logical=[('tbd_carts_items','cart_ID','tb_carts','ID','Nombre y PK compuesta; INT con signo frente a INT UNSIGNED'),('tbd_carts_items','provider_ID','tb_users','ID','Rol proveedor inferido; INT con signo frente a UNSIGNED'),('tbd_carts_items','product_ID','tb_products','ID','Nombre; INT con signo frente a UNSIGNED'),('tbd_users_wishlist_products','user_ID','tb_users','ID','Nombre y pareja de PK'),('tbd_users_wishlist_products','product_ID','tb_products','ID','Nombre y pareja de PK')]
total=sum(len(t['cols']) for t in tables)
add('# Diccionario de Datos — `respaldo_2010.sql`\n\n**Base:** `db_test` · **Fecha de documentación:** 20 de octubre de 2026 · **Motor de origen:** MySQL 8.0.36\n\n**Fuente exacta:** `Practica03/backups/Respaldo_2010.sql` (la capitalización real comienza con R).\n\n**SHA-256:** '+code(digest)+'\n')
add('## 1. Introducción\n\nEste documento reconstruye la estructura y las dependencias del respaldo. Las definiciones SQL constituyen evidencia confirmada; el propósito comercial y la clasificación de tablas son interpretaciones explícitas, salvo cuando una rutina o restricción los demuestra. No se reproducen filas de datos ni credenciales.\n')
add('## 2. Objetivo y alcance\n\nCubrir todas las tablas, columnas, claves, índices, restricciones y objetos programables definidos, incluyendo referencias a objetos ausentes. La cobertura estructural no equivale a resolver toda la semántica comercial ni a verificar el funcionamiento de una restauración.\n')
add('## 3. Metodología\n\nSe leyó el archivo completo como UTF-8, se calculó su huella y se inspeccionaron definiciones, comentarios ejecutables versionados, delimitadores, objetos y sentencias posteriores. Los INSERT de datos se leyeron como parte del archivo, sin publicarlos ni utilizarlos para asignar significados no demostrados. Un extractor estático separó tipos, defaults, índices y FK; se validó cada línea del cuerpo CREATE TABLE. No se estableció conexión a un servidor ni se ejecutó SQL. Las líneas citadas corresponden al archivo original, contando desde 1.\n\nLos ALTER TABLE del respaldo únicamente habilitan o deshabilitan índices durante la carga; no añaden restricciones. Las vistas provisionales del dump se sustituyen por sus definiciones finales y se cuentan una sola vez. No se detectaron CREATE INDEX independientes, funciones ni eventos definidos. Los SET, LOCK, DROP y controles de sesión se inventarían como instrucciones de restauración, no como entidades.\n')
add('## 4. Resumen general del esquema\n')
table(['Indicador','Cantidad / característica'],[['Esquemas propios','1: db_test'],['Dependencia externa','mysql.role_edges (sin definición en el dump)'],['Tablas',len(tables)],['Columnas',total],['PK',len(tables)],['FK',len(fks)],['Índices totales (incluyen PK y UNIQUE)',len(indexes)],['Índices UNIQUE adicionales',sum(i[2]=='UNIQUE' for i in indexes)],['Índices ordinarios',sum(i[2]=='INDEX' for i in indexes)],['CHECK',len(checks)],['Triggers',len(triggers)],['Vistas definitivas',len(views)],['Procedimientos',1],['Funciones / eventos','0 / 0'],['Motor / cotejamiento','InnoDB / utf8mb4_0900_ai_ci'],['Columnas NULL / NOT NULL',f"{sum(c['null'] for t in tables for c in t['cols'])} / {sum(not c['null'] for t in tables for c in t['cols'])}"],['Columnas AUTO_INCREMENT',sum(c['ai'] for t in tables for c in t['cols'])]])
add('## 5. Inventario completo de tablas\n')
table(['Tabla','Entidad (interpretación)','Tipo (inferido)','Columnas','Línea'],[[code(t['name']),meta[t['name']][0],meta[t['name']][1],len(t['cols']),t['line']] for t in tables])
add('## 6. Diccionario individual por tabla\n\nCada tabla incorpora su descripción y diccionario de columnas en la sección 7.\n')
add('## 7. Descripción detallada de todas las columnas\n\n**Lectura de UNIQUE:** se indican las claves únicas que incluyen cada columna; pertenecer a una clave compuesta no implica unicidad individual. La PK siempre impone unicidad sobre su conjunto. «No declarado» no significa DEFAULT NULL explícito. Los tipos de texto heredan utf8mb4 / utf8mb4_0900_ai_ci salvo cláusula reproducida en el DDL.\n')
for t in tables:
    n=t['name']; entity,kind,purpose=meta[n]
    add(f"### {n}\n\n**Nombre exacto:** {code(n)}. **Fuente:** línea {t['line']}.\n\n**Descripción general (inferida):** {entity}.\n\n**Propósito de negocio (inferido):** {purpose}\n\n**Propósito técnico:** Mantiene {len(t['cols'])} columnas; identifica sus filas mediante {code(', '.join(t['pk']))}. "+('Conecta las entidades indicadas en las FK siguientes.' if t['fks'] else 'No declara FK salientes; las relaciones entrantes se indican a continuación.')+f"\n\n**Tipo de tabla (inferido):** {kind}.\n\n**Clave primaria confirmada:** {code(', '.join(t['pk']))}.\n")
    related=[f for f in fks if f['source']==n or f['target']==n]
    add('**Relaciones formales:** '+('; '.join(f"{code(f['source'])} ({', '.join(f['cols'])}) → {code(f['target'])} ({', '.join(f['refs'])}), restricción {code(f['name'])}" for f in related) if related else 'ninguna, ni entrante ni saliente.')+'\n')
    add('**Reglas confirmadas:** PK única y obligatoria; nulabilidad, defaults, generación e índices según el diccionario. '+(' '.join(t['checks']) if t['checks'] else 'No declara CHECK.')+'\n\n**Observaciones técnicas:** '+('La PK compuesta impide repetir la combinación completa; no asegura unicidad de sus componentes por separado. ' if len(t['pk'])>1 else 'La clave sustituta no determina por sí misma la unicidad de atributos de negocio. ')+('No se declara integridad referencial para los identificadores lógicos de esta tabla. ' if n in ['tbd_carts_items','tbd_users_wishlist_products'] else '')+'No se demuestra un nivel formal de normalización ni se conocen todas las validaciones de la aplicación.\n')
    rows=[]
    for c in t['cols']:
        cn=c['name']; d=c['raw']; fs=[f for f in t['fks'] if cn in f['cols']]; ux=[i for i in t['indexes'] if i[1] in ['PK','UNIQUE'] and cn in i[2]]
        business=('Clave que distingue cada fila de '+entity.lower()) if cn=='ID' else meaning[cn]
        business+='.'
        if cn=='description': business='Texto descriptivo de '+('la operación auditada' if n=='tb_logs' else entity.lower())+'.'
        if cn=='name': business='Nombre visible de '+('la categoría de productos' if n=='tbc_categories' else 'cada producto comercializable')+'.'
        if n=='tb_users' and cn=='status': business='Estado de la cuenta: sp_soft_delete_user utiliza 0 para inactivo y cambia 1 a 0; esta interpretación está respaldada por el procedimiento.'
        technical=[]
        if cn in t['pk']: technical.append('Componente de la identidad de '+n+'; posición '+str(t['pk'].index(cn)+1)+' en PK')
        if fs: technical.append('Integridad referencial por '+', '.join(f['name'] for f in fs))
        if c['ai']: technical.append('Secuencia numérica generada por MySQL al omitir el identificador')
        if cn in ['creation_date','operation_date']: technical.append('MySQL asigna CURRENT_TIMESTAMP al omitir el valor; no impide insertar una fecha explícita')
        elif cn=='last_update': technical.append(('DEFAULT '+c['default']+'; ' if c['default']!='No declarado' else 'Sin DEFAULT explícito; no asumir inicialización automática al insertar; ')+'ON UPDATE CURRENT_TIMESTAMP actualiza la marca cuando corresponde según cambios de fila; puede suministrarse explícitamente')
        elif cn=='subtotal' and 'GENERATED' in d: technical.append('Columna calculada y materializada: quantity * unit_price; no es un DEFAULT ni una FK')
        elif 'decimal' in c['type']:
            p,sc=map(int,re.search(r'\((\d+),(\d+)\)',c['type']).groups()); technical.append(f'Decimal exacto: {p} dígitos totales, {sc} decimales y {p-sc} enteros; admite signo y no impide negativos salvo CHECK expreso')
        elif cn=='status' or cn=='operation_status': technical.append('BIT(1): un bit, con nulabilidad y default documentados; no se deduce automáticamente un booleano de negocio')
        elif cn=='is_default': technical.append('Entero con DEFAULT 0; no hay unicidad condicional por usuario ni CHECK que lo restrinja a 0/1')
        elif cn not in t['pk'] and not fs: technical.append('Atributo de '+n+'; '+('dominio cerrado definido por ENUM' if c['type'].startswith('enum') else 'no participa en una FK declarada'))
        rest=[('Admite NULL' if c['null'] else 'NOT NULL')]
        rest.extend(i[1]+' '+i[0]+' ('+', '.join(i[2])+')' for i in ux)
        if 'unsigned' in c['type']: rest.append('UNSIGNED: no admite negativos; no exige valor positivo')
        rest.extend(x for x in t['checks'] if code(cn) in x)
        if 'GENERATED' in d: rest.append(d[d.index('GENERATED'):])
        if 'enum(' in c['type']: rest.append('Literales permitidos en tipo; comportamiento de valores inválidos depende del SQL_MODE')
        rows.append([code(cn),code(c['type']),'Sí' if c['null'] else 'No','Sí' if cn in t['pk'] else 'No',', '.join(f['name'] for f in fs) or 'No','; '.join(i[0]+' ('+', '.join(i[2])+')' for i in ux) or 'No',code(c['default']),'Sí' if c['ai'] else 'No',business+' '+('Interpretación funcional inferida.' if not (n=='tb_users' and cn=='status') else ''),'; '.join(technical)+'.','; '.join(rest),'; '.join(f['target']+' ('+', '.join(f['refs'])+') [tupla completa]' for f in fs) or 'Sin FK'])
    table(['Nombre de columna','Tipo de dato','Permite NULL','PK','FK','UNIQUE (incluye PK)','DEFAULT','AUTO_INCREMENT','Descripción de negocio','Descripción técnica','Restricciones','Referencia'],rows)
    add('<details><summary>DDL original de la tabla: evidencia exacta</summary>\n\n```sql\n'+t['ddl']+'\n```\n\n</details>\n')

add('## 8. Matriz de claves primarias y foráneas\n')
table(['Tabla','PK','FK salientes'],[[code(t['name']),', '.join(t['pk']),'; '.join(f['name'] for f in t['fks']) or 'Ninguna'] for t in tables])
add('## 9. Matriz general de relaciones\n\n### 9.1. Relaciones formalmente declaradas\n\nLa cardinalidad se expresa padre → hijos. La FK no obliga a un padre a tener hijos. Una FK con alguna columna NULL puede no exigir padre; la comprobación de una FK compuesta se omite si algún componente es NULL. No hay cascadas declaradas.\n')
relationrows=[]; edges=[]
for f in fks:
    t=by[f['source']]; unique=any(set(ix[2]).issubset(set(f['cols'])) for ix in t['indexes'] if ix[1] in ['PK','UNIQUE'])
    nullable=any(c['null'] for c in t['cols'] if c['name'] in f['cols'])
    card='1 → 0..1' if unique else '1 → 0..N'
    role='Origen requiere '+('0..1' if nullable else '1')+' padre; '+card
    relationrows.append([f['name'],f['source'],', '.join(f['cols']),f['target'],', '.join(f['refs']),role,f['DELETE'],f['UPDATE'],'La tupla origen debe existir en la clave referenciada salvo NULL; '+('; '.join(meaning.get(c,c) for c in f['cols']))+'. Significado funcional inferido.'])
    edges.append(f"    {f['target']} {'|o' if nullable else '||'}--{'o|' if unique else 'o{'} {f['source']} : {f['name']}")
table(['Restricción','Origen','Columnas origen','Destino','Columnas destino','Cardinalidad','ON DELETE','ON UPDATE','Descripción técnica y de negocio'],relationrows)
add('### 9.2. Relaciones lógicas inferidas (sin FK)\n')
table(['Origen','Columna','Destino candidato','Columna candidata','Evidencia y límite'],logical)
add('**No determinadas:** `tb_buyer_orders.order_ID` parece una referencia a un pedido general, y `tbd_order_items.product_offer_ID` a una oferta, pero no hay tabla destino sustentada. No se inventa una relación hacia otra tabla existente.\n\n**N:M formal:** productos ↔ categorías mediante `tbd_products_categories`; usuarios ↔ productos mediante `tbd_products_users_providers`. Sus PK compuestas evitan duplicar parejas. **N:M inferida:** usuarios ↔ productos deseados y carritos/proveedores/productos; sin integridad referencial declarada.\n\n**Tablas sin ninguna FK entrante o saliente:** '+', '.join(code(t['name']) for t in tables if not any(f['source']==t['name'] or f['target']==t['name'] for f in fks))+'.\n')
add('## 10. Diagrama entidad-relación\n\nSolo representa las FK declaradas; incluye entidades aisladas para conservar el inventario.\n\n```mermaid\nerDiagram\n'+'\n'.join('    '+t['name']+' {\n        '+re.sub(r'[^a-zA-Z0-9_]','_',t['cols'][0]['type'])+' '+t['cols'][0]['name']+'\n    }' for t in tables)+'\n'+'\n'.join(edges)+'\n```\n\nEl detalle íntegro de atributos está en la sección 7; el atributo mostrado por entidad es solo una referencia visual.\n')
add('## 11. Reglas de negocio identificadas\n')
table(['Clase','Regla y alcance'],[
['Confirmada','Cada PK es única y NOT NULL; las PK compuestas validan la combinación, no cada atributo individual.'],
['Confirmada','tb_carts.user_ID es UNIQUE y obligatorio: como máximo un carrito por usuario; un usuario puede no tener carrito.'],
['Confirmada','SKU, email, nick, nombre de categoría y código de tipo de pago tienen unicidad individual. El par provider/provider_method_ref es único globalmente.'],
['Confirmada','Las coordenadas son ambas NULL o ambas no NULL; latitud entre -90 y 90 y longitud entre -180 y 180. Un CHECK de rango aislado permite UNKNOWN para NULL; chk_coordinates completa la regla.'],
['Confirmada','La FK compuesta de componentes exige que el padre pertenezca a la misma dirección cuando address_sup_ID no es NULL. No impide ciclos ni autoasignación.'],
['Confirmada','Las enumeraciones cierran el dominio declarado: ver tipos literales por columna. No hay transiciones de fulfillment_status programadas.'],
['Confirmada','Subtotal de partida es quantity * unit_price, GENERATED ALWAYS STORED. Ninguna regla suma partidas para actualizar la cabecera.'],
['Confirmada','Los UNSIGNED impiden negativos pero permiten cero; los DECIMAL monetarios no tienen CHECK de positividad. quantity en carrito es INT con signo.'],
['Confirmada','sp_soft_delete_user comprueba rol asignado, identificador, existencia y estado; cambia status de 1 a 0 y registra Delete en tb_logs.'],
['Confirmada','Los triggers son AFTER y FOR EACH ROW; no capturan SELECT ni prueban que se registre Read. Los cuerpos no incluyen condiciones IF.'],
['Inferida','Clasificación comercial de pedidos por vendedor, instantánea product_name y finalidad de indicadores is_default. Requiere validación con responsables del sistema.'],
['No determinada','Moneda, impuestos, unidades de stock, formato de credenciales, semántica global de status y reglas de autorización de la aplicación.'],
['No determinada','Un único destino o instrumento predeterminado por usuario: el SQL no impone esa regla. No se restringe is_default a 0/1.']])
add('## 12. Índices y restricciones de integridad\n\nSe cuentan índices físicos declarados: PRIMARY, UNIQUE y KEY. No se añade un índice por cada FK cuando reutiliza un índice existente. Los índices ordinarios no imponen unicidad. El cotejamiento ai_ci afecta comparaciones textuales de claves únicas (acentos y mayúsculas).\n')
table(['Tabla','Índice','Clase','Columnas en orden'],[[t,n,k,', '.join(cols)] for t,n,k,cols in indexes])
table(['Tabla','CHECK original'],checks)
add('**Tipos y dominios presentes:** '+', '.join(code(v) for v in sorted({c['type'] for t in tables for c in t['cols']}))+'. No se detecta SET.\n')
add('## 13. Triggers, procedimientos, funciones, vistas y eventos\n\n### 13.1. Triggers\n\nTodos se definen con `root`@`localhost`. El usuario registrado mediante USER() es la cuenta de conexión, no necesariamente el usuario de negocio. INSERT utiliza NEW; DELETE utiliza OLD; UPDATE puede comparar ambas versiones dentro del texto o columnas de auditoría. Los cuerpos exactos de cada objeto permiten comprobar qué atributos se conservan y cuáles se omiten. No se presupone auditoría integral de todos los campos.\n')
for m in triggers:
    dest=re.findall(r'INSERT INTO\s+`?(\w+)',m[5]); refs=sorted(set(re.findall(r'\b(?:OLD|NEW)\.(`?\w+`?)',m[5])))
    add(f"#### {m[1]}\n\n**Fuente:** línea {line(m.start())}. **Momento / evento:** {m[2]} {m[3]}, por fila en {code(m[4])}. **Propósito confirmado:** insertar auditoría en {', '.join(map(code,dest))}. **Dependencias:** tabla origen y destinos; "+('hay destinos no definidos en el respaldo.' if any(d not in by for d in dest) else 'los destinos están definidos.')+'\n\n**Atributos OLD/NEW utilizados:** '+', '.join(map(code,refs))+'.\n\n**Comportamiento:** '+('Registra la modificación de la fila; no hay IF que limite el registro a cambios de columnas concretas.' if m[3]=='UPDATE' else 'Registra la '+('inserción con valores NEW.' if m[3]=='INSERT' else 'eliminación con valores OLD.'))+' El fallo de una escritura de auditoría puede impedir la operación sobre la tabla InnoDB; no hay manejador local de errores.\n\n<details><summary>Cuerpo SQL íntegro del trigger</summary>\n\n```sql\nTRIGGER `'+m[1]+'` '+m[2]+' '+m[3]+' ON `'+m[4]+'` FOR EACH ROW '+m[5]+'\n```\n\n</details>\n')
add('### 13.2. Procedimiento sp_soft_delete_user\n\n**Entrada:** p_user_id INT UNSIGNED. **Fuente:** línea '+str(line(proc.start()))+'. **Clasificación:** MODIFIES SQL DATA; DEFINER root@localhost, seguridad DEFINER implícita al no declarar SQL SECURITY. **Dependencias:** mysql.role_edges, tb_users, tb_logs y el trigger AFTER UPDATE de usuarios.\n\nObtiene el nombre de conexión con SUBSTRING_INDEX(USER(), \'@\', 1); cuenta aristas de roles superadmin/admin/support restringidas a TO_HOST y FROM_HOST `%`. Comprueba asignación de roles, no roles efectivamente activados ni herencia recursiva. Rechaza NULL/0, usuario ausente, estado 0 o NULL mediante SIGNAL SQLSTATE 45000. Actualiza status de 1 a 0; exige ROW_COUNT() = 1, inserta una operación Delete en tb_logs y devuelve mensaje, user_id, ejecutor, estado y fecha. No elimina físicamente la cuenta ni sus dependencias.\n\nNo contiene START TRANSACTION, COMMIT, ROLLBACK ni manejador de excepciones: la atomicidad entre sentencias depende del contexto transaccional de la llamada. El UPDATE también dispara trg_users_after_update, por lo que puede generar otra entrada además del Delete explícito.\n\n<details><summary>Procedimiento completo</summary>\n\n```sql\n'+proc[0]+'\n```\n\n</details>\n')
add('### 13.3. Vistas definitivas\n\nSe documentan las definiciones finales, no las proyecciones provisionales del dump. Todas usan ALGORITHM=UNDEFINED y SQL SECURITY DEFINER con root@localhost. Las columnas proyectadas son expresiones de vista y no se suman a las columnas de tablas base. Se conserva su definición completa para documentar tipos derivados, filtros, joins y alias sin inventar tipos físicos.\n')
for m in views:
    body=m[2]; deps=sorted(set(re.findall(r'`(tb\w+|tbc_\w+|tbd_\w+)`',body))); ext='mysql.role_edges' if '`role_edges`' in body else 'ninguna'
    if m[1]=='vw_total_products_by_category': desc='CTE recursiva desde categorías raíz: construye ruta y nivel, cuenta asociaciones directas por categoría y agrega una fila Sin categoría para productos sin asociación. Los totales por categoría no acumulan descendientes; activos/inactivos usan status de la asociación, mientras la fila sin categoría usa status de producto. SUM puede producir NULL en conjuntos vacíos; no hay COALESCE. Ciclos y categorías sin camino a raíz no tienen protección explícita; la profundidad depende de la configuración de MySQL.'
    elif m[1]=='vw_trazabilidad_productos': desc='Relaciona productos actuales con entradas Create de tb_logs mediante coincidencia textual ID=..., y concatena roles asignados. No conserva productos eliminados ni reconstruye su descripción histórica; los roles corresponden al catálogo actual.'
    elif m[1]=='vw_trazabilidad_productos_proveedores': desc='Filtra tb_logs por la tabla de vínculos proveedor/producto, renombra columnas de auditoría y ordena por fecha descendente; no agrega roles ni analiza identificadores.'
    elif m[1]=='vw_trazabilidad_usuarios': desc='Proyecta las siete columnas de tb_logs filtrando table_name=tb_users y operation_status=0x01; no determina por sí sola la semántica global de dicho bit.'
    else: desc='Filtra tb_logs por la entidad indicada en el WHERE. Extrae un identificador desde description usando el texto ID=, obtiene cuenta y nombre de conexión, y consulta roles actuales asignados con COALESCE para ausencia de roles. El identificador extraído depende del formato textual y no constituye una FK; en entidades de PK compuesta no reconstruye necesariamente la clave completa. La consulta de roles solo compara TO_USER, sin distinguir host.'
    add(f"#### {m[1]}\n\n**Fuente:** línea {line(m.start())}. **Propósito y comportamiento:** {desc}\n\n**Tablas consultadas:** {', '.join(map(code,deps))}. **Dependencia externa:** {ext}. No modifica tablas.\n\n<details><summary>Definición final completa</summary>\n\n```sql\nCREATE VIEW `"+m[1]+'` AS '+body+';\n```\n\n</details>\n')
add('### 13.4. Funciones y eventos\n\nNo hay funciones almacenadas ni eventos programados definidos. Las llamadas a funciones nativas, USER(), CONCAT(), COALESCE(), etc., no son objetos almacenados adicionales.\n')
issues=[
('Dependencias de auditoría ausentes','Siete tablas destino no definidas: '+', '.join(absent)+'. Hay 21 triggers que dependen de ellas. No pueden reconstruirse sus columnas, claves o tipos solo desde INSERT de triggers. Se requiere el DDL de esas tablas; no se incluyen como tablas existentes.'),
('Correspondencia de auditoría','Las vistas de carritos, pedidos y otras entidades consultan tb_logs, pero sus triggers escriben w_trazabilidad_*. No se observa un puente entre esos destinos y tb_logs.'),
('Referencias sin destino determinado','order_ID y product_offer_ID carecen de FK y de entidad destino comprobable; un índice sobre product_offer_ID no resuelve esta ausencia.'),
('Integridad lógica incompleta','Las cinco relaciones candidatas de carritos y deseos carecen de FK. En artículos de carrito los INT con signo tampoco coinciden con los identificadores UNSIGNED candidatos.'),
('Convenciones funcionales pendientes','No se determinan moneda, impuestos, unidades, reglas de transición ni la semántica de todos los bits; status de usuarios sí tiene evidencia en sp_soft_delete_user y la vista de categorías usa etiquetas activo/inactivo localmente.'),
('Instrumentos y direcciones predeterminados','is_default no está limitado a 0/1 ni hay restricción que asegure un solo registro predeterminado por usuario. last_four no exige caracteres numéricos.'),
('Jerarquías sin validación de ciclos','Las FK de categorías/componentes no impiden ciclos. La CTE parte de raíces y no incluye necesariamente toda categoría si existen ciclos o componentes inaccesibles.'),
('Marcas temporales obligatorias sin DEFAULT','tb_products, tbc_categories, tbd_products_categories y tbd_users_wishlist_products tienen last_update NOT NULL ON UPDATE sin DEFAULT explícito; no asumir que CURRENT_TIMESTAMP se asigne al insertar. El resultado depende de los datos suministrados y SQL_MODE.'),
('Auditoría textual y seguridad','Las vistas interpretan identificadores desde texto y roles actuales. Los DEFINER y mysql.role_edges requieren contexto de privilegios externo. La política completa, hash de password y protección de referencias de pago no están documentados por el esquema.'),
('Atomicidad de eliminación lógica','El procedimiento tiene varias sentencias sin transacción propia; el contexto de llamada determina atomicidad. El trigger y el INSERT explícito pueden registrar dos operaciones por desactivación.')]
add('## 14. Observaciones y posibles inconsistencias\n')
table(['Pendiente / hallazgo','Evidencia y efecto'],issues)
add('## 15. Conclusiones técnicas\n\nEl esquema representa un sistema de productos, usuarios, clasificación, carritos, pedidos, direcciones y pagos, con trazabilidad heterogénea. Las FK declaradas aseguran solo las dependencias listadas; no completan el circuito pedido general/oferta ni los vínculos de carritos y deseos. La documentación estructural queda completa para los objetos definidos; la reconstrucción operativa y la validación funcional requieren resolver las dependencias y ambigüedades de la sección anterior. No se afirma que el respaldo sea restaurable sin objetos externos.\n')
add('## 16. Anexo de cobertura y validación\n\nLa unidad de relaciones confirmadas es cada restricción FK, aunque tenga varias columnas. Las relaciones lógicas candidatas se cuentan por separado y las referencias sin destino no se suman. Objetos adicionales = triggers + vistas definitivas + procedimientos; no incluye tablas externas ausentes. Elementos pendientes = grupos de hallazgos de la sección 14; no significa tablas o columnas omitidas.\n')
stats={'Tablas identificadas':len(tables),'Tablas documentadas':len(tables),'Columnas identificadas':total,'Columnas documentadas':total,'Claves primarias':len(tables),'Claves foráneas':len(fks),'Relaciones identificadas':len(fks)+len(logical),'Relaciones explícitas':len(fks),'Relaciones lógicas inferidas':len(logical),'Índices identificados':len(indexes),'Objetos adicionales':len(triggers)+len(views)+1,'Elementos pendientes':len(issues)}
table(['Indicador','Cantidad'],list(stats.items()))
add(f'**Cobertura de tablas:** ({len(tables)} / {len(tables)}) × 100 = **100 %**.\n\n**Cobertura de columnas:** ({total} / {total}) × 100 = **100 %**.\n\nEl 100 % corresponde a elementos estructurales definidos, no a certeza semántica ni a disponibilidad de dependencias externas.\n')
add('### Trazabilidad y controles\n\nCada tabla y objeto cita línea de origen e incluye su DDL o cuerpo exacto. Cada columna tiene descripción comercial y técnica, nulabilidad, tipo completo, PK/FK/UNIQUE, DEFAULT y autoincremento. No se usan filas personales como ejemplos. El extractor falla ante líneas CREATE TABLE no reconocidas. Las siguientes comprobaciones se ejecutan al generar el documento: igualdad del inventario fuente/documento; conteo de columnas; presencia de restricciones; unicidad de nombres; resolución de las referencias FK; y verificación de SHA-256 antes y después.\n')
md='\n'.join(out)
assert len(tables)==len(re.findall(r'^CREATE TABLE ',s,re.M))
assert total==sum(len(re.findall(r'^  `',t['ddl'],re.M)) for t in tables)
assert len(by)==len(tables)
assert len(fks)==len(re.findall(r'CONSTRAINT `[^`]+` FOREIGN KEY',s))
assert len(triggers)==len(re.findall(r'TRIGGER `[^`]+`',s))
for t in tables:
    assert '### '+t['name'] in md
    assert all(c['name'] in meaning or c['name']=='ID' for c in t['cols'])
for f in fks:
    assert f['target'] in by
    assert set(f['refs']).issubset({c['name'] for c in by[f['target']]['cols']})
    assert set(f['cols']).issubset({c['name'] for c in by[f['source']]['cols']})
assert hashlib.sha256(SRC.read_bytes()).hexdigest()==digest
DOC=ROOT/'docs/DICCIONARIO_DATOS_respaldo_2010.md'
DOC.write_text(md,encoding='utf-8')

# Conversión HTML autónoma sin bibliotecas externas ni conexiones de red.
def inline(x):
    x=html.escape(x)
    x=re.sub(r'`([^`]+)`',r'<code>\1</code>',x)
    x=re.sub(r'\*\*([^*]+)\*\*',r'<strong>\1</strong>',x)
    return x.replace('&lt;br&gt;','<br>')
parts=[]; toc=[]; incode=False; codebuf=[]; intable=False
for ln in md.splitlines():
    if ln.startswith('```'):
        if incode:
            parts.append('<pre><code>'+html.escape('\n'.join(codebuf))+'</code></pre>'); codebuf=[]
        incode=not incode
        continue
    if incode: codebuf.append(ln); continue
    if ln.startswith('|'):
        cells=ln.strip('|').split('|')
        if all(re.fullmatch(r'\s*[-:]+\s*',x) for x in cells): continue
        if not intable: parts.append('<div class="scroll"><table>'); intable=True; tag='th'
        else: tag='td'
        parts.append('<tr>'+''.join('<'+tag+'>'+inline(x.strip())+'</'+tag+'>' for x in cells)+'</tr>'); continue
    if intable: parts.append('</table></div>'); intable=False
    h=re.match(r'^(#{1,6}) (.*)',ln)
    if h:
        anchor='sec-'+str(len(toc)); toc.append((len(h[1]),h[2],anchor)); parts.append(f'<h{len(h[1])} id="{anchor}">'+inline(h[2])+f'</h{len(h[1])}>')
    elif ln.startswith('<details>') or ln=='</details>': parts.append(ln)
    elif ln.strip(): parts.append('<p>'+inline(ln)+'</p>')
if intable: parts.append('</table></div>')
nav=''.join(f'<a class="level{lev}" href="#{a}">'+html.escape(title)+'</a>' for lev,title,a in toc)
page='<!doctype html><html lang="es"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Diccionario de Datos — respaldo_2010.sql</title><style>body{margin:0;font:15px/1.6 system-ui;color:#192a3c;background:#fafbfc}nav{position:fixed;inset:0 auto 0 0;width:275px;overflow:auto;background:#12243a;padding:20px;box-sizing:border-box}nav a{display:block;color:#d6e6ff;text-decoration:none;padding:5px}nav .level3,nav .level4{padding-left:16px;font-size:13px}main{margin-left:295px;padding:30px;max-width:1600px}h1,h2,h3,h4{scroll-margin-top:20px}h2{border-bottom:2px solid #bad0e0;padding-top:20px}.scroll{overflow:auto}table{border-collapse:collapse;font-size:13px;width:100%;margin:15px 0}td,th{border:1px solid #cbd5e1;padding:9px;min-width:90px;text-align:left;vertical-align:top}th{background:#e3edf6}pre{white-space:pre-wrap;overflow-wrap:anywhere;background:#eaf0f5;padding:15px}code{font-family:Consolas,monospace}summary{cursor:pointer;color:#124b83}@media(max-width:900px){nav{position:static;width:auto;max-height:300px}main{margin:0;padding:16px}}</style><nav><strong style="color:white">Índice navegable</strong>'+nav+'</nav><main>'+''.join(parts)+'</main></html>'
DOC.with_suffix('.html').write_text(page,encoding='utf-8')
(ROOT/'docs/VALIDACION_respaldo_2010.json').write_text(json.dumps({'source':str(SRC),'sha256':digest,'stats':stats,'checks':'passed','tables':[{'name':t['name'],'line':t['line'],'columns':[c['name'] for c in t['cols']]} for t in tables],'absent_audit_tables':absent},ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(stats,ensure_ascii=False,indent=2))
print('SHA-256 sin cambios:',digest)
print('Documentos:',DOC,DOC.with_suffix('.html'))
