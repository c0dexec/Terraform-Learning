module "vm-module" {
  proxmox_url = var.proxmox_url
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_node = var.proxmox_node
  # Child module being called upon
  source = "../../modules/vm/linux/v4"
  vm_name = "Kali"
  vm_count = 1
  vm_cores = 2
  vm_memory = 3000
  storage_disk = "local-lvm"
  vm_disk-size = 100
  vm_ip_host = 10
  vm_clone = "kali-template"
  # Values being used by the modules are defined here.
  vm_display = "qxl"
  vm_bridge = "vmbr2"
  tags = "terraform,kali,cyber"
}
