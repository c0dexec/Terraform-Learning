module "vm-module" {
  proxmox_url      = var.proxmox_url
  proxmox_user     = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_node     = var.proxmox_node
  pve_password     = var.pve_user_password
  proxmox_node_ip  = "10.0.0.5"
  # Child module being called upon
  source            = "../../modules/vm/linux/v5"
  vm_name           = "VM"
  vm_count          = 1
  vm_cores          = 2
  vm_memory         = 1500
  storage_disk      = "Disk0"
  vm_storage_disk   = "local-lvm"
  vm_disk-size      = 40

  # Network config
  vm_ip_network     = "11.1.0."
  vm_ip_network_bit = "24"
  vm_ip_gateway     = "11.1.0.1"
  vm_ip_host        = 15

  vm_clone          = "cloudinit-template"
  # Values being used by the modules are defined here.
  vm_display     = "qxl"
  vm_bridge      = "vmbr1"
  ssh_public_key = var.ssh_public_key
  tags           = "kubernetes,terraform"
}
