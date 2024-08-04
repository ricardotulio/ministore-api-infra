# ec2.tf
resource "aws_instance" "ministore-api" {
  ami             = "ami-0b36f2748d7665334" # Change to your preferred AMI
  instance_type   = var.ec2_instance_type
  subnet_id       = aws_subnet.ministore-subnet-1.id
  security_groups = [aws_security_group.ministore-ec2.id]
  key_name        = aws_key_pair.ssh-key.key_name # Associate the key pair

  user_data = file("./scripts/ec2_setup.sh")
}