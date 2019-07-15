locals {
  name_default_lb  = "${var.organization}-${var.lb_tier}"
  name_elb         = "${var.lb_name}-${var.organization}-${var.lb_tier}"
  name_compose_elb = var.lb_name != "" ? local.name_elb : local.name_default_lb
}

resource "aws_lb" "lb_no_logs" {
  count = var.create_lb ? 1 : 0

  name               = local.name_compose_elb
  internal           = var.lb_is_internal
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups

  subnets = var.subnets

  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protetcion
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type

  tags = merge(
    var.tags,
    {
      Name         = local.name_compose_elb
      Terraform    = "true"
      Tier         = var.lb_tier
      Organization = var.organization
    }
  )

  timeouts {
    create = var.lb_timeouts["create"]
    update = var.lb_timeouts["update"]
    delete = var.lb_timeouts["delete"]
  }
}

resource "aws_lb_target_group" "tg_no_log" {
  count = var.create_lb ? var.number_target_group_create : 0

  name     = var.target_groups[count.index]["name"]
  port     = var.target_groups[count.index]["backend_port"]
  protocol = var.target_groups[count.index]["backend_protocol"]
  deregistration_delay = lookup(
    var.target_groups[count.index],
    "deregistration_delay",
    local.target_group_default["deregistration_delay"],
  )
  target_type = lookup(
    var.target_groups[count.index],
    "target_type",
    local.target_group_default["target_type"],
  )
  vpc_id = var.vpc_id

  stickiness {
    type = "lb_cookie"
    cookie_duration = lookup(
      var.target_groups[count.index],
      "cookie_duration",
      local.target_group_default["cookie_duration"],
    )
    enabled = lookup(
      var.target_groups[count.index],
      "stickiness_enabled",
      local.target_group_default["stickiness_enabled"],
    )
  }

  health_check {
    path = lookup(
      var.target_groups[count.index],
      "health_check_path",
      local.target_group_default["health_check_path"],
    )
    protocol = upper(
      lookup(
        var.target_groups[count.index],
        "health_check_protocol",
        var.target_groups[count.index]["backend_protocol"],
      ),
    )
    healthy_threshold = lookup(
      var.target_groups[count.index],
      "health_check_healthy_threshold",
      local.target_group_default["health_check_healthy_threshold"],
    )
    port = lookup(
      var.target_groups[count.index],
      "health_check_port",
      local.target_group_default["health_check_port"],
    )
    unhealthy_threshold = lookup(
      var.target_groups[count.index],
      "health_check_unhealthy_threshold",
      local.target_group_default["health_check_unhealthy_threshold"],
    )
    timeout = lookup(
      var.target_groups[count.index],
      "health_check_timeout",
      local.target_group_default["health_check_timeout"],
    )
    interval = lookup(
      var.target_groups[count.index],
      "health_check_interval",
      local.target_group_default["health_check_interval"],
    )
    matcher = lookup(
      var.target_groups[count.index],
      "health_check_matcher",
      local.target_group_default["health_check_matcher"],
    )
  }

  tags = merge(
    var.tags,
    {
      Name         = var.target_groups[count.index]["name"]
      Terrafom     = "true"
      Tier         = var.lb_tier
      Organization = var.organization
    },
  )

  depends_on = [aws_lb.lb_no_logs]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_no_logs" {
  count = var.number_http_listeners

  load_balancer_arn = element(concat(aws_lb.lb_no_logs.*.arn, [""]), 0)
  port              = var.http_listeners[count.index]["port"]
  protocol          = var.http_listeners[count.index]["protocol"]

  default_action {
    target_group_arn = aws_lb_target_group.tg_no_log[lookup(var.http_listeners[count.index], "target_group_index", 0)].id
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_redirect_no_logs" {
  count = var.number_http_redirect_listeners

  load_balancer_arn = element(concat(aws_lb.lb_no_logs.*.arn, [""]), 0)
  port              = var.http_redirect_listeners[count.index]["port"]
  protocol          = var.http_redirect_listeners[count.index]["protocol"]

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      status_code = var.http_redirect_listeners[count.index]["status_code"]
      port        = var.http_redirect_listeners[count.index]["redirect_port"]
    }
  }
}

resource "aws_lb_listener" "https_no_logs" {
  count = var.create_lb ? var.number_https_listeners : 0

  load_balancer_arn = element(concat(aws_lb.lb_no_logs.*.arn, [""]), 0)
  port              = var.https_listeners[count.index]["port"]
  certificate_arn   = var.https_listeners[count.index]["certificate_arn"]
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"

  default_action {
    target_group_arn = aws_lb_target_group.tg_no_log[lookup(var.https_listeners[count.index], "target_group_index", 0)].id
    type             = "forward"
  }
}

resource "aws_alb_listener_certificate" "https_no_logs" {
  count = var.create_lb ? var.number_ssl_certs : 0

  certificate_arn = var.ssl_certs[count.index]["certificate_arn"]
  listener_arn    = aws_lb_listener.https_no_logs[var.ssl_certs[count.index]["https_listener_index"]].arn
}

