#!/bin/ash
ANSIBLE_REPO=https://github.com/inmanturbo/ansible-node.git
STORAGE_HOST=freebsd12.0
STORAGE_POOL=nfs


mkdir -p /var/lib/libvirt/images/nfs
apk add ansible
ansible-pull -U $ANSIBLE_REPO

until service status libvirtd
do
  echo "Waiting for libvirtd"
done

virsh start $STORAGE_HOST

until virsh pool-start $STORAGE_POOL
do
  echo "Storage host not ready"
done

### Restore Vms: ####

# Get all saved vms
for VM in $(virsh list --all --with-managed-save --name) 
do
  # Restore them
  virsh restore "$VM"
done

virsh list > /root/restored-vms.txt;
virsh list;

# Get all vms marked for autostart which are not allready running
for VM in $(virsh list --autostart --inactive --name) 
do
  # Start them
  virsh start "$VM"
done

virsh list;

exit 0;