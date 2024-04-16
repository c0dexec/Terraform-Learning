resource "local_file" "pets" {
  filename = each.value
  for_each = var.filename-set # Instead of converting filename to be a "set" one can also use "toset" to retain the list while using, for_each = toset(var.filename) 
  content = "Test"
}

resource "local_file" "pets-toset" {
  filename = each.value
  for_each = toset(var.filename-list) # Instead of converting filename to be a "set" one can also use "toset" to retain the list while using, for_each = toset(var.filename) 
  content = "Test"
}

output "pets" {
  value = local_file.pets
  sensitive = true
}

output "pets-toset" {
  value = local_file.pets-toset
  sensitive = true
}