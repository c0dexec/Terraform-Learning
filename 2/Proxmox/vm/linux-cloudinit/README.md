# A template VM
To prepare the template which will be used for cloning, we create a basic VM.
- To create the VM execute,`qm create 9000 --name cloudinit-template --memory 2048 --scsihw virtio-scsi-single`
- To attach a bootable image execute, `qm set 9000 --scsi0 local-lvm:0,import-from=/tmp/debian-12-genericcloud-amd64.qcow2`

If the machine is stuck in a creation loop then remember to check if `agent` field has been set to `0` as if cloud-img doesn't have qemu-agent pre-installed it will result in errors.

# Lessons Learned
- Add a `ciuser` and `cipassword` to troubleshoot.
- Check GitHub for solutions or possible issues reported.

# Reference
- https://github.com/Telmate/terraform-provider-proxmox/issues/959
- https://github.com/Telmate/terraform-provider-proxmox/issues/922#issuecomment-1923899040