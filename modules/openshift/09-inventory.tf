//  Console domain.
data "null_data_source" "console" {
  inputs = {
    dom = "console.${var.base_domain}"
    xip = "console.${aws_instance.master.public_ip}.xip.io"
  }
}

//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory-dom" {
  count = "${var.base_domain != "" ? 1 : 0}"
  template = "${file("${path.cwd}/inventories/inventory.template.cfg")}"
  vars {
    access_key = "${aws_iam_access_key.openshift-aws-user.id}"
    secret_key = "${aws_iam_access_key.openshift-aws-user.secret}"
    public_hostname = "console.${var.base_domain}"
    default_subdomain = "apps.${var.base_domain}"
    master_inventory = "${aws_instance.master.private_dns}"
    master_hostname = "${aws_instance.master.private_dns}"
    node1_hostname = "${aws_instance.node1.private_dns}"
    node2_hostname = "${aws_instance.node2.private_dns}"
    cluster_id = "${var.cluster_id}"
  }
}
data "template_file" "inventory-xip" {
  count = "${var.base_domain == "" ? 1 : 0}"
  template = "${file("${path.cwd}/inventories/inventory.template.cfg")}"
  vars {
    access_key = "${aws_iam_access_key.openshift-aws-user.id}"
    secret_key = "${aws_iam_access_key.openshift-aws-user.secret}"
    public_hostname = "console.${aws_instance.master.public_ip}.xip.io"
    default_subdomain = "apps.${aws_instance.master.public_ip}.xip.io"
    master_inventory = "${aws_instance.master.private_dns}"
    master_hostname = "${aws_instance.master.private_dns}"
    node1_hostname = "${aws_instance.node1.private_dns}"
    node2_hostname = "${aws_instance.node2.private_dns}"
    cluster_id = "${var.cluster_id}"
  }
}

//  Create the inventory.
resource "local_file" "inventory-dom" {
  count = "${var.base_domain != "" ? 1 : 0}"
  content = "${data.template_file.inventory-dom.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
resource "local_file" "inventory-xip" {
  count = "${var.base_domain == "" ? 1 : 0}"
  content = "${data.template_file.inventory-xip.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
