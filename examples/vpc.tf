# Create a test VPC
resource "aws_vpc" "example" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "Subnet-A"
  }
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-B"
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

  tags = {
    Name = "EXample DB subnet group"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "Example IGW"
  }
}

resource "aws_eip" "b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "bnat" {
  allocation_id = aws_eip.b.allocation_id
  subnet_id     = aws_subnet.b.id

  tags = {
    Name = "Nat gateway B"
  }
}

resource "aws_route_table" "rta" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bnat.id
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "arta" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.rta.id
}

resource "aws_route_table_association" "brta" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.rtb.id
}