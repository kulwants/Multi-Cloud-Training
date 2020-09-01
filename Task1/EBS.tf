resource "aws_ebs_volume" "new_ebs" {
  depends_on        = [aws_instance.new_instance]
  availability_zone = aws_instance.new_instance.availability_zone
  size              = 1
  encrypted         = true

  tags = {
    Project = var.Project_Name
    Name    = "${var.Project_Name}_ebs"
  }
}

resource "aws_volume_attachment" "new_attachment" {
  depends_on   = [aws_ebs_volume.new_ebs]
  device_name  = "/dev/sdc"
  volume_id    = aws_ebs_volume.new_ebs.id
  instance_id  = aws_instance.new_instance.id
  force_detach = true
}