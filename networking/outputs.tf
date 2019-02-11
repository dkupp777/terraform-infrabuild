#------seaware/networking/outputs.tf

output "public_subnets" {
  value = "${aws_subnet.seaware_public_subnet.*.id}"
}

output "seaware_Linux_sg" {
  value = "${aws_security_group.seaware_Linux_sg.id}"
}

output "seaware_Windows_sg" {
  value = "${aws_security_group.seaware_Windows_sg.id}"
}

output "seaware_elb_web" {
  value = "${aws_security_group.seaware_elb_web.id}"
}

output "seaware_db_sg" {
  value = "${aws_security_group.seaware_db_sg.id}"
}

output "subnet_ips" {
  value = "${aws_subnet.seaware_public_subnet.*.cidr_block}"
}

output "private_cidrs" {
  value = "${aws_subnet.seaware_private_subnet.*.cidr_block}"
}

output "private_ids" {
  value = "${aws_subnet.seaware_private_subnet.*.id}"
}

output "availability_zones" {
  value = "${aws_subnet.seaware_public_subnet.*.availability_zone}"
}

output "tg_arn" {
  value = "${aws_lb_target_group.seaware_alb_tg_0.arn}"
}
