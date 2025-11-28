resource "aws_instance" "baston" {
  ami = "ami-0c7d68785ec07306c"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.baston_sg.id]
  key_name = "actionkey"
  subnet_id = var.bast_subnet
  tags = {
    Name = "${var.environment}- baston"
  }
  user_data = base64decode(templatefile("${path.module}/userdata.sh", {name=var.environment}))
}
#========= 
#baston security group 
#==========

resource "aws_security_group" "baston_sg" {
  vpc_id = var.baston_vpc
  tags = {
    Name = "${var.environment}_baston_sg"
  }
  ingress {
    from_port = 22 
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
