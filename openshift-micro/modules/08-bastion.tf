//  Create the bastion userdata script.
data "template_file" "setup-bastion" {
  template = "${file("${path.module}/files/setup-bastion.sh")}"
}

//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "bastion" {
  ami                  = "${data.aws_ami.amazonlinux.id}"
  instance_type        = "t2.micro"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion-instance-profile.id}"
  user_data            = "${data.template_file.setup-bastion.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Bastion"
    )
  )}"
}
