#!/bin/bash

# Opción 1: Genera una contraseña alfanumérica eliminando caracteres especiales
# PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)

# Opción 2: Genera una contraseña hexadecimal (solo caracteres 0-9 y a-f)
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
