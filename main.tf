provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWLPASSW2ZK5PBUVF"
  secret_key = "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"
}

resource "aws_vpc" "demo" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "demo"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "netgw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "netgw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.demo.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.netgw.id
  }
  tags = {
    Name = "igt"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "demosg" {
  name        = "demosg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "host" {
  ami                       = "ami-02eb7a4783e7e9317"
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [aws_security_group.demosg.id]
  subnet_id                 = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                  = "Ankit"
}
