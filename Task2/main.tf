provider "aws" {
  region     = var.Region
  access_key = var.AWS_Access_Key
  secret_key = var.AWS_Secret
}

data "aws_vpc" "selected_vpc" {
  id = var.VPC_ID
}

data "aws_subnet_ids" "default_vpc_subnet_id" {
  vpc_id = var.VPC_ID
}

data "aws_subnet" "default_vpc_subnet" {
  for_each = data.aws_subnet_ids.default_vpc_subnet_id.ids
  id       = each.value
}

resource "null_resource" "local_system" {
  depends_on = [aws_instance.new_instance]
  # Opens the webpage from the created Infrastructure
  provisioner "local-exec" {
    command = "chrome http://${aws_instance.new_instance.public_ip}"
  }
}

output "EC2_Instance_Public_IP" {
  value = aws_instance.new_instance.public_ip
}

output "subnets" {
  value = [for s in data.aws_subnet.default_vpc_subnet : s.id]
}

/*
output "cloud_front_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "EIP_Public_IP" {
  value = aws_eip.new_eip.public_ip
}
*/