provider "aws" {
  region  = "ap-south-1"
  profile = "Learning"
}

# SECURITY GROUP
resource "aws_security_group" "tfsecuritygroup1" {
  name   = "tfSecurityGroup1"
  vpc_id = "vpc-0f938e67"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "tfSecurityGroup1"
  }
}

# INSTANCE
resource "aws_instance" "project1" {
  ami             = "ami-0447a12f28fddb066"
  instance_type   = "t2.micro"
  key_name        = "mykeyfirstos"
  security_groups = ["tfSecurityGroup1"]
  tags = {
    Name = "project1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("Z:/Study/Hybrid Multi Cloud/Practice/mykeyfirstos.pem")
    host        = "${aws_instance.project1.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd git -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/*",
    ]
  }
}



# VOLUME / EBS
resource "aws_ebs_volume" "project1ebs" {
  availability_zone = aws_instance.project1.availability_zone
  size              = 1

  tags = {
    Name = "Project1EBS"
  }
}

# VOLUME MOUNT
resource "aws_volume_attachment" "project_ebs" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.project1ebs.id}"
  instance_id = "${aws_instance.project1.id}"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("Z:/Study/Hybrid Multi Cloud/Practice/mykeyfirstos.pem")
    host        = "${aws_instance.project1.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdc",
      "sudo mount /dev/xvdc /var/www/html/",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/kulwants/Terraform-Learning.git /var/www/html/",
      "sudo systemctl restart httpd"
    ]
  }
}

output "myos_ip" {
  value = aws_instance.project1.public_ip
}

# SAVING IP ADDRESS IN TEXT FORMAT
resource "null_resource" "nullvalue" {
  provisioner "local-exec" {
    command = "echo  ${aws_instance.project1.public_ip} > mypublicip.txt"
  }
}

# BUCKET / S3
resource "aws_s3_bucket" "S3project1" {
  bucket = "my-tf-project-bucket"
  acl    = "public-read"

  tags = {
    Name = "My Project Bucket"
  }
}

# CloudFront
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.S3project1.bucket_regional_domain_name
    origin_id   = "myprojectid" 
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myprojectid" //aws_s3_bucket.s3project1.id //aws_s3_bucket.s3.S3project1.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #     locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}