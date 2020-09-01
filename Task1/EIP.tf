/*
resource "aws_eip" "new_eip" {
  instance   = aws_instance.new_instance.id
  vpc        = true
  depends_on = [aws_instance.new_instance]

  tags = {
    Project = var.Project_Name
    Name    = "${var.Project_Name}_eip"
  }
}

resource "aws_eip_association" "new_assoc" {
  instance_id   = "${aws_instance.new_instance.id}"
  allocation_id = "${aws_eip.new_eip.id}"
}
*/