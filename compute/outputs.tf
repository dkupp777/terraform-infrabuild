#-----compute/outputs.tf
output "windows_server_id" {
  value = "${join(", ", aws_instance.seaware_windows_server.*.id)}"
}

output "linux_server_id" {
  value = "${join(", ", aws_instance.seaware_linux_server.*.id)}"
}

output "windows_server_ip" {
  value = "${join(", ", aws_instance.seaware_windows_server.*.public_ip)}"
}

output "linux_server_ip" {
  value = "${join(", ", aws_instance.seaware_linux_server.*.public_ip)}"
}

