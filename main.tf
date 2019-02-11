#------seaware/main.tf

provider "aws" {
  region = "${var.aws_region}"
}

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  private_cidrs = "${var.private_cidrs}"
  accessip     = "${var.accessip}"
  salesforce_cidrs = "${var.salesforce_cidrs}"
  icmp_cidrs = "${var.icmp_cidrs}"
  rdp_cidrs = "${var.rdp_cidrs}"
  udp_cidrs = "${var.udp_cidrs}"
  ssh_cidrs = "${var.ssh_cidrs}"
  custom1_cidrs = "${var.custom1_cidrs}"
  custom2_cidrs = "${var.custom2_cidrs}"
  linux_server_ids = "${module.compute.linux_server_id}"
}

#Deploy Compute Resources

module "compute" {
  source          = "./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  subnets         = "${module.networking.public_subnets}"
  linux_security_group  = "${module.networking.seaware_Linux_sg}"
  windows_security_group = "${module.networking.seaware_Windows_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
  availability_zones = "${module.networking.availability_zones}"
  elb_security_group = "${module.networking.seaware_elb_web}"
  tg_arn = "${module.networking.tg_arn}"
}

module "rds" {
  source            = "./rds"
  db_engine         = "${var.db_engine}"
  rds_db_engine_version = "${var.rds_db_engine_version}"
  rds_instance_type = "${var.rds_instance_type}"
  rds_license_model = "${var.rds_license_model}"
  rds_db_name       = "${var.rds_db_name}"
  rds_subnet_ids    = ["${module.networking.private_ids}"]
  rds_db_sg         = "${module.networking.seaware_db_sg}"
}
