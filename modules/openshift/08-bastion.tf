//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "bastion" {
  ami                  = "${data.aws_ami.amazonlinux.id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.bastion-instance-profile.id}"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  key_name = "${aws_key_pair.openshift.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Bastion"
    )
  )}"
}
