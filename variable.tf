##
# Load balancer
##
variable "create_lb" {
  description = "Set false if you not want create Load Balancer, default is true"
  default     = "true"
}

variable "lb_name" {
  description = "(Optional) Set addtional name to Load Balancer"
  default = ""
}

variable "lb_tier" {
  description = "If you want be create load balancers with environments names"
}

variable "organization" {
  description = "Used organization set the name load balancer"
}

variable "lb_is_internal" {
  description = "Should true if you want create internal load balancer, default is false"
  default     = false
}

variable "lb_type" {
  description = "Type load balancer is application"
  default     = "application"
}

variable "subnets" {
  description = "Subnets for deploy laod balancer"
  default     = []
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed, set default is 60"
  default     = "60"
}

variable "enable_deletion_protetcion" {
  description = "Should set true if you want be disabled deletion via AWS API, this prevent terraform from deleting the load balancer, defaul is false"
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to false"
  default     = false
}

variable "enable_http2" {
  description = "Enable http2, default is true"
  default     = true
}

variable "ip_address_type" {
  description = "Is type of IP address used by subnet for your load balancer, you can use ipv4 or dualstack, default is ipv4"
  default     = "ipv4"
}

variable "security_groups" {
  description = "Security group to attach load balancer"
  default     = []
}

variable "lb_timeouts" {
  description = "Set parameters for timeouts create, update and destroy"
  type        = "map"

  default = {
    "create" = "60m"
    "update" = "60m"
    "delete" = "60m"
  }
}

##
# Target group load balancer
##
variable "number_target_group_create" {
  description = "Set value equals total target group you want create"
  default     = 0
}

variable "target_groups" {
  description = "List target groups"
  default     = []
}

variable "target_group_default" {
  description = "List target groups default parameters"
  default     = {}
}

variable "vpc_id" {
  description = "Set vpc id"
}

##
# Listener load balancer
##
variable "http_listeners" {
  description = "Set use http listener, this option not use certificate"
  type        = "list"
  default     = []
}

variable "number_http_listeners" {
  description = "Define how many HTTP listner will be create"
  default     = 0
}

variable "http_redirect_listeners" {
  description = "Set use http listener, this option not use certificate"
  type        = "list"
  default     = []
}

variable "number_http_redirect_listeners" {
  description = "Define how many HTTP listner will be create"
  default     = 0
}

variable "number_https_listeners" {
  description = "Define how many HTTPS listner will be create"
  default     = 0
}

variable "https_listeners" {
  description = "Set use HTTPS listener, this option use certficate"
  type        = "list"
  default     = []
}

##
# SSL CERTIFICATE
##
variable "number_ssl_certs" {
  description = "Define how many ssl certs use"
  default     = 0
}

variable "ssl_certs" {
  description = "Set certificate arn will be use in listener"
  type        = "list"
  default     = []
}
