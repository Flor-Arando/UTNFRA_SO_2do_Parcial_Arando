#!/bin/bash

# Parámetros del script
USUARIO=$1  # Usuario del cual se obtendrá la clave
LISTA_USUARIOS=$2  # Lista de usuarios (nombre, grupo, home)

# Guardar el valor actual del IFS (Internal Field Separator)
ANT_IFS=$IFS
IFS=$'\n'  # Cambiar el IFS para que el for itere línea por línea

# Iterar sobre cada línea de la lista de usuarios
for i in $(cat "$LISTA_USUARIOS" | grep -v '^#'); do
    # Extraer datos de cada línea
    USUARIO_NOMBRE=$(echo "$i" | awk -F ',' '{print $1}')
    GRUPO=$(echo "$i" | awk -F ',' '{print $2}')
    DIR_HOME_USR=$(echo "$i" | awk -F ',' '{print $3}')
    
    # Crear grupo y usuario
    sudo groupadd "$GRUPO"
    sudo useradd -d "$DIR_HOME_USR" -s /bin/bash -G "$GRUPO" -p "$(sudo grep "$USUARIO" /etc/shadow | awk -F ':' '{print $2}')" "$USUARIO_NOMBRE"    
done

# Restaurar el IFS original
IFS=$ANT_IFS

