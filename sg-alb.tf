resource "aws_security_group" "alb" {
  count = "${var.alb ? 1 : 0}"

  name        = "ecs-${var.name}-lb"
  description = "SG for ECS ALB"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "ecs-${var.name}-lb"
  }
}

resource "aws_security_group_rule" "http_from_world_to_alb" {
  count = "${var.alb ? 1 : 0}"

  description       = "HTTP Redirect ECS ALB"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_from_world_to_alb" {
  count = "${var.alb ? 1 : 0}"

  description       = "HTTPS ECS ALB"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
