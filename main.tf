resource "aws_vpc" "myvpc"{
  cidr_block = var.cidr_block
}

resource "aws_subnet" "mysubnet1"{
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = true
}

resource "aws_subnet" "mysubnet2"{
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet_cidr2 
  availability_zone = var.az2
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  
  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "mysg" {
  name        = "web-sg"
  vpc_id      = aws_vpc.myvpc.id
  ingress{
    description = "HTTP for vpc"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
  ingress{
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "ssh"
    cidr_block = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
  tag = {
    Name = "Web-sg"
  }
}

