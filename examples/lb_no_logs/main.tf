data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["*zigzaga*"]
  }

  filter {
    name   = "tag:Terraform"
    values = ["true"]
  }
}

data "aws_subnet_ids" "selected" {
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }

  filter {
    name   = "tag:Terraform"
    values = ["true"]
  }

  vpc_id = "${data.aws_vpc.selected.id}"
}

resource "aws_security_group" "alb_java" {
  name        = "alb"
  description = "Conexao da Internet para o ALB"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      "name",
    ]
  }
}

module "alb" {
  source = "../.."

  organization    = "${var.organization}"
  lb_tier         = "${var.tier}"
  security_groups = "[${aws_security_group.alb_java.id}]"
  subnets         = "[${data.aws_subnet_ids.selected.ids}]"

  vpc_id = "${data.aws_vpc.selected.id}"

  number_http_listeners      = "${local.number_http_listeners}"
  number_target_group_create = "${local.number_target_group_create}"

  target_groups  = "${local.target_groups}"
  http_listeners = "${local.http_listeners}"

  tags = {
    "Name"         = "zigzagaelb"
    "Terraform"    = "true"
    "Organization" = "${var.organization}"
    "Tier"         = "${var.tier}"
  }

  lb_timeouts = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "aws_lb_listener_rule" "api_cadastro" {
  listener_arn = "${module.alb.lb_listener}"
  priority     = 100

  "action" {
    type             = "forward"
    order            = "1"
    target_group_arn = "${element(module.alb.tg_arn, 1)}"
  }

  "condition" {
    field  = "host-header"
    values = ["api.zigzaga.com"]
  }

  "condition" {
    field  = "path-pattern"
    values = ["/cadastro*"]
  }

  depends_on = [
    "module.alb"
  ]
}
