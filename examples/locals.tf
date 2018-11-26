locals {
  number_target_group_create = "1"

  target_groups = "${list(
                          map("name", "zigzaga",
                          "backend_protocol", "HTTP",
                          "backend_port", "80"
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
