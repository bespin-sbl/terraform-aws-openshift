output "efs-id" {
  value = "${aws_efs_file_system.storage.id}"
}

output "efs-kms_key_id" {
  value = "${aws_efs_file_system.storage.kms_key_id}"
}

output "efs-dns_name" {
  value = "${aws_efs_file_system.storage.dns_name}"
}
