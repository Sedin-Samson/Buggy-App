resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.buggy-app-vpc.id

  tags = {
    Name = "samson-ig-buggyapp"
  }
}