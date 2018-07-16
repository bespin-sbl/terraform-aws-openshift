//  Create an SSH keypair
resource "aws_key_pair" "openshift" {
  count      = "${var.public_key_path != "" ? 1 : 0}"
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

//  Create the master userdata script.
data "template_file" "setup-master" {
  count    = "${length(data.aws_availability_zones.azs.names)}"
  template = "${file("${path.module}/files/setup-master.sh")}"

  vars {
    availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_instance" "master1" {
  ami = "${data.aws_ami.rhel7_5.id}"

  # Master nodes require at least 16GB of memory.
  instance_type        = "${var.master_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-master.*.rendered, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Master 1"
    )
  )}"
}

resource "aws_instance" "master2" {
  ami = "${data.aws_ami.rhel7_5.id}"

  # Master nodes require at least 16GB of memory.
  instance_type        = "${var.master_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 1)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-master.*.rendered, 1)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Master 2"
    )
  )}"
}

resource "aws_instance" "master3" {
  ami = "${data.aws_ami.rhel7_5.id}"

  # Master nodes require at least 16GB of memory.
  instance_type        = "${var.master_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-master.*.rendered, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Master 3"
    )
  )}"
}

# resource "aws_eip" "master" {
#   instance = "${aws_instance.master.id}"
#   vpc      = true

#   //  Use our common tags and add a specific name.
#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.cluster_name} Master"
#     )
#   )}"
# }

//  Create the node userdata script.
data "template_file" "setup-node" {
  count    = "${length(data.aws_availability_zones.azs.names)}"
  template = "${file("${path.module}/files/setup-node.sh")}"

  vars {
    availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  }
}

//  Create the two nodes. This would be better as a Launch Configuration and
//  autoscaling group, but I'm keeping it simple...
resource "aws_instance" "node1" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  instance_type        = "${var.worker_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-node.*.rendered, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Node 1"
    )
  )}"
}

resource "aws_instance" "node2" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  instance_type        = "${var.worker_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 1)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-node.*.rendered, 1)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Node 2"
    )
  )}"
}

resource "aws_instance" "infra1" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  instance_type        = "${var.worker_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-node.*.rendered, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Infra Node 1"
    )
  )}"
}

resource "aws_instance" "infra2" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  instance_type        = "${var.worker_type}"
  subnet_id            = "${element(aws_subnet.public.*.id, 1)}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${element(data.template_file.setup-node.*.rendered, 1)}"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${var.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.cluster_name} Infra Node 2"
    )
  )}"
}

# resource "aws_eip" "node1" {
#   instance = "${aws_instance.node1.id}"
#   vpc      = true


#   //  Use our common tags and add a specific name.
#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.cluster_name} Node 1"
#     )
#   )}"
# }


# resource "aws_eip" "node2" {
#   instance = "${aws_instance.node2.id}"
#   vpc      = true


#   //  Use our common tags and add a specific name.
#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.cluster_name} Node 2"
#     )
#   )}"
# }


# //  Create the lb userdata script.
# data "template_file" "setup-lb" {
#   template = "${file("${path.module}/files/setup-lb.sh")}"


#   vars {
#     availability_zone = "${data.aws_availability_zones.azs.names[0]}"
#   }
# }


# resource "aws_instance" "lb" {
#   ami                  = "${data.aws_ami.rhel7_5.id}"
#   instance_type        = "${var.lb_type}"
#   subnet_id            = "${element(aws_subnet.public.*.id, 0)}"
#   iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
#   user_data            = "${data.template_file.setup-lb.rendered}"


#   vpc_security_group_ids = [
#     "${aws_security_group.openshift-vpc.id}",
#     "${aws_security_group.openshift-public-ingress.id}",
#     "${aws_security_group.openshift-public-egress.id}",
#   ]


#   //  We need at least 30GB for OpenShift, let's be greedy...
#   root_block_device {
#     volume_size = 50
#     volume_type = "gp2"
#   }


#   # Storage for Docker, see:
#   # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
#   ebs_block_device {
#     device_name = "/dev/sdf"
#     volume_size = 80
#     volume_type = "gp2"
#   }


#   key_name = "${var.key_name}"


#   //  Use our common tags and add a specific name.
#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.cluster_name} LB Node"
#     )
#   )}"
# }

