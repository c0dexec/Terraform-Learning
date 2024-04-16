provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "ec2" {
  ami           = "ami-08562e2b679f7eef5"
  instance_type = "t2.micro"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}