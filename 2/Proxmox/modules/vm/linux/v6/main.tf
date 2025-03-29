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

# Specify the IP address you want to use for the VM
locals {
  ip_network     = var.vm_ip_network
  ip_host_bit    = [for x in range(var.vm_count) : var.vm_ip_host + x]
  ip_network_bit = var.vm_ip_network_bit
  ip_gateway     = var.vm_ip_gateway
}

locals {
  vm_fname         = [for x in range(var.vm_count) : join("-", [var.vm_name, x])]
  pve_node         = var.proxmox_node
  iso_storage_pool = var.storage_disk
}

data "local_file" "user_data" {
  filename = "${path.cwd}/YAML/user.yaml"
}

resource "proxmox_cloud_init_disk" "ci" {
  count    = var.vm_count
  name     = local.vm_fname[count.index]
  pve_node = local.pve_node
  storage  = local.iso_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(local.vm_fname[count.index])
    local-hostname = local.vm_fname[count.index]
  })

  user_data = data.local_file.user_data.content

  network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "eth0"
      subnets = [{
        type    = "static"
        address = "${local.ip_network}${local.ip_host_bit[count.index]}/${local.ip_network_bit}"
        gateway = "${local.ip_gateway}"
        dns_nameservers = [
          "1.1.1.1",
          "8.8.8.8"
        ]
      }]
    }]
  })
}

resource "proxmox_vm_qemu" "vms" {
  # Variables are defined before they get used later on by the "root" module.
  name  = local.vm_fname[count.index]
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
        cloudinit {
          storage = local.iso_storage_pool
        }
      }
      scsi1 {
        cdrom {
          iso = "${local.iso_storage_pool}:${proxmox_cloud_init_disk.ci[count.index].id}"
        }
      }
      scsi2 {
        disk {
          storage    = var.vm_storage_disk
          size       = var.vm_disk-size
          emulatessd = true
          discard    = true
        }
      }
    }
  }

  boot = "order=scsi0;scsi1;scsi2"

  vga {
    type = var.vm_display
  }

  ciuser     = "root"
  cipassword = "salmon"
  ciupgrade  = true

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

# output "ssh_public_key" {
#   value = tls_private_key.ssh_key.public_key_openssh
# }

output "vmid" {
  value = proxmox_vm_qemu.vms[*].vmid
}

output "name" {
  value = proxmox_vm_qemu.vms[*].name
}