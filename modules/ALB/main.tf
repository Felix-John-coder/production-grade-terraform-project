resource "aws_lb" "ALB" {
  name = "${var.name}-ALb"
  internal = false #internet false now 
  idle_timeout = 60 
  load_balancer_type = "application"
  subnets = var.alb_subnet 
  security_groups = [ aws_security_group.alb_sg.id ]
  access_logs {
    bucket = var.bucket_name 
    prefix = "ALB${var.name}"
  }

  tags = {
    Name = "${var.environment}_alb"
  }
}
resource "aws_lb_target_group" "TG" {
  name = "my-target-group"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.alb_vpc
  
  health_check {
    interval = 30 
    timeout = 5 
    protocol = "HTTP"
    unhealthy_threshold = 5 
    healthy_threshold = 2 
    path = var.alb_path_health_check
  }
  tags = {
    Name = "${var.environment}_TG"
  }
}

resource "aws_lb_listener" "listner" {
  port = 80 
  protocol = "HTTP"
  load_balancer_arn = aws_lb.ALB.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
  tags = {
    Name = "${var.environment}_listner"
  }
}#creating load balancer sg 

resource "aws_security_group" "alb_sg" {
  vpc_id = var.alb_sg_vpc 
  
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
