terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.32.1"
    }
  }
}

provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true


  tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Lab 1 GW"
  }
}

# A route pointing to the internet gateway is required for internet connectivity.
resource "aws_default_route_table" "route-table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Lab 1 routing"
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_subnet" "my_subnet" {
  count = length(var.subnet)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "My subnet"
  }
}

resource "aws_lb" "loadbalancer" {
  name               = "lb-instances"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_ssh.id]
  subnets            = aws_subnet.my_subnet[*].id // Didn't use a "for" loop as there is not iterable data present only a single value. So we can use [*] to grab all IDs.

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "ubuntus" {
  name     = "loadbalancer-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ubuntus.arn
  }
}

resource "aws_network_interface" "interface" {
  for_each        = toset(var.ip_addr)
  subnet_id       = aws_subnet.my_subnet[1].id
  private_ips     = ["${each.value}"]
  security_groups = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "Primary Network Interface for ${each.value}"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnRsnYghEknl2/J2xO+cS9NAcJI9iDyyyPOsDRwKFRc c0dexec@Gaming-RIG"
}

resource "aws_instance" "ec2" {
  for_each      = aws_network_interface.interface
  ami           = "ami-0a2e7efb4257c0907"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh-key.key_name
  user_data     = file("${path.module}/apache.sh")

  network_interface {
    network_interface_id = each.value.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

output "instance_public_ips" {
  value = [
    for ip in var.ip_addr : aws_instance.ec2[ip].public_ip
  ]
}