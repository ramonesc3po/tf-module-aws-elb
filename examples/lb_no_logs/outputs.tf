output "subnets" {
  value = "${module.alb.subnets}"
}

output "lb_dns_name" {
  value = "${module.alb.lb_dns_name}"
}

output "target_groups_names" {
  value = "${module.alb.tg_names}"
}

output "lb_listener" {
  value = "${module.alb.lb_listener}"
}
