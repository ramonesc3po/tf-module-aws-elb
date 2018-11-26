data "" "" {}

provider "terraform" {}

module "alb" {
  source = "../"

  organization = "zigzaga"
  security_groups = "[]"

  vpc_id = ""
}