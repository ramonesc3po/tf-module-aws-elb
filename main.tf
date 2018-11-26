terraform {
  required_version = "<= 0.11.10"
}

resource "aws_lb" "lb_no_logs" {
  count = "${var.create_lb ? 1 : 0}"

  name_prefix        = "${var.organization}"
  internal           = "${var.lb_is_internal}"
  load_balancer_type = "${var.lb_type}"
  security_groups    = ["${var.security_groups}"]

  subnets = ["${var.subnets}"]

  idle_timeout                     = "${var.idle_timeout}"
  enable_deletion_protection       = "${var.enable_deletion_protetcion}"
  enable_cross_zone_load_balancing = "${var.enable_cross_zone_load_balancing}"
  enable_http2                     = "${var.enable_http2}"
  ip_address_type                  = "${var.ip_address_type}"

  tags = "${merge(var.tags, map("Name",var.organization))}"

  timeouts {
    create = "${lookup(var.lb_timeouts, "create")}"
    update = "${lookup(var.lb_timeouts["update"])}"
    delete = "${lookup(var.lb_timeouts["delete"])}"
  }
}

resource "aws_lb_target_group" "tg_no_log" {
  count = "${var.create_lb ? 0 : ${var.number_target_group_create}}"

  name                 = "${lookup(var.target_groups[count.index], "name")}"
  port                 = "${lookup(var.target_groups[count.index], "backend_port")}"
  protocol             = "${lookup(var.target_groups[count.index], "backend_protocol")}"
  deregistration_delay = "${lookup(var.target_groups[count.index], "deregistration_delay", lookup(local.target_group_default, "deregistration_delay"))}"
  target_type          = "${lookup(var.target_groups[count.index], "target_type", lookup(local.target_group_default, "target_type"))}"
  vpc_id               = "${var.vpc_id}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${lookup(var.target_groups[count.index],"cookie_duration", lookup(local.target_group_default,"cookie_duration"))}"
    enabled         = "${lookup(var.target_groups[count.index], "stickiness_enabled",lookup(local.target_group_default, "stickiness_enabled"))}"
  }

  health_check {
    path                = "${lookup(var.target_groups[count.index], "health_check_path", lookup(local.target_group_default, "health_check_path"))}"
    protocol            = "${upper(lookup(var.target_groups[count.index], "health_check_protocol", lookup(var.target_groups[count.index], "backend_protocol")))}"
    healthy_threshold   = "${lookup(var.target_groups[count.index], "health_check_healthy_threshold", lookup(local.target_group_default, "health_check_healthy_threshold"))}"
    port                = "${lookup(var.target_groups[count.index], "health_check_port")}"
    unhealthy_threshold = "${lookup(var.target_groups[count.index], "health_check_unhealthy_threshold", lookup(local.target_group_default, "health_check_unhealthy_threshold"))}"
    timeout             = "${lookup(var.target_groups[count.index], "health_check_timout", lookup(local.target_group_default, "health_check_timeout"))}"
    interval            = "${lookup(var.target_groups[count.index], "health_check_interval", lookup(local.target_group_default, "health_check_interval"))}"
    matcher             = "${lookup(var.target_groups[count.index], "health_check_matcher", lookup(local.target_group_default, "health_check_matcher"))}"
  }

  tags = "${merge(var.tags, map("Name",lookup(var.target_groups[count.index], "name")))}"
}
