resource "aws_security_group" "public" {
  name        = "${var.name}-public-ec2-sg"
  description = "Allow SSH access from the admin CIDR to the public EC2 instance."
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from the admin CIDR."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-ec2-sg"
    Tier = "public"
  })
}

resource "aws_security_group" "private" {
  name        = "${var.name}-private-ec2-sg"
  description = "Allow SSH access from the public EC2 security group to the private EC2 instance."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow SSH from the public EC2 security group."
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private-ec2-sg"
    Tier = "private"
  })
}
