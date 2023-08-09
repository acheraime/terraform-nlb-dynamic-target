resource "aws_security_group" "example" {
  name        = "postgres-example"
  description = "Allow Postgres inbound traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "Postgres port 5432 from VPC"
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.example.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow Ingress Postgres"
  }
}