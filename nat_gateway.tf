# Create NAT Gateway for the VPC

## Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-gateway-eip"
  }
}

## NAT Gateway using the allocated EIP
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "main-nat-gateway"
  }
}