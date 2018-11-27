locals {
  number_target_group_create = "2"

  target_groups = "${list(
                          map("name", "${var.organization}",
                          "backend_protocol", "HTTP",
                          "backend_port", "80",
                          "health_check_port", "80"
                          ),
                          map("name", "${var.organization}-cadastro-${var.tier}",
                          "backend_protocol", "HTTP",
                          "backend_port", "80",
                          "health_check_port", "80",
                          "health_check_path", "/api/cadastro"
                          )
                   )}"

  number_http_listeners = "1"

  http_listeners = "${list(
                           map("port", 80,
                           "protocol", "HTTP",
                           "target_group_index", "0"
                           )
  )}"
}
