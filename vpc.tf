resource "aws_vpc" "Name" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "tarraform-vpc"
  }
}
resource "aws_subnet" "private1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.Name.id
  tags = {
    "Name" = "private-subnet1"
  }
}
resource "aws_subnet" "private2" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.Name.id
  tags = {
    "Name" = "private-subnet2"
  }
}
resource "aws_subnet" "public1" {
  cidr_block = "10.0.10.0/24"
  vpc_id     = aws_vpc.Name.id
  tags = {
    "Name" = "public-subnet1"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Name.id
  tags = {
    "Name" = "internet-gateway"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "public-route"
  }
}
resource "aws_eip" "eip" {
#  count = length(aws_subnet.public1)
  tags = {
    "Name" = "elastic-ip"
  }
}
resource "aws_nat_gateway" "natgw" {
 # count             = length(aws_subnet.public1)
  connectivity_type = "public"
  subnet_id         = aws_subnet.public1.id
  allocation_id     = aws_eip.eip.id
  tags = {
    "Name" = "nat_gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.Name.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}
resource "aws_main_route_table_association" "mainrt" {
  vpc_id         = aws_vpc.Name.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "rtassoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "prirtassoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "prirtassoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private-rt.id
}
