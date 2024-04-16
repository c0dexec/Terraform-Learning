provider "aws" {
  region     = "ca-central-1"
  access_key = "access-key"
  secret_key = "secret-key"
}

resource "aws_db_instance" "db-1" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro" # Free Tier of database instance type
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7" # Default Group that exists
  skip_final_snapshot  = true
}
