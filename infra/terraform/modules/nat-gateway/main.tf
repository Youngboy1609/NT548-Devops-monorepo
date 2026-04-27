resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_id

  tags = merge(var.tags, {
    Name = "${var.name}-nat"
  })
}
