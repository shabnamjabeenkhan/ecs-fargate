
variable "app_port" {
  type = number
  default = 8080
}

variable "alb_port" {
type = number
default = 443
}

variable "desired_count" {
  type    = number
  default = 0
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}