provider "aws" {
  region     = var.Region
  access_key = var.AWS_Access_Key
  secret_key = var.AWS_Secret
}

resource "tls_private_key" "new_key_pair" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "new_key_pair" {
  key_name   = "${var.Project_Name}_key"
  public_key = tls_private_key.new_key_pair.public_key_openssh
}

resource "null_resource" "remote_system" {
  depends_on = [aws_volume_attachment.new_attachment]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.new_key_pair.private_key_pem
    host        = aws_instance.new_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdc",
      "sudo mount /dev/xvdc /var/www/html/",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/Divyajeet-Singh/sample.git /var/www/html/",
      "sudo su <<END",
      "echo \"<img src='http://${aws_cloudfront_distribution.s3_distribution.domain_name}/my_image.jpg' height='200' width='200'>\" >> /var/www/html/index.html",
      "systemctl restart httpd",
      "END",
      "exit"
    ]
  }
}


resource "null_resource" "local_system_2" {
  depends_on = [null_resource.remote_system]
  # Opens the webpage from the created Infrastructure
  provisioner "local-exec" {
    command = "chrome http://${aws_instance.new_instance.public_ip}"
  }
}

output "Private_Key" {
  value = tls_private_key.new_key_pair.private_key_pem
}

output "Public_Key" {
  value = tls_private_key.new_key_pair.public_key_openssh
}

output "EC2_Instance_Public_IP" {
  value = aws_instance.new_instance.public_ip
}

output "cloud_front_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

/*
output "EIP_Public_IP" {
  value = aws_eip.new_eip.public_ip
}
*/