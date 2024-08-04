# db_subnet_group.tf
resource "aws_db_subnet_group" "default" {
  name       = "default-db-subnet-group"
  subnet_ids = [aws_subnet.ministore-subnet-1.id, aws_subnet.ministore-subnet-2.id]

  tags = {
    Name = "default-db-subnet-group"
  }
}