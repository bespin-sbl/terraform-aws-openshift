resource "aws_efs_file_system" "storage" {
  creation_token = "openshift-cluster"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} EFS"
    )
  )}"
}

resource "aws_efs_mount_target" "targets" {
  count          = "${length(aws_subnet_ids.public.ids)}"
  file_system_id = "${aws_efs_file_system.storage.id}"
  subnet_id      = "${aws_subnet_ids.public.ids[count.index]}"
}
