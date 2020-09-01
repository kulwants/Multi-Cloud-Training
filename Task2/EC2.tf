resource "aws_instance" "new_instance" {
  depends_on             = [aws_cloudfront_distribution.s3_distribution]
  ami                    = var.AMI
  instance_type          = var.Instance_Type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.new_sg.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Divyajeet Singh/Desktop/AWS/Div-SSH.pem")
    host        = aws_instance.new_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo su <<END",
      "sudo yum update -y",
      "sudo yum install httpd git amazon-efs-utils nfs-utils -y",
      "sudo rm -rf /var/www/html/*",
      "sudo mount -t efs -o tls ${aws_efs_file_system.new_efs.id}:/ /var/www/html",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable mount-nfs-sequentially.service",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/Divyajeet-Singh/sample.git /var/www/html/",
      "echo \"<img src='http://${aws_cloudfront_distribution.s3_distribution.domain_name}/my_image.jpg' height='200' width='200'>\" >> /var/www/html/index.html",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "END",
      "exit"
    ]
  }

  tags = {
    Project = var.Project_Name
    Name    = "${var.Project_Name}_instance"
  }
}