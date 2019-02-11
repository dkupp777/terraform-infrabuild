#---seaware/networking/main.tf

data "aws_availability_zones" "available" {}

resource "aws_vpc" "seaware_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "seaware_vpc"
  }
}

resource "aws_internet_gateway" "seaware_internet_gateway" {
  vpc_id = "${aws_vpc.seaware_vpc.id}"

  tags {
    Name = "seaware_igw"
  }
}

resource "aws_route_table" "seaware_public_rt" {
  vpc_id = "${aws_vpc.seaware_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.seaware_internet_gateway.id}"
  }

  tags {
    Name = "seaware_public"
  }
}

resource "aws_default_route_table" "seaware_private_rt" {
  default_route_table_id = "{aws_vpc.seaware_vpc.default_route_table_id}"

  tags {
    Name = "seaware_private"
  }
}

resource "aws_subnet" "seaware_public_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.seaware_vpc.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "seaware_public_${count.index + 1}"
  }
}

resource "aws_subnet" "seaware_private_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.seaware_vpc.id}"
  cidr_block              = "${var.private_cidrs[count.index]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "seaware_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "seaware_public_assoc" {
  count          = "${aws_subnet.seaware_public_subnet.count}"
  subnet_id      = "${aws_subnet.seaware_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.seaware_public_rt.id}"
}

resource "aws_security_group" "seaware_public_sg" {
  name        = "seaware_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.seaware_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "seaware_Windows_sg" {
  name        = "seaware_Windows_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.seaware_vpc.id}"

  #All ports

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  #10050-10052

  ingress {
    from_port   = 10050
    to_port     = 10052
    protocol    = "tcp"
    cidr_blocks = ["${var.custom1_cidrs}"]
  }
  
  #UDP

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  #10250
  
   ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["${var.custom2_cidrs}"]
  }
  
  #RDP
  
   ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.rdp_cidrs}"]
  }
  
  #Salesforce
  
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.salesforce_cidrs}"]
  }
  
  #ICMP
  
   ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}","${var.icmp_cidrs}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "seaware_Linux_sg" {
  name        = "seaware_Linux_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.seaware_vpc.id}"


  #All ports

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  #UDP

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}","${var.udp_cidrs}"]
  }
  
  #10050-10052
  
  ingress {
    from_port   = 10050
    to_port     = 10052
    protocol    = "tcp"
    cidr_blocks = ["${var.custom1_cidrs}"]
  }
  
  #SSH
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}","${var.ssh_cidrs}"]
  }
 
  #MySQL
 
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
    #ICMP
  
    ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}","${var.icmp_cidrs}"]
  }
  
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["${var.custom2_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "seaware_elb_web" {
  name        = "seaware_elb_web"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.seaware_vpc.id}"

  #Web ports

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.accessip}"]
  }
}

resource "aws_security_group" "seaware_db_sg" {
  name        = "seaware_db_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.seaware_vpc.id}"

  #Web ports

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
   ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.accessip}"]
  }
}

resource "aws_lb" "seaware_alb" {  
  name            = "seaware-alb" 
  load_balancer_type = "application"
  subnets         = ["${aws_subnet.seaware_public_subnet.*.id}"]
  security_groups = ["${aws_security_group.seaware_elb_web.id}"]
  internal        = false 
  idle_timeout    = 60   
  tags {    
    Name    = "alb"    
  }   
}



resource "aws_lb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_lb.seaware_alb.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.seaware_alb_tg_0.arn}"
    type             = "forward"  
  }
}

resource "aws_lb_target_group" "seaware_alb_tg_0" {
  name     = "seaware-alb-tg-0"
  port     = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.seaware_vpc.id}"
}



