//  Output some useful variables for quick SSH access etc.
output "console-public" {
  value = "console.${var.base_domain != "" ? data.null_data_source.domain.outputs["dom"] : data.null_data_source.domain.outputs["xip"]}"
}

output "master1-public_dns" {
  value = "${aws_instance.master1.public_dns}"
}

output "master1-public_ip" {
  value = "${aws_instance.master1.public_ip}"
}

output "master1-private_dns" {
  value = "${aws_instance.master1.private_dns}"
}

output "master1-private_ip" {
  value = "${aws_instance.master1.private_ip}"
}

output "master2-public_dns" {
  value = "${aws_instance.master2.public_dns}"
}

output "master2-public_ip" {
  value = "${aws_instance.master2.public_ip}"
}

output "master2-private_dns" {
  value = "${aws_instance.master2.private_dns}"
}

output "master2-private_ip" {
  value = "${aws_instance.master2.private_ip}"
}

output "master3-public_dns" {
  value = "${aws_instance.master3.public_dns}"
}

output "master3-public_ip" {
  value = "${aws_instance.master3.public_ip}"
}

output "master3-private_dns" {
  value = "${aws_instance.master3.private_dns}"
}

output "master3-private_ip" {
  value = "${aws_instance.master3.private_ip}"
}

output "node1-public_dns" {
  value = "${aws_instance.node1.public_dns}"
}

output "node1-public_ip" {
  value = "${aws_instance.node1.public_ip}"
}

output "node1-private_dns" {
  value = "${aws_instance.node1.private_dns}"
}

output "node1-private_ip" {
  value = "${aws_instance.node1.private_ip}"
}

output "node2-public_dns" {
  value = "${aws_instance.node2.public_dns}"
}

output "node2-public_ip" {
  value = "${aws_instance.node2.public_ip}"
}

output "node2-private_dns" {
  value = "${aws_instance.node2.private_dns}"
}

output "node2-private_ip" {
  value = "${aws_instance.node2.private_ip}"
}

output "infra1-public_dns" {
  value = "${aws_instance.infra1.public_dns}"
}

output "infra1-public_ip" {
  value = "${aws_instance.infra1.public_ip}"
}

output "infra1-private_dns" {
  value = "${aws_instance.infra1.private_dns}"
}

output "infra1-private_ip" {
  value = "${aws_instance.infra1.private_ip}"
}

output "infra2-public_dns" {
  value = "${aws_instance.infra2.public_dns}"
}

output "infra2-public_ip" {
  value = "${aws_instance.infra2.public_ip}"
}

output "infra2-private_dns" {
  value = "${aws_instance.infra2.private_dns}"
}

output "infra2-private_ip" {
  value = "${aws_instance.infra2.private_ip}"
}

output "bastion-public_dns" {
  value = "${aws_instance.bastion.public_dns}"
}

output "bastion-public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "bastion-private_dns" {
  value = "${aws_instance.bastion.private_dns}"
}

output "bastion-private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}

output "efs-id" {
  value = "${aws_efs_file_system.storage.id}"
}

output "efs-kms_key_id" {
  value = "${aws_efs_file_system.storage.kms_key_id}"
}

output "efs-dns_name" {
  value = "${aws_efs_file_system.storage.dns_name}"
}
