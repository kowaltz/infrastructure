provider "spacelift" {}

resource "spacelift_space" "env" {
  name = "${var.organization}-space-${var.env}"
  parent_space_id = "root"
  description = "Space for managing ${var.env}-level Spacelift infrastructure."
}