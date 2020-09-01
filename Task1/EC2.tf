resource "aws_instance" "new_instance" {
  depends_on             = [aws_cloudfront_distribution.s3_distribution]
  ami                    = var.AMI
  instance_type          = var.Instance_Type
  key_name               = aws_key_pair.new_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.new_sg.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.new_key_pair.private_key_pem
    host        = aws_instance.new_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd git -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/*",
      "exit"
    ]
  }

  tags = {
    Project = var.Project_Name
    Name    = "${var.Project_Name}_instance"
  }
}