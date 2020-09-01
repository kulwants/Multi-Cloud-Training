resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.env_tags
    Name        = "Task4_vpc"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet1_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.my_az
  tags = {
    Environment = var.env_tags
    Name        = "Wordpress_Subnet"
  }
}


resource "aws_subnet" "pvt_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet1_cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.my_az
  tags = {
    Environment = var.env_tags
    Name        = "Mysql_Subnet"
  }
}