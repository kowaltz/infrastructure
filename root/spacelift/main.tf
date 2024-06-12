provider "spacelift" {}

data "spacelift_stack" "root-spacelift" {
  stack_id = "${var.organization}-stack-root-spacelift"
}