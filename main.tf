resource "aws_vpc" "honeypot" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "honeypot-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.honeypot.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "honeypot-subnet-public1-us-east-2a"
  }
}

resource "aws_internet_gateway" "honeypot" {
  vpc_id = aws_vpc.honeypot.id

  tags = {
    Name = "honeypot-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.honeypot.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.honeypot.id
  }

  tags = {
    Name = "honeypot-rtb-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "honeypot" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2026-08-10T20:04:55.052Z"
  vpc_id      = aws_vpc.honeypot.id

  ingress {
    description = "honeypot decoy"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NM admin access"
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["67.81.92.107/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "honeypot" {
  ami                    = "ami-048f644e868baa0e8"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.honeypot.id]
  key_name               = "honeypot-key"

  tags = {
    Name = "honeypot-server"
  }
}
