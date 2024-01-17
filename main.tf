provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "test-vpc" {
  cidr_block         = "10.1.0.0/16"
  enable_dns_support = "true"
  tags = {
    Name        = var.aws_vpc
    Owner       = "SAI"
    Environment = "DEV"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = var.aws_subnet
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test-vpc.id
}

resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow All Inbound Traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test-ec2" {
  ami                         = "ami-018ba43095ff50d08"
  availability_zone           = "us-east-2a"
  instance_type               = "t2.micro"
  key_name                    = "TSI"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = "true"
  tags = {
    Name         = var.aws_instance
    Environment  = "DEV"
    Date_Created = "12-12-2023"
  }
}

output "vpc_id" {
  value = aws_vpc.test-vpc.id
}


