# Define EC2 Instance
resource "aws_instance" "ministore-api" {
  ami             = "ami-0b36f2748d7665334" # Change to your preferred AMI
  instance_type   = var.ec2_instance_type
  subnet_id       = aws_subnet.ministore-subnet-1.id
  security_groups = [aws_security_group.ministore-ec2.id]
  key_name        = aws_key_pair.ssh-key.key_name # Associate the key pair
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("./scripts/ec2_setup.sh")

  tags = {
    Name = "ministore-api-ec2"
  }
}

# Define the IAM Role for EC2 to use with CodeDeploy
resource "aws_iam_role" "ec2_instance_role" {
  name = "EC2InstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EC2InstanceRole"
  }
}

# Attach the AmazonEC2RoleforAWSCodeDeploy managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_codedeploy_role_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# Attach the AmazonSSMManagedInstanceCore managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach the AmazonS3ReadOnlyAccess managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "s3_read_list_instance_core_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}