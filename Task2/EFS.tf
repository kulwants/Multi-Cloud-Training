resource "aws_efs_file_system" "new_efs" {
  creation_token   = "my-new-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"


  tags = {
    Name = "${var.Project_Name}-efs"
  }
}

resource "aws_efs_mount_target" "new_efs_mount_target_1" {
  file_system_id = aws_efs_file_system.new_efs.id
  subnet_id      = var.subnet1
  security_groups = [aws_security_group.new_sg.id]
}

resource "aws_efs_mount_target" "new_efs_mount_target_2" {
  file_system_id = aws_efs_file_system.new_efs.id
  subnet_id      = var.subnet2
  security_groups = [aws_security_group.new_sg.id]
}

resource "aws_efs_mount_target" "new_efs_mount_target_3" {
  file_system_id = aws_efs_file_system.new_efs.id
  subnet_id      = var.subnet3
  security_groups = [aws_security_group.new_sg.id]
}