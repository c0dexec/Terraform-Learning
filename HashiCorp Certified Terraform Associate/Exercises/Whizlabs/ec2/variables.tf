variable "access_key" {
  type = string
  sensitive = true
  description = "Access key generated."
}

variable "github_token" {
  type = string
  sensitive = true
  description = "Github token generated for apSambhav"
}

variable "secret_key" {
  type = string
  sensitive = true
  description = "Secret key generated for the access key."
}