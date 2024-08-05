# variables.tf
variable "ec2_home_path" {
  default = "/home/ec2-user"
}

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

variable "github_owner" {
  default = "ricardotulio"
}

variable "github_project" {
  default = "ministore-api"
}

variable "github_repo" {
  default = "https://github.com/ricardotulio/ministore-api"
}

variable "github_branch" {
  default = "main"
}

variable "ssh_user" {
  type = string
}

variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "github_token" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}