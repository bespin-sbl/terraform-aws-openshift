//  Console domain.
data "null_data_source" "domain" {
  inputs = {
    dom = "${var.base_domain}"
    xip = "${var.master_eip == "" ? aws_eip.master.public_ip : data.aws_eip.master.public_ip}.xip.io"
  }
}

//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.cwd}/inventories/inventory.template.cfg")}"
  vars {
    access_key = "${aws_iam_access_key.openshift-aws-user.id}"
    secret_key = "${aws_iam_access_key.openshift-aws-user.secret}"
    public_hostname = "console.${var.base_domain != "" ? data.null_data_source.domain.outputs["dom"] : data.null_data_source.domain.outputs["xip"]}"
    default_subdomain = "apps.${var.base_domain != "" ? data.null_data_source.domain.outputs["dom"] : data.null_data_source.domain.outputs["xip"]}"
    master_inventory = "${aws_instance.master.private_dns}"
    master_hostname = "${aws_instance.master.private_dns}"
    node1_hostname = "${aws_instance.node1.private_dns}"
    node2_hostname = "${aws_instance.node2.private_dns}"
    cluster_id = "${var.cluster_id}"
  }
}

//  Create the inventory.
resource "local_file" "inventory" {
  content = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
