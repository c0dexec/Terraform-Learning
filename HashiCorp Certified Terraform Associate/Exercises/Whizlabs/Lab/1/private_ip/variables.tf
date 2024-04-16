variable "access_key" {
  type = string
  sensitive = true
  description = "Access key generated."
}

variable "secret_key" {
  type = string
  sensitive = true
  description = "Secret key generated for the access key."
}

variable "ip_addr" {
  type = list(string)
  sensitive = false
  description = "IP addresses pool for EC2 instances."
}

variable "subnet" {
  type = list(string)
  sensitive = false
  description = "IP addresses pool for EC2 instances."
}

variable "availability_zone" {
  type = list(string)
  sensitive = false
  description = "IP addresses pool for EC2 instances."
}