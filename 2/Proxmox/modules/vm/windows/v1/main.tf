resource "proxmox_vm_qemu" "proxmox_vm" {
  # Variables are defined before they get used later on by the "root" module.
  name = var.vm_name
  desc = var.vm_description
  iso  = var.vm_iso

  # Relies on the disks installed
  boot = "order=scsi0;ide2;ide1"

  # Controller needs to be "VirtIO SCSI" for Windows https://pve.proxmox.com/wiki/Windows_10_guest_best_practices
  scsihw = "virtio-scsi-pci"

  # Enabling VirtIO Agent
  agent = 1

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

  # "SCSI" type disk for Windows
  disk {
    type    = "scsi"
    storage = "Disk0"
    size    = "120G"
    format  = "qcow2"
    cache   = "writeback"
  }

  # This gets loaded before the ISO file. So, if ISO is "ide2" this will be "ide1"
  disk {
    type    = "ide"
    volume  = "local:iso/virtio-win-0.1.229.iso"
    storage = "local"
    # used "ls -al --block-size=KiB" to get the file size https://unix.stackexchange.com/a/64150. Here "i" gives you exact value.
    size  = "522284K"
    media = "cdrom"
  }

  vga {
    type = var.vm_display
  }
}
