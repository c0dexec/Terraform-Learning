/*
Specify the provider being used in our case Proxmox.
https://registry.terraform.io/providers/Telmate/proxmox/latest
*/
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url          = "https://10.0.0.5:8006/api2/json"
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

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

resource "proxmox_lxc" "basic" {
  target_node  = "pve-R730"
  hostname     = "valheim-server"
  ostemplate   = "local:vztmpl/ubuntu-23.04-standard_23.04-1_amd64.tar.zst"
  password     = "salmon"
  unprivileged = true
  cores        = "4"
  memory       = "6144"

  features {
    nesting = true
  }
  
  // Terraform will crash without rootfs defined
  rootfs {
    storage = "Disk0"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "dhcp"
  }
}
