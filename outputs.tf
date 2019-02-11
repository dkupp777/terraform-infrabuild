#-----root/outputs.tf

#-----Storage Outputs

#output "Bucket Name" {
#  value = "${module.storage.bucketname}"
#}

#-----Networking outputs

output "Public Subnet IDs" {
  value = "${join(", ", module.networking.public_subnets)}"
}

output "Private Subnet IDs" {
  value = "${join(", ", module.networking.private_ids)}"
}

output "Public CIDRs" {
  value = "${join(", ", module.networking.subnet_ips)}"
}

output "Private CIDRs" {
  value = "${join(", ", module.networking.private_cidrs)}"
}

output "Linux Security Group" {
  value = "${module.networking.seaware_Linux_sg}"
}

output "Windows Security Group" {
  value = "${module.networking.seaware_Windows_sg}"
}

#-----Compute Outputs-------

output "Windows Instance IDs" {
  value = "${module.compute.windows_server_id}"
}

output "Linux Instance IDs" {
  value = "${module.compute.linux_server_id}"
}

output "Windows Instance IPs" {
  value = "${module.compute.windows_server_ip}"
}

output "Linux Instance IPs" {
  value = "${module.compute.linux_server_ip}"
}

#-------RDS Outputs--------

output "project RDS Endpoint" {
  value = "${module.rds.seaware_rds_endpoint}"
}