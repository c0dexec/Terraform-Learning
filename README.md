# Terraform learning
## Know issues
+ If you have any role issues. Try modifying the role with either `cli` or via the `gui` located under the "Datacenter"->"Permissions"->"Roles".

+ [Video](https://www.youtube.com/watch?v=7xngnjfIlK4 "YouTube video!") being followed is the following.
+ [GitHub repo](https://github.com/sidpalas/devops-directive-terraform-course "GitHub repo!") to the learning material.


# Creation of `main.tf`

Usually `main.tf` file contains a provider section which signifies which Provider is being utilized.

## Required Providers
```json
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}
...
```

## Using Provider

Makes use of arguments provided by the provider.

```json
provider "proxmox" {
  # Configuration options
  pm_api_url          = "https://10.0.0.5:8006/api2/json"
  pm_api_token_id     = "token-id"
  pm_api_token_secret = "secret-token"
  
  /*
  Enables extra logging https://github.com/Telmate/terraform-provider-proxmox/issues/455#issuecomment-984324159. This can also be found under "Logging" section of provider's documentation https://registry.terraform.io/providers/Telmate/proxmox/latest/docs.
  */
  pm_debug            = true
  pm_log_enable       = true
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
```

## Using Resources
Makes use of arguments provided by provider to add the resources that are required.

```json
resource "proxmox_lxc" "basic" {
  target_node  = "pve-R730"
  hostname     = "Test-tf-container"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password     = "testmonkey"
  unprivileged = true

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
```