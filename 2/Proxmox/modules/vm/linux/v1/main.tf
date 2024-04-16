resource "proxmox_vm_qemu" "proxmox_vm" {
  # Variables are defined before they get used later on by the "root" module.
  name = var.vm_name
  desc = var.vm_description
  iso  = var.vm_iso

  target_node = "pve-R730"

  memory  = "16384"
  balloon = "1"

  cores   = 2
  sockets = 1
  vcpus   = 0
  cpu     = "host"

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  disk {
    type    = "scsi"
    storage = "Disk0"
    size    = "120G"
    format  = "qcow2"
  }

  vga {
    type = var.vm_display
  }
}
