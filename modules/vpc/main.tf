locals {
  public = {
    eu-north-1a = "10.0.120.0/24"
    eu-north-1b = "10.0.25.0/24"
    eu-north-1c = "10.0.93.0/24"
  }
  private = {
    eu-north-1a = "10.0.10.0/24"
    eu-north-1b = "10.0.17.0/24"
    eu-north-1c = "10.0.8.0/24"
  }
  baston_public = {
    eu-north-1a = "10.0.1.0/24"
  }
  bast_pub = {
    eu-north-1b = "10.0.2.0/24"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
    
  tags = {
    Name = "${var.environment}_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true 
  for_each = local.public
  cidr_block = each.value
  availability_zone = each.key
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  map_public_ip_on_launch = false 
  for_each = local.private
  cidr_block = each.value
  availability_zone = each.key
}
resource "aws_subnet" "baston_subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  map_public_ip_on_launch = true 
  for_each = local.baston_public
  cidr_block = each.value
  availability_zone = each.key
}
resource "aws_subnet" "bast_subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  map_public_ip_on_launch = true 
  for_each = local.bast_pub
  cidr_block = each.value
  availability_zone = each.key
}
#===============
#public 
#=============
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.environment}_internet"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.environment}_RT_internet"
  }
}
resource "aws_route" "route" {
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.route_table.id
    
}
resource "aws_route_table_association" "associate" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.route_table.id
}

#==============
#NAT gateway for private subnet 
#==============
resource "aws_route_table" "nat_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.environment}_nat_gateway_RT"
  }
}
resource "aws_eip" "ip" {
  domain = "standard"
  tags = {
    Name = "${var.environment}_elastic_ip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ip.id
  subnet_id = aws_subnet.bast_subnet["eu-north-1b"].id
  
  tags = {
    Name = "${var.environment}_nat_gateway"
  }
}
resource "aws_route" "nat_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.nat_table.id
  nat_gateway_id = aws_nat_gateway.nat.id
  
}
resource "aws_route_table_association" "associate_private" {
  for_each = aws_subnet.private_subnet 
  subnet_id = each.value.id
  route_table_id = aws_route_table.nat_table.id
}
#======= 
#baston attachment  
#==========
resource "aws_route_table_association" "baston_ass" {
  route_table_id = aws_route_table.route_table .id
  for_each = aws_subnet.baston_subnet
  subnet_id = each.value.id 
}
#=====
#bast_subnet attact 
#=========
resource "aws_route_table_association" "bast_ass" {
  route_table_id = aws_route_table.route_table .id
  for_each = aws_subnet.bast_subnet
  subnet_id = each.value.id 
}
