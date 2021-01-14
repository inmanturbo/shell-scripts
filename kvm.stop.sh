#!/bin/ash
STORAGE_HOST=freebsd12.0
STORAGE_POOL=nfs

# Get all running vms
for VM in $(virsh list --name) 
do
  # Attempt to Save them
   if [[ ! "$VM" == "${STORAGE_HOST}" ]] ; then
  virsh managed-save "$VM"
  fi
done


# Get all running vms
for VM in $(virsh list --name) 
do
  # Attempt to shutdown those which could not be saved
   if [[ ! "$VM" == "${STORAGE_HOST}" ]] ; then
  virsh shutdown "$VM"
  fi
done

virsh list > /root/scripts/shutdown-vms.txt;
virsh list;

# Get all running vms
for VM in $(virsh list --name) 
do
  # Kill the ones that possibly hung
  # remember the important thing
  # is to free up the zfs pool
   if [[ ! "$VM" == "${STORAGE_HOST}" ]] ; then
  virsh destroy "$VM"
  fi
done

virsh list > /root/killed-vms.txt;
virsh list;


virsh pool-destroy ${STORAGE_POOL}
virsh shutdown ${STORAGE_HOST}

exit 0;