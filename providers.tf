# providers.tf
provider "aws" {
  region = "us-west-2" # Change to your preferred region
}

provider "github" {
  token = "${var.github_token}"
  owner = "${var.github_owner}"
}