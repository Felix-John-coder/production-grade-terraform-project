variable "name" {
  type = string
}
variable "instance_type" {
  type = list(string)
}
variable "image_id" {
  type = string
}
variable "key_name" {
  type = string
}
variable "ASG_instance_profile_name" {
  type = string
}

variable "min" {
  type = string
}
variable "max" {
  type = string
}
variable "desire" {
  type = string
}
variable "the_subnet" {
  type = list(string)
}
variable "asg_target_arn" {
  type = string
}
variable "environment" {
  type = string
}
variable "vpc" {
  type = string
}
variable "alb_enter" {
  type = string
}
variable "baston_login" {
  type = list(string)
}