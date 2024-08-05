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

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "github_token" {
  type = string
}