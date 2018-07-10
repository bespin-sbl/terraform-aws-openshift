output "efs-id" {
  value = "${aws_efs_file_system.storage.id}"
}

output "efs-dns_name" {
  value = "${aws_efs_file_system.storage.dns_name}"
}
