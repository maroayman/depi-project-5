# Route Table and Associations for Public and Private Subnets

## Create Route Table for Public Subnets
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

## Create Route Table for Private Subnets
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

## Update Private Route Table to route traffic through NAT Gateway
resource "aws_route" "private-rt" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

## Associate All Subnets with their respective Route Tables

resource "aws_route_table_association" "priv_subnet1_assoc" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-rt.id

}

resource "aws_route_table_association" "priv_subnet2_assoc" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-rt.id

}

resource "aws_route_table_association" "pub_subnet1_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "pub_subnet2_assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-rt.id
}