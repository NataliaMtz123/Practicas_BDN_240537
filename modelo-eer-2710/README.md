# Atlas · Explorador EER 2710

Aplicación independiente para explorar `db_test` a partir de `Practica03/backups/Respaldo_2710.sql`. No modifica el SQL, no conecta a MySQL y no ejecuta instrucciones SQL. Solo distribuye metadatos y conteos agregados. El diccionario y su publicación permanecen intactos.

## Ejecutar

Requisitos: Node.js 20.19+ o 22.12+ (validado con 24), npm y Python 3.11+. Desde la raíz del repositorio:

```powershell
cd modelo-eer-2710
npm ci
npm run dev
```

Abrir `http://127.0.0.1:5173/Practicas_BDN_240537/modelo-eer-2710/`.

## Producción

```powershell
npm run build
npm run preview
```

Vista previa: `http://127.0.0.1:4173/Practicas_BDN_240537/modelo-eer-2710/`. `dist/` contiene la versión de producción ya generada. Debe servirse por HTTP; no abrir `index.html` mediante `file://`.

La compilación vuelve a analizar el respaldo, valida estructura, clasificación, conteos y privacidad, comprueba la huella original, ejecuta pruebas del lexer, comprueba TypeScript y genera los recursos estáticos. Para reconstruir solo metadatos: `npm run analyze`.

## GitHub Pages sin perder el diccionario

