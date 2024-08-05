# ssh_key.tf
resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file(var.ssh_public_key_path) # Path to your existing public key
}