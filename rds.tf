resource "aws_db_subnet_group" "default" {
  name       = "default-db-subnet-group"
  subnet_ids = [aws_subnet.ministore-subnet-1.id, aws_subnet.ministore-subnet-2.id]

  tags = {
    Name = "default-db-subnet-group"
  }
}

resource "random_password" "db_password" {
  length           = 16
  upper            = true
  lower            = true
  numeric          = true
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/ministore/db_password"
  description = "The database password"
  type        = "SecureString"
  value       = random_password.db_password.result
  overwrite   = true
}

resource "aws_db_instance" "ministore-db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres" # Change the engine to PostgreSQL
  engine_version         = "16.3"     # Specify the desired PostgreSQL version
  instance_class         = var.rds_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = aws_ssm_parameter.db_password.value
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.ministore-db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
}