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
  ip_network     = "11.1.0."
  ip_host_bit    = var.vm_ip_host
  ip_network_bit = "24"
  ip_gateway     = "11.1.0.1"
}

# resource "tls_private_key" "ssh_key" {
#   algorithm = "ED25519"
# }

resource "proxmox_vm_qemu" "vms" {
  # Variables are defined before they get used later on by the "root" module.
  name  = "${var.vm_name}-${count.index}"
  desc  = "Provisioning VM for Kubernetes cluster via Terraform."
  tags  = var.tags
  count = var.vm_count
  # bios    = "seabios"
  os_type = "cloud-init"

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

  disks {
    scsi {
      scsi0 {
        disk {
          storage    = var.storage_disk
          size       = var.vm_disk-size
          emulatessd = true
          discard    = true
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.storage_disk
        }
      }
    }
  }
  boot = "order=ide0;scsi0"

  vga {
    type = var.vm_display
  }

  ciuser          = "root"
  cipassword      = "salmon"
  cicustom        = "user=local:snippets/user.yml"
  ipconfig0       = "ip=dhcp"
  ssh_private_key = file("./ssh-keys/root")
  sshkeys         = file("./ssh-keys/root.pub")

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }

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
