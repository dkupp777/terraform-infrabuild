#------seaware/rds/variables.tf
variable "rds_subnet_ids" {
    type = "list"
}

variable "rds_db_sg" {}

variable "db_engine" {}

variable "rds_db_engine_version" {}

variable "rds_instance_type" {}

variable "rds_license_model" {}

variable "rds_db_name" {}
