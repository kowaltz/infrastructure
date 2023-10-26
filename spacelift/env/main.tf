provider "spacelift" {}

resource "spacelift_space" "env" {
  for_each = var.set_of_environments

  name = "${var.organization}-space-env"
  parent_space_id = "root"
  description = "Space for managing env-level Spacelift infrastructure."
}