data "aws_vpc" "openshift" {
  id = "${var.vpc_id}"
}

//  Create a public subnet.
data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.openshift.id}"
}
