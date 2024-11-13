#!/bin/bash

# Expande el volumen lógico para Docker
cd
df -h /var/lib/docker/ # Ver tamaño actual
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
df -h /var/lib/docker/
sudo systemctl restart docker # Reiniciamos el servicio de Docker
sudo systemctl status docker

# Configuración de la ruta
cd /home/arando/UTNFRA_SO_2do_Parcial_Arando/202406/docker

# Crear y sobrescribir el archivo index.html con mis datos
RUTA_INDEX="/home/arando/UTNFRA_SO_2do_Parcial_Arando/202406/docker/index.html"
sudo tee "$RUTA_INDEX" << EOF > /dev/null
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Noviembre 2024 </h2> </br>
<h3> FLORENCIA ARANDO</h3>
<h3> División: 116</h3>
</div>
EOF
echo "Contenido de index.html modificado exitosamente."

# Crear el archivo Dockerfile
RUTA_DOCKERFILE="/home/arando/UTNFRA_SO_2do_Parcial_Arando/202406/docker/Dockerfile"
sudo tee "$RUTA_DOCKERFILE" << EOF > /dev/null
FROM nginx
COPY index.html /usr/share/nginx/html
EOF
echo "Dockerfile creado exitosamente."

# Crear el archivo run.sh
RUTA_RUN_SH="/home/arando/UTNFRA_SO_2do_Parcial_Arando/202406/docker/run.sh"
sudo tee "$RUTA_RUN_SH" << EOF > /dev/null
#!/bin/bash
docker run -d -p 8081:80 flor97/web1arando
EOF
sudo chmod +x "$RUTA_RUN_SH" # Hacer ejecutable el script run.sh
echo "Script run.sh creado y hecho ejecutable exitosamente."

# Agregar el usuario arando al grupo docker
sudo usermod -a -G docker arando

# Construir la imagen de Docker
docker build -t flor97/web1arando:latest . # Construir la imagen de Docker
docker image list

# Pushear la imagen a Docker Hub
docker push flor97/web1arando:latest
./run.sh
