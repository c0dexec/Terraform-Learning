provider "proxmox" {
  # Configuration options
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_user
  pm_api_token_secret = var.proxmox_password

  /*
  Enables extra logging https://github.com/Telmate/terraform-provider-proxmox/issues/455#issuecomment-984324159
  */
  pm_debug      = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

# Root module
module "vm-module" {
  # Child module being called upon
  source = "../../modules/vm/linux/v1"

  # Values being used by the modules are defined here.
  vm_name        = "Linux-machine"
  vm_description = "Provisioning VM via Terraform."
  vm_iso         = "local:iso/Any-Linux.iso"
  # Single SPICE display
  vm_display = "qxl"
}
