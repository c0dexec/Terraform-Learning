# The variable names are what get used when referring it in a "main.tf" file
variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_user" {
  type      = string
  default   = "terraform-prov@pve!terraform-api"
  sensitive = true
}

variable "proxmox_url" {
  type      = string
  default   = "https://10.0.0.5:8006/api2/json"
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "pve_user_password" {
  type = string
  sensitive = true
  ephemeral = true
}

variable "ssh_public_key" {
  type = string
  sensitive = true
}