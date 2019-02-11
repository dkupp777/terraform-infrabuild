#---seaware/networking/variables.tf

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs" {
  type = "list"
}

variable "accessip" {}

variable "salesforce_cidrs" {
  type = "list"
}

variable "icmp_cidrs" {
  type = "list"
}

variable "rdp_cidrs" {
  type = "list"
}

variable "udp_cidrs" {
  type = "list"
}

variable "ssh_cidrs" {
  type = "list"
}

variable "custom1_cidrs" {
  type = "list"
}

variable "custom2_cidrs" {
  type = "list"
}

variable "linux_server_ids" {}
