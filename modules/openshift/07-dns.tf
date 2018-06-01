//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the private DNS.
resource "aws_route53_zone" "private" {
  name = "${var.cluster_name}.local"
  comment = "OpenShift Cluster Private DNS"
  vpc_id = "${data.aws_vpc.openshift.id}"
  tags {
    Name    = "${var.cluster_name} Private DNS"
    Project = "openshift"
  }
}

//  Routes for 'master', 'node1' and 'node2'.
resource "aws_route53_record" "master-record" {
    zone_id = "${aws_route53_zone.private.zone_id}"
    name = "master.${aws_route53_zone.private.name}"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.master.private_ip}"
    ]
}
resource "aws_route53_record" "node1-record" {
    zone_id = "${aws_route53_zone.private.zone_id}"
    name = "node1.${aws_route53_zone.private.name}"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.node1.private_ip}"
    ]
}
resource "aws_route53_record" "node2-record" {
    zone_id = "${aws_route53_zone.private.zone_id}"
    name = "node2.${aws_route53_zone.private.name}"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.node2.private_ip}"
    ]
}

//  Create the public DNS.
data "aws_route53_zone" "public" {
  count = "${var.base_domain != "" ? 1 : 0}"
  name = "${var.base_domain}"
}

resource "aws_route53_record" "console" {
  count = "${var.base_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "console.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${var.master_eip == "" ? aws_eip.master.public_ip : var.master_eip}"
  ]
}
resource "aws_route53_record" "apps" {
  count = "${var.base_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "*.apps.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${var.master_eip == "" ? aws_eip.master.public_ip : var.master_eip}"
  ]
}
