#!/bin/bash

# Обновление системы и установка необходимых пакетов
apt-get update
apt-get install -y mdadm parted

# Создание RAID10 из 4 дисков
mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/sd[b-e]

# Создание конфигурационного файла для автоматической сборки RAID при загрузке
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

# Создание GPT раздела на RAID
parted /dev/md0 --script mklabel gpt

# Создание 5 партиций на RAID
parted /dev/md0 --script mkpart primary 0% 20%
parted /dev/md0 --script mkpart primary 20% 40%
parted /dev/md0 --script mkpart primary 40% 60%
parted /dev/md0 --script mkpart primary 60% 80%
parted /dev/md0 --script mkpart primary 80% 100%

# Создание файловых систем на каждой из партиций
for i in $(seq 1 5); do
  mkfs.ext4 /dev/md0p$i
done

# Монтирование партиций (опционально)
for i in $(seq 1 5); do
  mkdir -p /mnt/raid/part$i
  mount /dev/md0p$i /mnt/raid/part$i
done

# Добавление записей в fstab для автоматического монтирования при загрузке
for i in $(seq 1 5); do
  echo "/dev/md0p$i /mnt/raid/part$i ext4 defaults 0 0" >> /etc/fstab
done
