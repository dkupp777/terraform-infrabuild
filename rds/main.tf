resource "aws_db_subnet_group" "seaware_db_subnet" {
  name       = "seaware"
  subnet_ids = ["${var.rds_subnet_ids}"]
  tags = {
    Name = "seaware rds db subnet group"
  }
}

resource "aws_db_instance" "seaware" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "${var.db_engine}"
  engine_version       = "${var.rds_db_engine_version}"
  instance_class       = "${var.rds_instance_type}"
  license_model        = "${var.rds_license_model}"
  name                 = "${var.rds_db_name}"
  identifier           = "seaware-db"
  username             = "rootuser"
  password             = "nothotdog"
  #parameter_group_name = "default.oracle"
  multi_az             = true
  db_subnet_group_name = "seaware"
  vpc_security_group_ids = ["${var.rds_db_sg}"]
  final_snapshot_identifier = "seaware-${count.index}-final"
  publicly_accessible = "false"
  
  tags = {
    Name = "seaware rds db Instance"
  }
  
}

