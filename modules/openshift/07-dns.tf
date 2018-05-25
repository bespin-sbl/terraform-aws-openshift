//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the private DNS.
resource "aws_route53_zone" "private" {
  name = "${var.cluster_name}.local"
  comment = "OpenShift Cluster Private DNS"
  vpc_id = "${aws_vpc.openshift.id}"
  tags {
    Name    = "${var.cluster_name} Private DNS"
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

//resource "aws_elb" "public" {
//  name               = "foobar-terraform-elb"
//  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
//
//  access_logs {
//    bucket        = "foo"
//    bucket_prefix = "bar"
//    interval      = 60
//  }
//
//  listener {
//    instance_port     = 8000
//    instance_protocol = "http"
//    lb_port           = 80
//    lb_protocol       = "http"
//  }
//
//  listener {
//    instance_port      = 8000
//    instance_protocol  = "http"
//    lb_port            = 443
//    lb_protocol        = "https"
//    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
//  }
//
//  health_check {
//    healthy_threshold   = 2
//    unhealthy_threshold = 2
//    timeout             = 3
//    target              = "HTTP:8000/"
//    interval            = 30
//  }
//
//  instances                   = ["${aws_instance.foo.id}"]
//  cross_zone_load_balancing   = true
//  idle_timeout                = 400
//  connection_draining         = true
//  connection_draining_timeout = 400
//
//  tags {
//    Name = "foobar-terraform-elb"
//  }
//}

resource "aws_route53_record" "master-a-console" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "console.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${aws_instance.master.public_ip}"
  ]
}
resource "aws_route53_record" "master-a-apps" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "*.apps.${data.aws_route53_zone.public.name}"
  type = "A"
  ttl  = 300
  records = [
    "${aws_instance.master.public_ip}"
  ]
}
