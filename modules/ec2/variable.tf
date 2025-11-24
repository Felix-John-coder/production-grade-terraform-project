variable "image" {
  description = "machine image"
  type = string
}
variable "imagetype" {
  description = "machine type"
  type = string
}

variable "vpc_idec2" {
  type = string
}
variable "subnet_idec2" {
  type = string
}
variable "environment" {
  type = string
}
variable "key_name" {
  type = string
}
variable "profile" {
  type = string
}
variable "alb_the_sg_needed" {
  type = string
}
variable "alb_inbound" {
  type = list(string)
}