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
  source = "../"

  organization    = "zigzaga"
  security_groups = "[${aws_security_group.alb_java.id}]"
  subnets         = "[${data.aws_subnet_ids.selected.ids}]"

  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    "Name"         = "zigzagaelb"
    "Terraform"    = "true"
    "Organization" = "zigzaga"
  }

  lb_timeouts = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}
