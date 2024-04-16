provider "proxmox" {
  # Configuration options
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_user
  pm_api_token_secret = var.proxmox_password

  # /*
  # Enables extra logging https://github.com/Telmate/terraform-provider-proxmox/issues/455#issuecomment-984324159
  # */
  # pm_debug      = true
  # pm_log_enable = true
  # pm_log_file   = "terraform-plugin-proxmox.log"
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
  name    = "VM-${count.index}"
  desc    = "Provisioning VM for Kubernetes cluster via Terraform."
  tags    = "terraform,kubernetes"
  count   = var.vm_count
  # bios    = "seabios"
  os_type = "cloud-init"

  clone  = var.vm_clone
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0"

  target_node = var.proxmox_node

  memory  = var.vm_memory
  balloon = "1"

  cores   = var.vm_cores
  sockets = 1
  vcpus   = 0
  cpu     = "host"

  agent = 0

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = var.vm_disk-size
        }
      }
    }
  }

  vga {
    type = var.vm_display
  }

  cloudinit_cdrom_storage = "local-lvm"
  ciuser                  = "root"
  cipassword              = "salmon"
  # cicustom                = "user=local:snippets/user.yaml"
  ipconfig0 = "ip=${local.ip_network}${sum([local.ip_host_bit + count.index])}/${local.ip_network_bit},gw=${local.ip_gateway}"
  ssh_private_key = file("./ssh-keys/root")
  sshkeys   = file("./ssh-keys/root.pub")

  # connection {
  #   user     = "root"
  #   password = "salmon"
  #   host     = "${local.ip_network}${sum([local.ip_host_bit + count.index])}"
  #   type = "ssh"
  # }

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
