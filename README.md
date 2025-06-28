# 🥑 WellBiteAPI

API RESTful construida con [Vapor](https://vapor.codes), diseñada para la aplicación WellBite

---

## 🚀 Configurar el proyecto localmente

### 1. Crear el script para la creación de la base de datos con PostgreSQL

```bash
#!/bin/bash

PASSWORD=$(openssl rand -hex 16)

echo "PostgreSQL password: $PASSWORD"

docker run -d \
  --name wellbiteDB \
  -e POSTGRES_DB=wellbiteDB \
  -e POSTGRES_USER=wellbiteUser \
  -e POSTGRES_PASSWORD="$PASSWORD" \
  -p 5432:5432 \
  -v wellbite_data:/var/lib/postgresql/data \
  postgres:latest

# Guarda la contraseña con comillas para preservar exactamente la cadena
echo "$PASSWORD" > ./pg_password.txt
echo "PostgreSQL password saved to ./pg_password.txt"

# Opcional: Establece permisos restrictivos en el archivo de contraseña
chmod 600 ./pg_password.txt

```

Adicionalmente, debemos modificar el .gitignore para agregar el documento de `pg_password.txt`


### 2. Crear la base de datos PostgreSQL con Docker

Primero, asegúrate de que [Docker Desktop](https://www.docker.com/products/docker-desktop) esté corriendo. Luego:

```bash
./db_create.sh          # Ejecuta el script para crear la base de datos
                        # y genera la contraseña en el fichero db
```

### 3. Crear archivo de entorno .env

Este proyecto usa un archivo `.env` para definir variables de entorno sensibles, como la conexión a la base de datos o [Redis](https://redis.io/).

Primero, duplica el archivo de ejemplo:

```bash
cp .env.example .env
```

Luego, abre `.env` y personaliza las variables según tu entorno local.

### 3. Correr las migraciones de Vapor

Esto inicializa las tablas y estructuras necesarias en tu base de datos:

```bash
swift run WellBiteAPI migrate
```

### 4. Añadir Redis al entorno con Docker

Para levantar un servidor **Redis** local:

```bash
docker run -d \
  --name redis-server \
  -v redis-data:/data \
  -p 6379:6379 \
  redis:latest \
  --save 60 1 --loglevel warning
```

### 5. Configurar el esquema de Xcode

Para que Vapor funcione correctamente dentro de **Xcode**, asegúrate de que el esquema _Run_ esté configurado con el _Working Directory_ apuntando a la raíz del proyecto (donde está el archivo `Package.swift`).

- En **Xcode**: `Product > Scheme > Edit Scheme...`, y luego `Run > Options > Working Directory`.

<!--## 🛠️ Otras acciones-->
<!---->
<!--### Activar manualmente un nuevo usuario-->
<!---->
<!--Cuando un usuario se registra desde la app de iOS, se le envía un email con un enlace de validación. En nuestro caso usando el Simulador de iOS, arrastrar el enlace desde Mail no siempre funciona como se espera.-->
<!---->
<!--Esto lo pudimos solucionar usando un cliente de Mac como [DBeaver](https://dbeaver.io/) o [Postico 2](https://eggerapps.at/postico2/) para conectar a la base de datos **PostgreSQL** que hemos levantado con **Docker**, y modificando la propiedad `role` del usuario a `user`.-->
<!---->
<!--### Ver todas las rutas registradas-->
<!---->
<!--Una forma rápida de inspeccionar tu API y conocer sus rutas disponibles:-->
<!---->
<!--```bash-->
<!--swift run WellBiteAPI routes-->
<!--```-->
<!--## Getting Started-->
<!---->
<!--To build the project using the Swift Package Manager, run the following command in the terminal from the root of the project:-->
<!--```bash-->
<!--swift build-->
<!--```-->
<!---->
<!--To run the project and start the server, use the following command:-->
<!--```bash-->
<!--swift run-->
<!--```-->
<!---->
<!--To execute tests, use the following command:-->
<!--```bash-->
<!--swift test-->
<!--```-->
<!---->
<!--### See more-->
<!---->
<!--- [Vapor Website](https://vapor.codes)-->
<!--- [Vapor Documentation](https://docs.vapor.codes)-->
<!--- [Vapor GitHub](https://github.com/vapor)-->
<!--- [Vapor Community](https://github.com/vapor-community)-->
