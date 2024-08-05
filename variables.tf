# variables.tf
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "ministoredb"
}

variable "db_username" {
  default = "pguser"
}

variable "db_password" {
  default = "password"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "github_token" {
  type = string
}