//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.cwd}/templates/inventory-efs.template.cfg")}"

  vars {
    region     = "${var.region}"
    cluster_id = "${var.cluster_id}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    efs_fsid   = "${aws_efs_file_system.storage.id}"
  }
}

//  Create the inventory.
resource "local_file" "inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory-efs.cfg"
}
