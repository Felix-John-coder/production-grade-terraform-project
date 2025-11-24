output "the_sg_alb" {
  value = aws_security_group.alb_sg.id
}
output "tg_arn" {
  value = aws_lb_target_group.TG.arn
}