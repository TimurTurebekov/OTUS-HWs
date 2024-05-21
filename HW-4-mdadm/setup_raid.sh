#!/bin/bash
sudo apt-get update && sudo apt-get install -y mdadm
# Подтверждение на создание массива без конфигурационного файла
echo 'DEVICE partitions' | sudo tee -a /etc/mdadm/mdadm.conf
sudo mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# Создание GPT раздела и 5 партиций
sudo parted -s /dev/md0 mklabel gpt
sudo parted -s /dev/md0 mkpart primary ext4 1MiB 400MiB
sudo parted -s /dev/md0 mkpart primary ext4 401MiB 800MiB
sudo parted -s /dev/md0 mkpart primary ext4 801MiB 1200MiB
sudo parted -s /dev/md0 mkpart primary ext4 1201MiB 1600MiB
sudo parted -s /dev/md0 mkpart primary ext4 1601MiB 2000MiB
