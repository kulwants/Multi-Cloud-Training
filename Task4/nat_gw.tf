resource "aws_eip" "my_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.Int_GateWay]
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.pub_subnet.id

  tags = {
    Name = "Task4_NAT"
  }
}

resource "aws_route_table" "pvt_route1" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Environment = var.env_tags
    Name        = "Task4_vpc_RT_NAT"
  }
}


resource "aws_route_table_association" "pubsub_rt_association2" {
  subnet_id      = aws_subnet.pvt_subnet.id
  route_table_id = aws_route_table.pvt_route1.id
}