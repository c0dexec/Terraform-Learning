## Resource
The "aws_instance" is the resource type provided to us by "aws" provider. "ec2" is the local variable used to specify the resource configurations.
```json
resource "aws_instance" "ec2" {
  ami = "ami-08562e2b679f7eef5"
  instance_type = "t2.micro"
}
```
## Mutiple providers
When mutiple providers are present within a single or mutiple `tf` file within a directory, terraform initializes all the providers within the same `.terraform` folder. All mantained providers go under `hashicorp` directory, rest have their own directory created.

### Non Terrform Providers
Providers that are being mantained by other providers cannot be initialized unless the `terrform` block is mentioned. For [example](./ec2.tf#L16) we can see DigitalOcean being called. Furthermore, only one instance of `required_providers` can be mentioned, so we [append `digitalocean` within the `github.tf` file](./github.tf#7).
```json
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
```
## Setting Variables
The following [article](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables) provides information on how to setup variables, it also works for variables that are sensitive in nature.

# EC2 Service
## Application and OS
There are alot of OS's from which one can choose from. We device to use the free tier version.
## Instance Type
Chose the free one called T2.Micro which contains, 1 vCPU, 1 GiB Memory.