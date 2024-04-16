resource "local_file" "pet" {
  filename = var.filename[count.index] # Iterates through the index values such as "var.filename[0]" which would be "./pets.txt" and so on. https://developer.hashicorp.com/terraform/language/meta-arguments/count#the-count-object
  content = "test"
  count = length(var.filename) # Scales count automatically based on the length of the filename list
}

output "pets" {
  value = local_file.pet
  sensitive = true
}
