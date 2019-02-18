resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}"
}

data "template_file" "userdata" {
  template   = "${file("${path.module}/userdata.tpl")}"
  depends_on = ["aws_efs_file_system.ecs"]

  vars {
    tf_cluster_name = "${aws_ecs_cluster.ecs.name}"
    tf_efs_id       = "${aws_efs_file_system.ecs.id}"
  }
}

resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ecs-${var.name}-"
  image_id             = "${data.aws_ami.amzn.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"

  security_groups = [
    "${aws_security_group.ecs_nodes.id}",
  ]

  user_data_base64 = "${base64encode(data.template_file.userdata.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-${var.name}"
  launch_configuration = "${aws_launch_configuration.ecs.name}"

  vpc_zone_identifier = ["${var.private_subnet_ids}"]

  min_size = "${var.asg_min}"
  max_size = "${var.asg_max}"

  tags = [
    "${map("key", "Name", "value", "ecs-node-${var.name}", "propagate_at_launch", true)}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
