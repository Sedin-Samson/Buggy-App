resource "aws_route_table" "public" {
  vpc_id = aws_vpc.buggy-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Samson-Public-RT-Buggyapp"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.buggy-app-vpc.id
  tags = {
    Name = "Samson-Private-RT-Buggyapp"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
