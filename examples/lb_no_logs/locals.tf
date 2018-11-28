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

  number_https_listeners = "1"

  https_listeners = "${list(
                            map("port", 443,
                            "target_group_index", "0"
                            )
  )}"

  number_ssl_certs = "1"

  ssl_certs = "${list(
                      map("certificate_arn", aws_iam_server_certificate.ssl_cert.0.arn,
                      "https_listener_index", "1"
                      )
  )}"
}
