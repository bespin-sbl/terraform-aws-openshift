resource "aws_efs_file_system" "storage" {
  creation_token = "openshift-cluster"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} EFS"
    )
  )}"
}
