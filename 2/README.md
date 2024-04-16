# Creates Continer
This terraform deployment creates a basic LXC container.

The commands used,
+ `terraform init` - Initializes the project.
+ `terraform plan` - Comannd is to query the API and do a comparision as to what all specific resources are being used by us.
+ `terraform apply` - Used to apply the terraform code to provision our container.
+ `terraform destroy` - Used afterwards to destroy the spun up instance.

***Note**: `-var-file` can be used to specify a `.tfvars` type. Such as `terraform apply -var-file="secret.tfvars"`, `terraform plan -var-file="secret.tfvars"`, etc. Version `2.9.13` was broken. So made use of `2.9.11`.*

To continue to next module [click here](https://youtu.be/7xngnjfIlK4?t=1662 "Part 3").