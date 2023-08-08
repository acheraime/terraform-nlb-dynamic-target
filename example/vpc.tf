# Create a test VPC
resource "aws_vpc" "example" {
    cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "a" {
    vpc_id = aws_vpc.example.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "us-east-1d"

    tags = {
        Name = "Subnet-A"
    }
}

resource "aws_subnet" "b" {
    vpc_id = aws_vpc.example.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "us-east-1b"
    
    tags = {
        Name = "Subnet-B"
    }
}

resource "aws_db_subnet_group" "example" {
    name = "example"
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

    tags = {
        Name = "EXample DB subnet group"
    }
}
