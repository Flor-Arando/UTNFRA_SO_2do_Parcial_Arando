#!/bin/bash

# Volúmenes físicos
sudo pvcreate /dev/sdc /dev/sdd

# Grupo de volúmenes
sudo vgcreate vg_datos /dev/sdc
sudo vgcreate vg_temp /dev/sdd

# Volúmenes lógicos
sudo lvcreate -L +5M vg_datos -n lv_docker
sudo lvcreate -L +1.5G vg_datos -n lv_workareas
sudo lvcreate -L +512M vg_temp -n lv_swap

# Formatear los volúmenes lógicos
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap

# Montar los volúmenes y activar la swap
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker/
sudo mkdir -p /work/
sudo mount /dev/mapper/vg_datos-lv_workareas /work/
sudo swapon /dev/mapper/vg_temp-lv_swap

# Agregar al archivo /etc/fstab para la persistencia
echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab

# Verificar el montaje y la swap
df -h  # volúmenes montados
free -h  # swap activada

# Reiniciar el servicio de Docker
sudo systemctl restart docker
sudo systemctl status docker

