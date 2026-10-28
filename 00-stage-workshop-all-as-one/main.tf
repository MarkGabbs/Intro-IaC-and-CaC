provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "WEI-Workshop" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "WEI-Workshop" {
  vpc_id                  = aws_vpc.WEI-Workshop.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "WEI-Workshop" {
  vpc_id = aws_vpc.WEI-Workshop.id
}

resource "aws_route_table" "WEI-Workshop" {
  vpc_id = aws_vpc.WEI-Workshop.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WEI-Workshop.id
  }
}

resource "aws_route_table_association" "WEI-Workshop" {
  subnet_id      = aws_subnet.WEI-Workshop.id
  route_table_id = aws_route_table.WEI-Workshop.id
}

resource "aws_security_group" "WEI-Workshop" {
  vpc_id = aws_vpc.WEI-Workshop.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

resource "aws_instance" "WEI-Workshop" {
  count                  = 3
  ami                    = data.aws_ami.linux.id
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.WEI-Workshop.id
  vpc_security_group_ids = [aws_security_group.WEI-Workshop.id]
  key_name               = var.key_name
}

variable "key_name" {}
