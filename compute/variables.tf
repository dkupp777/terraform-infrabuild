#-----seaware/compute/variables.tf
variable "subnet_ips" {
  type = "list"
}

variable "key_name" {}

variable "public_key_path" {}

variable "instance_count" {}

variable "instance_type" {}

variable "linux_security_group" {}

variable "windows_security_group" {}

variable "subnets" {
  type = "list"
}

variable "availability_zones" {
  type= "list"
}
variable "elb_security_group" {}

variable "tg_arn" {}


