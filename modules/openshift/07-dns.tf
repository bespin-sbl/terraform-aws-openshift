//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the private DNS.
resource "aws_route53_zone" "private" {
  name = "openshift.local"
  comment = "OpenShift Cluster Private DNS"
  vpc_id = "${aws_vpc.openshift.id}"
  tags {
    Name    = "OpenShift Private DNS"
    Project = "openshift"
  }
}

//  Routes for 'master', 'node1' and 'node2'.
resource "aws_route53_record" "master-a-record" {
    zone_id = "${aws_route53_zone.private.zone_id}"
    name = "master.${aws_route53_zone.private.name}"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.master.private_ip}"
    ]
}
resource "aws_route53_record" "node1-a-record" {
    zone_id = "${aws_route53_zone.private.zone_id}"
    name = "node1.${aws_route53_zone.private.name}"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.node1.private_ip}"
    ]
}
resource "aws_route53_record" "node2-a-record" {
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
  name = "${var.base_domain}"
}
resource "aws_route53_record" "master-a-console" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "${var.cluster_name}.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${aws_instance.master.public_ip}"
  ]
}
resource "aws_route53_record" "master-a-apps" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "*.${var.cluster_name}.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${aws_instance.master.public_ip}"
  ]
}
