variable "proxmox_url" {
  type = string
  sensitive = true
}

variable "proxmox_user" {
  type = string
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "vm_name" {
  type = string
}

variable "vm_display" {
  type = string
}

variable "vm_memory" {
  type = number
}

variable "vm_cores" {
  type = number
}

variable "vm_clone" {
  type = string
}

variable "vm_bridge" {
  type = string
}

variable "vm_ip_host" {
  type = number
}

variable "vm_ip_network" {
  type = string
}

variable "vm_ip_network_bit" {
  type = string
}

variable "vm_ip_gateway" {
  type = string
}

variable "vm_ciuser" {
  type = string
  default = "root"
}

variable "vm_cipassword" {
  type = string
  sensitive = true
  default = "salmon"
}

variable "vm_count" {
  type = number
}

variable "vm_disk-size" {
  type = number
}

variable "storage_disk" {
  type = string
}

variable "vm_storage_disk" {
  type = string
}

variable "tags" {
  type = string
}