output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnet" {
  value = { for k,v in aws_subnet.public_subnet : k => v.id}
}
output "private_subnet" {
  value = { for k,v in aws_subnet.private_subnet : k => v.id}
}
output "baston_subnet" {
  value = { for k,v in aws_subnet.baston_subnet : k => v.id}
}