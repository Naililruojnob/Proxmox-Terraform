#!/bin/bash

cd /var/lib/vz/template/iso

# Télécharger l'image Debian
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2

# Installer les outils nécessaires
sudo apt-get update
sudo apt-get install -y libguestfs-tools

# Personnaliser l'image avec qemu-guest-agent
sudo virt-customize -a debian-11-genericcloud-amd64.qcow2 --install qemu-guest-agent

# Configurer le mot de passe root
sudo virt-customize -a debian-11-genericcloud-amd64.qcow2 --root-password password:stephane

# Créer la VM
sudo qm create 9999 --name "debian-bullseye-vm" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# Importer le disque QCOW2 dans Proxmox
sudo qm importdisk 9999 debian-11-genericcloud-amd64.qcow2 local

# Ajouter des tags à la VM
sudo qm set 9999 --tags "template,test"

# Configurer le contrôleur SCSI et le boot disk
sudo qm set 9999 --scsihw virtio-scsi-pci --scsi0 local:9999/vm-9999-disk-0.raw
sudo qm set 9999 --boot c --bootdisk scsi0

# Configurer le lecteur de cloud-init
sudo qm set 9999 --ide2 local:cloudinit

# Configurer le port série et la VGA (comme Ubuntu)
sudo qm set 9999 --serial0 socket --vga serial0

# Activer l'agent QEMU Guest
sudo qm set 9999 --agent enabled=1

# Configurer les paramètres réseau (IP DHCP)
sudo qm set 9999 --ipconfig0 ip=dhcp

# Finaliser la VM comme template
sudo qm template 9999
