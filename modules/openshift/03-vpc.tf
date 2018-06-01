//  Define the VPC.
resource "aws_vpc" "openshift" {
  count = "${var.vpc_id == "" ? 1 : 0}"

  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} VPC"
    )
  )}"
}

data "aws_vpc" "openshift" {
  id = "${var.vpc_id == "" ? aws_vpc.openshift.id : var.vpc_id}"
}

//  Create a public subnet.
resource "aws_subnet" "public" {
  vpc_id = "${data.aws_vpc.openshift.id}"

  count = "${length(data.aws_availability_zones.azs.names)}"

  cidr_block = "${cidrsubnet(data.aws_vpc.openshift.cidr_block, 8, 31 + count.index)}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = true

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Public Subnet"
    )
  )}"
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "public" {
  vpc_id = "${data.aws_vpc.openshift.id}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} IGW"
    )
  )}"
}

//  Create an Elastic IP for the NAT Gateway.
//resource "aws_eip" "public" {
//  vpc = true
//
//  depends_on = ["aws_internet_gateway.public"]
//
//  //  Use our common tags and add a specific name.
//  tags = "${merge(
//    local.common_tags,
//    map(
//      "Name", "${var.cluster_name} NAT"
//    )
//  )}"
//}

//  Create an NAT Gateway for the VPC.
//resource "aws_nat_gateway" "public" {
//  allocation_id = "${aws_eip.public.id}"
//  subnet_id = "${element(aws_subnet.public.*.id, 0)}"
//
//  depends_on = ["aws_eip.public"]
//
//  //  Use our common tags and add a specific name.
//  tags = "${merge(
//    local.common_tags,
//    map(
//      "Name", "${var.cluster_name} NAT"
//    )
//  )}"
//}

//  Create a route table allowing all addresses access to the NAT.
resource "aws_route_table" "public" {
  vpc_id = "${data.aws_vpc.openshift.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

//  route {
//    cidr_block = "0.0.0.0/0"
//    nat_gateway_id = "${aws_nat_gateway.public.id}"
//  }

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Public Route Table"
    )
  )}"
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
