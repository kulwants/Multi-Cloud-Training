resource "aws_security_group" "new_sg" {
  name        = "${var.Project_Name}_sg"
  description = "Managed by Terraform for Project: ${var.Project_Name}"
  vpc_id      = var.VPC_ID

  ingress {
    description = "Allow port 80 to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 22 to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.Project_Name
    Name    = "${var.Project_Name}_sg"
  }
}