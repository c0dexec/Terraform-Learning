resource "proxmox_vm_qemu" "kube-nodes" {
  # Variables are defined before they get used later on by the "root" module.
  name       = var.vm_name
  desc       = var.vm_description
  clone      = var.vm_clone
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0"

  target_node = "pve-R730"

  memory  = "8192"
  balloon = "1"

  cores   = 4
  sockets = 1
  vcpus   = 0
  cpu     = "host"

  network {
    model  = "virtio"
    bridge = "vmbr1"
    # macaddr = var.vm_macaddr
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = 60
        }
      }
    }
  }

  vga {
    type = var.vm_display
  }

  os_type                 = "cloud-init"
  cicustom                = var.vm_cicustom
  cloudinit_cdrom_storage = "local-lvm"
  ciuser = "root"
  cipassword = "salmon"
  # ipconfig0               = var.vm_ipconfig
}
