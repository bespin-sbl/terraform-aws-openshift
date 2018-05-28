//  This security group allows intra-node communication on all ports with all
//  protocols.
resource "aws_security_group" "openshift-vpc" {
  name        = "${var.cluster_name}-vpc"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.openshift.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Internal VPC"
    )
  )}"
}

//  This security group allows public ingress to the instances for HTTP, HTTPS
//  and common HTTP/S proxy ports.
resource "aws_security_group" "openshift-public-ingress" {
  name        = "${var.cluster_name}-public-ingress"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id      = "${aws_vpc.openshift.id}"

  //  HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTP Proxy
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS Proxy
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Public Ingress"
    )
  )}"
}

//  This security group allows public egress from the instances for HTTP and
//  HTTPS, which is needed for yum updates, git access etc etc.
resource "aws_security_group" "openshift-public-egress" {
  name        = "${var.cluster_name}-public-egress"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id      = "${aws_vpc.openshift.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

//  //  SSH
//  egress {
//    from_port   = 22
//    to_port     = 22
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

//  //  HTTP
//  egress {
//    from_port   = 80
//    to_port     = 80
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

//  //  HTTPS
//  egress {
//    from_port   = 443
//    to_port     = 443
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

//  //  Bitbucket HTTPS
//  egress {
//    from_port   = 7990
//    to_port     = 7990
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

//  //  Bitbucket SSH
//  egress {
//    from_port   = 7999
//    to_port     = 7990
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Public Egress"
    )
  )}"
}

//  Security group which allows SSH access to a host. Used for the bastion.
resource "aws_security_group" "openshift-ssh" {
  name        = "${var.cluster_name}-ssh"
  description = "Security group that allows public ingress over SSH."
  vpc_id      = "${aws_vpc.openshift.id}"

  //  SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} SSH Access"
    )
  )}"
}
