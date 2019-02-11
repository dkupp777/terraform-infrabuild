#----networking/variables.tf

variable "aws_region" {}

#----- storage variables

#variable "project_name" {}

#----- networking variables

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

variable "icmp_cidrs"{
  type = "list"
}

variable "rdp_cidrs"{
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

#----- compute variables

variable "key_name" {}

variable "public_key_path" {}

variable "server_instance_type" {}

variable "instance_count" {
  default = 1
}

#------RDS---------
variable "db_engine" {}

variable "rds_db_engine_version" {}

variable "rds_instance_type" {}

variable "rds_license_model" {}

variable "rds_db_name" {}
