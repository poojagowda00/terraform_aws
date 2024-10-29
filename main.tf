provider "aws" {
  region = "us-east-1"
}




resource "aws_vpc" "vpc-terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-terraform"
  }
}




resource "aws_internet_gateway" "vpc-gw" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = {
    Name = "vpc-gw"
  }
}




resource "aws_subnet" "vpc-subnets" {
  vpc_id     = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "vpc-subnets"
  }
}


resource "aws_route_table" "Public-route-table-vpc" {
  vpc_id = aws_vpc.vpc-terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-gw.id
  }


  tags = {
    Name    = "Public-route-table-vpc"
    Service = "Teffarom"
  }
}

resource "aws_route_table_association" "RTA-terra" {
  subnet_id      = aws_subnet.vpc-subnets.id
  route_table_id = aws_route_table.Public-route-table-vpc.id
}



resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-terraform.id


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
  tags = {
    Name = "allow_tls"
  }
}

