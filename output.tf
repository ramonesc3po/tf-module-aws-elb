##
# Load balancer
##
output "subnets" {
  value = "${list(concat(aws_lb.lb_no_logs.*.subnets))}"
}

output "lb_dns_name" {
  value = "${element(concat(aws_lb.lb_no_logs.*.dns_name), 0)}"
}

output "lb_arn_suffix" {
  value = "${element(concat(aws_lb.lb_no_logs.*.arn_suffix), 0)}"
}

output "lb_arn" {
  value = "${element(concat(aws_lb.lb_no_logs.*.arn), 0)}"
}

output "lb_id" {
  value = "${element(concat(aws_lb.lb_no_logs.*.id), 0)}"
}

output "lb_zone_id" {
  value = "${element(concat(aws_lb.lb_no_logs.*.zone_id), 0)}"
}

output "tg_names" {
  value = "${slice(concat(aws_lb_target_group.tg_no_log.*.name), 0, var.number_target_group_create)}"
}

output "tg_arn" {
  value = "${slice(concat(aws_lb_target_group.tg_no_log.*.arn), 0, var.number_target_group_create)}"
}

output "tg_arn_suffix" {
  value = "${slice(concat(aws_lb_target_group.tg_no_log.*.arn_suffix), 0, var.number_target_group_create)}"
}

output "lb_listener" {
  value = "${element(concat(aws_lb_listener.listener_http_no_logs.*.arn), 0)}"
}
