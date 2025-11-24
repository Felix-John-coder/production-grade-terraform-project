variable "name" {
  type = string 
}
variable "bucket_name" {
   type = string
}
variable "alb_path_health_check" {
  type = string
}
variable "alb_sg_vpc" {
  type = string
}
variable "alb_subnet" {
  type = list(string)
}
variable "alb_vpc" {
  type = string
}
variable "environment" {
  type = string
}