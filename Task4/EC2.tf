resource "aws_instance" "WP_instance1" {
  depends_on             = [aws_internet_gateway.Int_GateWay]
  ami                    = var.WP_image
  instance_type          = var.instance_size
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
  key_name               = var.key_pair

  tags = {
    Environment = var.env_tags
    Name        = "Wordpress_instance"
  }

}

resource "aws_instance" "MYSQL_instance1" {
  depends_on             = [aws_nat_gateway.nat_gw]
  ami                    = var.MySQL_image
  instance_type          = var.instance_size
  subnet_id              = aws_subnet.pvt_subnet.id
  vpc_security_group_ids = [aws_security_group.mysql_sq.id]
  key_name               = var.key_pair
  tags = {
    Environment = var.env_tags
    Name        = "MySql_instance"
  }
}