La ruta base ya es `/Practicas_BDN_240537/modelo-eer-2710/`, conforme a la [configuración de despliegue de Vite](https://vite.dev/guide/static-deploy). No se añadieron workflows, commits, pushes ni cambios a Settings → Pages.

1. Compilar y revisar la vista previa.
2. En una copia de la rama **Practica03**, localizar la carpeta **docs** que actualmente publica GitHub Pages. En la estructura actual del workspace corresponde a `Practica03/docs`; comprobar la ruta efectiva dentro de esa rama.
3. Crear exclusivamente `docs/modelo-eer-2710/` en esa fuente de publicación y copiar **el contenido de `modelo-eer-2710/dist/`** dentro. No copiar el SQL, `node_modules`, scripts ni el proyecto completo. Conservar todos los archivos del diccionario y su `index.html`.
4. Revisar el diff: solamente debe agregarse la subcarpeta del EER. Confirmar y publicar esos archivos usando el flujo habitual del repositorio. No cambiar la rama ni carpeta configuradas para Pages.
5. Abrir `https://<usuario>.github.io/Practicas_BDN_240537/modelo-eer-2710/`. El enlace al diccionario seguirá funcionando en su ruta actual. Opcionalmente agregar un enlace a la nueva ruta desde el diccionario, en un cambio separado.

Esta entrega prepara la publicación, pero no modifica el sitio remoto. Si otra configuración usa una raíz distinta, ajustar únicamente `base` en `vite.config.ts` y recompilar antes de copiar.

## Interacciones

- Arrastrar tarjetas y fondo, zoom, ajuste al contenido y minimapa navegable.
- Expandir/contraer atributos por tarjeta o para todo el modelo; reorganización Dagre y restablecimiento.
- Búsqueda por tabla, columna, tipo, PK/FK o nombre de índice; acceso con Ctrl+K.
- Filtros por FK, ausencia de relaciones y categorías conceptuales inferidas.
- Inspector de atributos, tipos, longitud/precisión/escala, dominios, valores ENUM/SET, defaults, nulabilidad, índices, CHECK, PK/FK y notación formal.
- Selección de relación por línea o etiqueta, cardinalidad, participación, acciones referenciales y navegación entre extremos.
- Dependencias entrantes/salientes, rutas estructurales bidireccionales y enfoque de vecinos.
- Cinco relaciones hipotéticas desactivadas por defecto, con líneas discontinuas y advertencia de ausencia de FK.
- Resumen estadístico, inventario completo de objetos, tablas con más registros y conexiones, advertencias e identificación SHA-256.
- Descarga PNG y SVG del diagrama visible completo, independientemente del zoom, y JSON de todos los metadatos. La imagen respeta filtros, selección y expansión actuales; para mostrar todo, restablecer la vista antes de exportar.
- Tema claro/oscuro, preferencias locales de tema, expansión, posiciones y viewport. Si el almacenamiento está bloqueado se usa una vista temporal.
- Diseño móvil con menú lateral e inspector superpuesto, etiquetas accesibles, foco visible y reducción de movimiento del sistema.

## Arquitectura

| Archivo | Responsabilidad |
| --- | --- |
| `scripts/analyze.py` | Lexer MySQL, delimitadores, extracción y contraste del DDL, conteo independiente y JSON seguro |
| `scripts/validate.py` | Cobertura de tablas/columnas, PK/FK, unicidad, cardinalidades, objetos, privacidad y SHA-256 |
| `scripts/test_parser.py` | Cadenas escapadas, comentarios ejecutables, tuplas anidadas y rutinas delimitadas |
| `src/data/model.json` | Metadatos públicos; sin filas ni cuerpos de rutinas |
| `src/model.ts` | Tipos, consultas del grafo, búsqueda de rutas y persistencia |
| `src/components/TableNode.tsx` | Tarjetas React Flow |
| `src/components/RelationEdge.tsx` | Relaciones, autorrelaciones y marcadores Crow’s Foot |
| `src/components/Details.tsx` | Inspector de tabla, columna y relación |
| `src/App.tsx` | Composición, filtros, estadísticas, navegación y distribución |
| `src/export.ts` | Descarga JSON y exportaciones gráficas |
| `src/style.css` | Tailwind, temas, diseño responsivo y reducción de movimiento |
| `tests/explorer.spec.ts` | Pruebas reales de navegador y exportaciones |
| `dist/` | Aplicación compilada para publicar |

React + TypeScript + Vite; React Flow para el lienzo; Motion para transiciones; Dagre para distribución; Lucide para iconos; Tailwind CSS y CSS temático. Sin servicios externos en ejecución ni credenciales frontend. Los [handles de React Flow](https://reactflow.dev/learn/customization/handles) conectan los nodos personalizados.

## Pruebas de navegador

```powershell
npm run build
npm run test:e2e
```

Por defecto usa Microsoft Edge instalado, en modo headless. En otras plataformas instalar Chromium con `npx playwright install chromium` y definir `PLAYWRIGHT_CHANNEL=chromium` antes de ejecutar las pruebas. Se generan capturas de escritorio y móvil y exportaciones PNG/SVG en `test-results/` (ignorados por Git).

## Evidencia y límites

El analizador está diseñado para **este respaldo**; no es un restaurador SQL genérico. Procesa literales escapados, comentarios versionados y delimitadores de rutinas. Los ALTER existentes solo activan/desactivan índices. Las vistas provisionales se sustituyen por las finales. Las instrucciones dentro de triggers/procedimientos se inventarían como objetos, nunca como cambios de datos ejecutados.

Los conteos parten de CREATE TABLE y suman tuplas VALUES fuera de rutinas; se contrastan con el inventario preexistente. No hay UPDATE, DELETE, TRUNCATE, REPLACE ni otras mutaciones de datos externas a rutinas en este respaldo. Ante esas operaciones o DDL no soportado, el analizador **interrumpe la generación**; no produce conteos estimados como exactos. Los casos REPLACE, INSERT SELECT y mutaciones arbitrarias requieren ampliar el reconstructor antes de aceptar otro respaldo.

El diccionario preexistente aporta descripciones funcionales y clasificaciones; primero se compara cada DDL token a token con el SQL original. No se reutilizan sus filas ni cuerpos de rutinas en los archivos públicos. El hash verifica que el respaldo no cambió.

Cardinalidad hija → padre según NULL/NOT NULL; padre → hijos según una clave UNIQUE/PK completa contenida en la FK. Una FK no obliga al padre a tener hijos. La participación conceptual mínima del padre se muestra como cero. Para FK compuestas nullable rige la semántica de MySQL: cualquier componente NULL puede omitir la referencia.

No se certifican integridad de filas, ejecución exitosa de una restauración, normalización ni lógica de negocio. Categorías, naturaleza funcional y descripciones inferidas se etiquetan expresamente. No se inventan jerarquías de especialización, entidades débiles ni atributos multivalorados. Hay dos autorrelaciones declaradas. Los destinos de auditoría ausentes se reportan como advertencias, sin tarjetas ficticias.

Ver [REPORTE_VALIDACION.md](REPORTE_VALIDACION.md) para cifras, conteos por tabla y alcance de la validación.
