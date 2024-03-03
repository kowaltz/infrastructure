provider "spacelift" {}
provider "http" {}

data "spacelift_stack" "env-spacelift" {
  stack_id = "${var.organization}-stack-${var.env}-spacelift"
}
