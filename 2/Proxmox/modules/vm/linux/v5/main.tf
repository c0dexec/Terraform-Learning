provider "proxmox" {
  # Configuration options
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_user
  pm_api_token_secret = var.proxmox_password
  pm_tls_insecure     = true

  # /*
  # Enables extra logging https://github.com/Telmate/terraform-provider-proxmox/issues/455#issuecomment-984324159
  # */
  pm_debug      = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  # pm_log_levels = {
  #   _default    = "debug"
  #   _capturelog = ""
  # }
}

# resource "null_resource" "cloud_init_user_data_file" {
#   connection {
#     user        = "root"
#     private_key = file("ssh-keys/pve-root")
#     host        = "10.0.0.5"
#     port        = 22
#   }

#   provisioner "file" {
#     source      = "YAML/user.yaml"
#     destination = "/var/lib/vz/snippets/user.yaml"
#   }
# }

# Specify the IP address you want to use for the VM
locals {
  ip_network     = var.vm_ip_network
  ip_host_bit = var.vm_ip_host != null ? [for x in range(var.vm_count) : var.vm_ip_host + x] : null
  ip_network_bit = var.vm_ip_network_bit
  ip_gateway     = var.vm_ip_gateway
}

locals {
  vm_fname         = [for x in range(var.vm_count) : join("-", [var.vm_name, x])]
  pve_node         = var.proxmox_node
  iso_storage_pool = var.storage_disk
}

# Modify path for templatefile and use the recommended extension of .tftpl for syntax hylighting in code editors.
resource "local_file" "cloud_init_user_data_file" {
  count    = var.is_cloud_init_config_present ? var.vm_count : 0
  content  = var.is_cloud_init_config_present ? templatefile("${path.cwd}/YAML/user.tftpl", { ssh_key = var.ssh_public_key, hostname = local.vm_fname[count.index], network = local.ip_network, host_bit = local.ip_host_bit[count.index], network_bit = local.ip_network_bit, gateway = local.ip_gateway }) : ""
  filename = "${path.cwd}/files/user_data_${local.vm_fname[count.index]}-${count.index}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = var.is_cloud_init_config_present ? var.vm_count : 0
  connection {
    type     = "ssh"
    user     = var.pve_user
    password = var.pve_password
    host     = var.proxmox_node_ip
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/user_data_vm-${local.vm_fname[count.index]}-${count.index}.yml"
  }
}

resource "proxmox_vm_qemu" "vms" {
  # Variables are defined before they get used later on by the "root" module.
  count = var.vm_count
  name  = local.vm_fname[count.index]
  vmid  = 0
  desc  = "Provisioning VM for Kubernetes cluster via Terraform."
  tags  = var.tags

  # bios    = "seabios"
  os_type = "cloud-init"
  vm_state = var.vm_state

  clone  = var.vm_clone
  scsihw = "virtio-scsi-pci"

  target_node = var.proxmox_node

  memory  = var.vm_memory
  balloon = "1"

  cores    = var.vm_cores
  sockets  = 1
  vcpus    = 0
  cpu_type = "host"

  agent = 1

  network {
    model  = "virtio"
    bridge = var.vm_bridge
    id     = 0
  }

  dynamic "disks" {
    for_each = var.is_vm_disk_present ? [1] : []

    content {
        scsi {
          scsi0 {
            disk {
              storage    = var.vm_storage_disk
              size       = var.vm_disk-size
              emulatessd = true
              discard    = true
            }
          }
        }

        dynamic "ide" {
          for_each = var.is_cloud_init_config_present ? [1] : [] # Only include if true

          content {
            ide0 {
              cloudinit {
                storage = local.iso_storage_pool
              }
            }
          }
        }
      }
    }

  boot = var.is_cloud_init_config_present ? "order=scsi0" : "order=ide0;scsi0"

  vga {
    type = var.vm_display
  }

  ciuser          = "root"
  cipassword      = "salmon"
  cicustom        = var.is_cloud_init_config_present ? "user=local:snippets/user_data_vm-${local.vm_fname[count.index]}-${count.index}.yml" : null
  ipconfig0       = var.is_cloud_init_config_present ? "ip=${local.ip_network}${local.ip_host_bit[count.index]}/${local.ip_network_bit},gw=${local.ip_gateway}" : null
  ssh_private_key = var.is_cloud_init_config_present ? file("./ssh-keys/root") : null
  sshkeys         = var.is_cloud_init_config_present ? file("./ssh-keys/root.pub") : null
  ciupgrade       = true

  depends_on = [null_resource.cloud_init_config_files]

  # provisioner "remote-exec" {
  #   inline = [ "whoami" ]
  # }
}

# resource "local_file" "ssh-pub-key" {
#   filename = "./ssh-keys/ssh-key.pub"
#   content  = tls_private_key.ssh_key.public_key_openssh
# }

output "macaddr" {
  value      = proxmox_vm_qemu.vms[*].network
  depends_on = [proxmox_vm_qemu.vms]
}

# output "ssh_public_key" {
#   value = tls_private_key.ssh_key.public_key_openssh
# }

output "vmid" {
  value = proxmox_vm_qemu.vms[*].vmid
}

output "name" {
  value = proxmox_vm_qemu.vms[*].name
}

output "ipconfig" {
  value = proxmox_vm_qemu.vms[*].ipconfig0
}

output "ciuser" {
  value = proxmox_vm_qemu.vms[*].ciuser
}
