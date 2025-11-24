
#creating ec3 
resource "aws_instance" "ec2" {
  ami = var.image 
  key_name = var.key_name
  instance_type = var.imagetype 
  iam_instance_profile = var.profile
  subnet_id = var.subnet_idec2
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  tags = {
    Name = "${var.environment}-server"
  }
}
resource "aws_security_group" "sg" {
  vpc_id = var.vpc_idec2
tags = {
    Name = "${var.environment}-sg-instance"
  }
}

resource "aws_security_group_rule" "sg_one" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.sg.id
  source_security_group_id = var.alb_the_sg_needed
}
resource "aws_security_group_rule" "sg_two" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.sg.id
  source_security_group_id = var.alb_inbound[0]
}
resource "aws_security_group_rule" "sg" {
  type = "egress"
  from_port = 0 
  to_port = 0 
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.sg.id
}