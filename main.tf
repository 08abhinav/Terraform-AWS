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
