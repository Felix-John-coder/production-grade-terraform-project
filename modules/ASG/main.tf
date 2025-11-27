resource "aws_launch_template" "this" {
    name_prefix = "${var.name}-template"
    instance_type = var.instance_type[0]
    image_id = var.image_id 
    key_name = var.key_name 
    vpc_security_group_ids = [aws_security_group.the_sg.id]

    iam_instance_profile {
      name = var.ASG_instance_profile_name
    }
    lifecycle {
      create_before_destroy = true
    }
    user_data = base64encode(templatefile("${path.module}/userdata.sh", {
        name = var.name
    }))
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "${var.environment}_template"
      }
    }
}
resource "aws_autoscaling_group" "auto" {
  name = var.name 
  min_size = var.min 
  max_size = var.max 
  desired_capacity = var.desire 
  vpc_zone_identifier =  var.the_subnet

  target_group_arns = [var.asg_target_arn ]
  health_check_grace_period = 120 
  health_check_type = "ELB"
  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 90 
      spot_allocation_strategy = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id  
        version = "$Latest"
      }
      override {
        instance_type = var.instance_type[0]
      }
      override {
        instance_type = var.instance_type[1]
      }
    }
  }
  lifecycle {
    ignore_changes = [ mixed_instances_policy ]
  }
  tag {
    propagate_at_launch = true 
    key = "Name"
    value = "${var.environment}_ASG_${var.name}"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup = 120 
      min_healthy_percentage = 90
    }
  }
}

resource "aws_security_group" "the_sg" {
  vpc_id = var.vpc 
  tags = {
    Name = "${var.name}_security_group_${var.environment}"
  }
}

resource "aws_security_group_rule" "sg_rule_one" {
  type = "ingress"
  from_port = 80 
  to_port = 80 
  protocol = "tcp"
  security_group_id = aws_security_group.the_sg.id
   source_security_group_id = var.alb_enter
}
resource "aws_security_group_rule" "sg_rule_two" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.the_sg.id
  source_security_group_id = var.alb_enter 
}
resource "aws_security_group_rule" "sg_rule_three" {
  type = "ingress"
  from_port = 22 
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.the_sg.id
  source_security_group_id = var.baston_login[0]
}
resource "aws_security_group_rule" "sg_rule_four" {
  type = "egress"
  from_port = 0 
  to_port = 0 
  protocol = "-1"
  security_group_id = aws_security_group.the_sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}