module "vm-module" {
  proxmox_url = var.proxmox_url
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_node = var.proxmox_node
  # Child module being called upon
  source = "../../modules/vm/linux/v3"
  vm_count = 6
  vm_cores = 2
  vm_memory = 1500
  vm_disk-size = 40
  vm_ip_host = 15
  vm_clone = "cloudinit-template"
  # Values being used by the modules are defined here.
  vm_display = "qxl"
}
