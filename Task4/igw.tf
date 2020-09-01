resource "aws_internet_gateway" "Int_GateWay" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Environment = var.env_tags
    Name        = "Task4_IGW"
  }
}


resource "aws_route_table" "pub_route1" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Int_GateWay.id
  }

  tags = {
    Environment = var.env_tags
    Name        = "Task4_vpc_RT_IGW"
  }
}


resource "aws_route_table_association" "pubsub_rt_association1" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.pub_route1.id
}