//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the private DNS.
resource "aws_route53_zone" "private" {
  name   = "${var.cluster_name}.local"
  vpc_id = "${data.aws_vpc.openshift.id}"

  tags {
    Name    = "${var.cluster_name} Private DNS"
    Project = "openshift"
  }
}

//  Routes for 'master', 'node1' and 'node2'.
resource "aws_route53_record" "master-record" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_instance.master.private_ip}",
  ]
}

resource "aws_route53_record" "node1-record" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "node1.${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_instance.node1.private_ip}",
  ]
}

resource "aws_route53_record" "node2-record" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "node2.${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_instance.node2.private_ip}",
  ]
}

//  Create the public DNS.
data "aws_route53_zone" "public" {
  count = "${var.base_domain != "" ? 1 : 0}"
  name  = "${var.base_domain}"
}

data "aws_acm_certificate" "public" {
  count  = "${var.base_domain != "" ? 1 : 0}"
  domain = "${var.base_domain}"

  statuses = [
    "ISSUED",
  ]

  most_recent = true
}

//  Create the Console LB.
resource "aws_lb" "console" {
  count   = "${var.base_domain != "" ? 1 : 0}"
  name    = "${var.cluster_name}-console-lb"
  subnets = ["${aws_subnet.public.*.id}"]

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  tags {
    Name = "${var.cluster_name} Console LB"
  }
}

resource "aws_lb_target_group" "console" {
  count    = "${var.base_domain != "" ? 1 : 0}"
  name     = "${var.cluster_name}-console-tg"
  port     = "8443"
  protocol = "HTTPS"
  vpc_id   = "${data.aws_vpc.openshift.id}"

  tags {
    Name = "${var.cluster_name} Console LB TG"
  }
}

resource "aws_lb_target_group_attachment" "console" {
  count            = "${var.base_domain != "" ? 1 : 0}"
  target_group_arn = "${aws_lb_target_group.console.arn}"
  target_id        = "${aws_instance.master.id}"
  port             = "8443"
}

resource "aws_lb_listener" "console" {
  count             = "${var.base_domain != "" ? 1 : 0}"
  load_balancer_arn = "${aws_lb.console.arn}"
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.public.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.console.arn}"
    type             = "forward"
  }
}

resource "aws_route53_record" "console" {
  count   = "${var.base_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "console.${data.aws_route53_zone.public.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.console.dns_name}"
    zone_id                = "${aws_lb.console.zone_id}"
    evaluate_target_health = "false"
  }
}

//  Create the Apps LB.
resource "aws_lb" "apps" {
  count   = "${var.base_domain != "" ? 1 : 0}"
  name    = "${var.cluster_name}-apps-lb"
  subnets = ["${aws_subnet.public.*.id}"]

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  tags {
    Name = "${var.cluster_name} Apps LB"
  }
}

resource "aws_lb_target_group" "apps_http" {
  count    = "${var.base_domain != "" ? 1 : 0}"
  name     = "${var.cluster_name}-apps-http"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.openshift.id}"

  tags {
    Name = "${var.cluster_name} Apps LB HTTP"
  }
}

resource "aws_lb_target_group_attachment" "apps_http1" {
  count            = "${var.base_domain != "" ? 1 : 0}"
  target_group_arn = "${aws_lb_target_group.apps_http.arn}"
  target_id        = "${aws_instance.node1.id}"
  port             = "80"
}

resource "aws_lb_target_group_attachment" "apps_http2" {
  count            = "${var.base_domain != "" ? 1 : 0}"
  target_group_arn = "${aws_lb_target_group.apps_http.arn}"
  target_id        = "${aws_instance.node2.id}"
  port             = "80"
}

resource "aws_lb_listener" "apps_http" {
  count             = "${var.base_domain != "" ? 1 : 0}"
  load_balancer_arn = "${aws_lb.apps.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.apps_http.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "apps_https" {
  count    = "${var.base_domain != "" ? 1 : 0}"
  name     = "${var.cluster_name}-apps-https"
  port     = "443"
  protocol = "HTTPS"
  vpc_id   = "${data.aws_vpc.openshift.id}"

  tags {
    Name = "${var.cluster_name} Apps LB HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "apps_https1" {
  count            = "${var.base_domain != "" ? 1 : 0}"
  target_group_arn = "${aws_lb_target_group.apps_https.arn}"
  target_id        = "${aws_instance.node1.id}"
  port             = "443"
}

resource "aws_lb_target_group_attachment" "apps_https2" {
  count            = "${var.base_domain != "" ? 1 : 0}"
  target_group_arn = "${aws_lb_target_group.apps_https.arn}"
  target_id        = "${aws_instance.node2.id}"
  port             = "443"
}

resource "aws_lb_listener" "apps_https" {
  count             = "${var.base_domain != "" ? 1 : 0}"
  load_balancer_arn = "${aws_lb.apps.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.public.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.apps_https.arn}"
    type             = "forward"
  }
}

resource "aws_route53_record" "apps" {
  count   = "${var.base_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "*.apps.${data.aws_route53_zone.public.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.apps.dns_name}"
    zone_id                = "${aws_lb.apps.zone_id}"
    evaluate_target_health = "false"
  }
}
