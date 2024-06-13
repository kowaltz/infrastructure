output "id" {
  value = aws_organizations_account.module.id
}

output "name" {
  value = aws_organizations_account.module.name
}

output "env" {
  value = var.env
}

output "parent_id" {
  value = var.parent_id
}

output "path" {
  value = local.path
}

output "set_of_policies" {
  value = var.set_of_policies
}