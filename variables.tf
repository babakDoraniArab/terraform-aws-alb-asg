#////////////////////////////////
#  Variables
#////////////////////////////////
variable "web_image_id" {
  type = string
}
variable "web_app" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}
variable "web_desired_capacity" {
  type = number
}
variable "web_key_name" {
  type = string
}
variable "aws_vpc_id" {
  type = string
}
variable "subnets" {
  type = list(string)
  #like this [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}
variable "lb_security_groups" {
  description = "this security groups will assign to loadbalancer "
  type = list(string)
  #like this  [aws_security_group.prod_web2.id]
}
variable "templates_security_groups" {
    description = "this security groups will assign to instances in launch configuration template "
  type = list(string)
  #like this  [aws_security_group.prod_web2.id]
}
