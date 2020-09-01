provider "aws" {
  region     = var.Region
  access_key = var.AWS_Access_Key
  secret_key = var.AWS_Secret
}

variable "Region" {
  default = "ap-south-1"
}
variable "my_az" {
  default = "ap-south-1a"
}
variable "instance_size" {
  default = "t2.micro"
}
variable "key_pair" {
  default = "Div-SSH"
}
variable "WP_image" {
  type    = string
  default = "ami-000cbce3e1b899ebd"
}
variable "MySQL_image" {
  type    = string
  default = "ami-08706cb5f68222d09"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet1_cidr" {
  default = "10.0.1.0/24"
}
variable "private_subnet1_cidr" {
  default = "10.0.2.0/24"
}
variable "env_tags" {
  default = "Task-3"
}