# Prácticas de la asignatura Optativa I: Bases de Datos en la Nube

## Ing. en Tecnologías de la Información e Innovación Digital

### Docente: M.T.I. Marco A. Ramírez Hernández

**Periodo:** Septiembre - Diciembre 2026

---

| ID | Número de Práctica | Nombre de la Práctica    | Potenciador | Estatus          |
| -- | ------------------ | ------------------------ | ----------- | ---------------- |
| 1. | Práctica 02        | Conexión Remota en MYSQL | 42          | En desarrollo 🟡 |

# Práctica 02 - Base de Datos `db_test`

## 📋 Descripción General

Esta práctica consiste en el diseño, implementación, conexión remota y respaldo de la base de datos relacional **`db_test`**, utilizando **MySQL versión 8.0.36**.

La base de datos está orientada a la gestión de usuarios y cuenta con un sistema de auditoría que permite registrar las operaciones realizadas sobre la tabla de usuarios mediante **triggers**.

Como parte de la práctica, se realizó el respaldo de la base de datos en formato **`.sql`**, conservando la estructura de las tablas, los registros almacenados y los triggers implementados.

---

## 🗄️ Estructura de la Base de Datos

La base de datos `db_test` contiene las siguientes tablas:

### 1. `tb_users`

Almacena la información de los usuarios registrados en el sistema.

| Campo           | Descripción                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| `ID`            | Identificador único de cada usuario. Es clave primaria y autoincrementable. |
| `email`         | Correo electrónico del usuario. Es obligatorio y único.                     |
| `nickname`      | Nombre de usuario o apodo. Es obligatorio y único.                          |
| `password`      | Contraseña almacenada mediante un valor cifrado/hash.                       |
| `creation_date` | Fecha y hora en que se creó el registro.                                    |
| `last_update`   | Fecha y hora de la última modificación del registro.                        |
| `last_login`    | Fecha y hora del último acceso del usuario.                                 |

### 2. `tb_logs`

Almacena el historial de auditoría de las operaciones realizadas sobre la tabla `tb_users`.

| Campo              | Descripción                                                         |
| ------------------ | ------------------------------------------------------------------- |
| `ID`               | Identificador único del registro de auditoría.                      |
| `table_name`       | Nombre de la tabla donde se realizó la operación.                   |
| `operation`        | Tipo de operación realizada: `Create`, `Read`, `Update` o `Delete`. |
| `db_users`         | Usuario de la base de datos desde el que se realizó la operación.   |
| `description`      | Descripción detallada de la acción realizada.                       |
| `operation_date`   | Fecha y hora en que ocurrió la operación.                           |
| `operation_status` | Estado de la operación mediante un valor lógico.                    |

---

## 🌐 Conexión Colaborativa y Pruebas Remotas

Durante el desarrollo de la práctica se realizaron pruebas de conexión hacia bases de datos de compañeros de equipo con el propósito de simular un entorno colaborativo y distribuido.

Las actividades realizadas incluyeron:

* Configuración de la conexión remota mediante IP y host.
* Acceso al servidor MySQL de otro equipo dentro de la red.
* Realización de operaciones sobre la tabla `tb_users`.
* Inserción, actualización y eliminación de registros mediante operaciones SQL.
* Verificación de las operaciones realizadas mediante los registros almacenados en `tb_logs`.

El sistema de auditoría permitió identificar el usuario y el equipo desde el cual se realizaron determinadas operaciones.

---

## ⚙️ Automatización mediante Triggers

Para llevar un control de las modificaciones realizadas sobre los usuarios, se implementaron tres triggers en la tabla `tb_users`.

### `trg_users_after_insert`

Se ejecuta después de insertar un nuevo usuario y registra automáticamente la operación en la tabla `tb_logs`.

La información registrada incluye:

* ID del usuario.
* Correo electrónico.
* Nickname.
* Usuario de la base de datos.
* Fecha y hora de la operación.

### `trg_users_after_update`

Se ejecuta después de actualizar un usuario y permite registrar los cambios realizados en determinados campos.

Entre los cambios que pueden registrarse se encuentran:

* Correo electrónico anterior y nuevo.
* Nickname anterior y nuevo.
* Usuario que realizó la operación.
* Fecha y hora de la modificación.

### `trg_users_after_delete`

Se ejecuta después de eliminar un usuario y registra en `tb_logs` información relacionada con el registro eliminado.

Se almacena:

* ID del usuario eliminado.
* Correo electrónico.
* Nickname.
* Usuario que realizó la operación.
* Fecha y hora de la eliminación.

---

## 💾 Respaldo de la Base de Datos

Como parte de la práctica se realizó un respaldo completo de la base de datos `db_test` mediante un **MySQL dump**.

El respaldo se encuentra en el archivo:

```text
db_test.sql
```

El archivo contiene:

* Estructura de la tabla `tb_users`.
* Registros de `tb_users`.
* Estructura de la tabla `tb_logs`.
* Registros de `tb_logs`.
* Trigger `trg_users_after_insert`.
* Trigger `trg_users_after_update`.
* Trigger `trg_users_after_delete`.
* Configuraciones necesarias para restaurar la estructura y los datos.

**Versión de MySQL utilizada:** `8.0.36`

**Fecha del respaldo:** `09/09/2026`

---

## 📁 Archivos de la Práctica

La estructura de los archivos correspondientes a esta práctica es:

```text
Practicas_BDN_240537/
│
├── README.md
└── db_test.sql
```

### `README.md`

Documento que describe las actividades realizadas, la estructura de la base de datos, las pruebas de conexión remota, los triggers y el respaldo.

### `db_test.sql`

Archivo que contiene el respaldo de la base de datos `db_test`.

---

## 🌿 Rama de Git

Para organizar los archivos correspondientes a esta práctica se creó la siguiente rama:

```text
practica02
```

Los cambios de esta práctica se almacenan dentro de dicha rama para posteriormente ser enviados al repositorio remoto.

---

## ✅ Resultado

Se realizó correctamente el respaldo de la base de datos `db_test` en formato `.sql`. El respaldo conserva las tablas, registros y triggers implementados durante la práctica.

Además, la documentación de las actividades se incorporó al repositorio y los archivos correspondientes se almacenaron en la rama **`practica02`**.
