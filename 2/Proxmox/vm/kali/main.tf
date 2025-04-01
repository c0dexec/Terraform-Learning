module "vm-module" {
  proxmox_url = var.proxmox_url
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_node = var.proxmox_node
  # Child module being called upon
  source = "../../modules/vm/linux/v5"
  vm_state = "stopped" # Default value is stopped, other values are started (starts on boot) and running.
  vm_name = "Kali"
  vm_count = 1
  vm_cores = 2
  vm_memory = 3000
  vm_disk-size = 60
  vm_clone = null
  # Values being used by the modules are defined here.
  vm_display = "qxl"
  vm_bridge = "vmbr2"
  tags = "terraform,kali,cyber"
}
