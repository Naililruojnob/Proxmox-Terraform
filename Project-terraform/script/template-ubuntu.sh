cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64.img
sudo virt-customize -a ubuntu-20.04-server-cloudimg-amd64.img --install qemu-guest-agent
sudo virt-customize -a ubuntu-20.04-server-cloudimg-amd64.img --root-password password:stephane
sudo qm create 9999 --name "ubuntu.robert.local" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
sudo sudo qm importdisk 9999 ubuntu-20.04-server-cloudimg-amd64.img local
qm set 9999 --tags "template,test"
sudo qm set 9999 --scsihw virtio-scsi-pci --scsi0 local:9999/vm-9999-disk-0.raw
sudo qm set 9999 --boot c --bootdisk scsi0
sudo qm set 9999 --ide2 local:cloudinit
sudo qm set 9999 --serial0 socket --vga serial0
sudo qm set 9999 --agent enabled=1
sudo qm set 9999 --ipconfig0 ip=dhcp
sudo qm template 9999