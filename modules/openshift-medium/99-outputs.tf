//  Output some useful variables for quick SSH access etc.
output "public_console" {
  value = "console.${var.base_domain != "" ? data.null_data_source.domain.outputs["dom"] : data.null_data_source.domain.outputs["xip"]}"
}

output "master-public_dns" {
  value = "${aws_instance.master.public_dns}"
}

output "master-public_ip" {
  value = "${aws_eip.master.public_ip}"
}

output "master-private_dns" {
  value = "${aws_instance.master.private_dns}"
}

output "master-private_ip" {
  value = "${aws_instance.master.private_ip}"
}

output "node1-public_dns" {
  value = "${aws_instance.node1.public_dns}"
}

output "node1-public_ip" {
  value = "${aws_eip.node1.public_ip}"
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
  value = "${aws_eip.node2.public_ip}"
}

output "node2-private_dns" {
  value = "${aws_instance.node2.private_dns}"
}

output "node2-private_ip" {
  value = "${aws_instance.node3.private_ip}"
}

output "node3-public_dns" {
  value = "${aws_instance.node3.public_dns}"
}

output "node3-public_ip" {
  value = "${aws_eip.node3.public_ip}"
}

output "node3-private_dns" {
  value = "${aws_instance.node3.private_dns}"
}

output "node3-private_ip" {
  value = "${aws_instance.node3.private_ip}"
}

output "etcd1-public_dns" {
  value = "${aws_instance.etcd1.public_dns}"
}

output "etcd1-public_ip" {
  value = "${aws_instance.etcd1.public_ip}"
}

output "etcd1-private_dns" {
  value = "${aws_instance.etcd1.private_dns}"
}

output "etcd1-private_ip" {
  value = "${aws_instance.etcd1.private_ip}"
}

output "etcd2-public_dns" {
  value = "${aws_instance.etcd2.public_dns}"
}

output "etcd2-public_ip" {
  value = "${aws_instance.etcd2.public_ip}"
}

output "etcd2-private_dns" {
  value = "${aws_instance.etcd2.private_dns}"
}

output "etcd2-private_ip" {
  value = "${aws_instance.etcd3.private_ip}"
}

output "etcd3-public_dns" {
  value = "${aws_instance.etcd3.public_dns}"
}

output "etcd3-public_ip" {
  value = "${aws_instance.etcd3.public_ip}"
}

output "etcd3-private_dns" {
  value = "${aws_instance.etcd3.private_dns}"
}

output "etcd3-private_ip" {
  value = "${aws_instance.etcd3.private_ip}"
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
