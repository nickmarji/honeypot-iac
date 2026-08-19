resource "aws_vpc" "honeypot" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.honeypot.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-subnet-public1-${var.availability_zone}"
  }
}

resource "aws_internet_gateway" "honeypot" {
  vpc_id = aws_vpc.honeypot.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.honeypot.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.honeypot.id
  }

  tags = {
    Name = "${var.project_name}-rtb-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "honeypot" {
  name        = var.security_group_name
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
    description = "admin access"
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "honeypot" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.honeypot.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-server"
  }
}
