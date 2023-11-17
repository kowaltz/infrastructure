provider "spacelift" {}

data "spacelift_stack" "env-spacelift" {
  stack_id = "${var.organization}-stack-${var.env}-spacelift"
}
