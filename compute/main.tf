#-----seaware/compute/main.tf

data "aws_ami" "linux_server_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

data "aws_ami" "windows_server_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
}


resource "aws_key_pair" "Virgin" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "user-init" {
  count    = 2
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    firewall_subnets = "${element(var.subnet_ips, count.index)}"
  }
}

resource "aws_instance" "seaware_linux_server" {
  count         = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.linux_server_ami.id}"

  tags {
    Name = "seaware_Linux-0${count.index+1}"
  }

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.linux_security_group}"]
  subnet_id              = "${element(var.subnets, count.index)}"
  user_data              = "${data.template_file.user-init.*.rendered[count.index]}"
}

resource "aws_instance" "seaware_windows_server" {
  count         = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.windows_server_ami.id}"

  tags {
    Name = "seaware_Win-0${count.index+1}"
  }

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.windows_security_group}"]
  subnet_id              = "${element(var.subnets, count.index)}"
  user_data              = "${data.template_file.user-init.*.rendered[count.index]}"
}


resource "aws_lb_target_group_attachment" "seaware_lin_alb_target_group_attachment_0" {
  target_group_arn = "${var.tg_arn}"
   target_id = "${element(split(",", join(",", aws_instance.seaware_linux_server.*.id)), 0)}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "seaware_lin_alb_tardget_group_attachment_1" {
  target_group_arn = "${var.tg_arn}"
   target_id = "${element(split(",", join(",", aws_instance.seaware_linux_server.*.id)), 1)}"
  port             = 80
}