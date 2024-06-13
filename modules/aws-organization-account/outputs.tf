output "id" {
  value = aws_organizations_account.module.id
}

output "name" {
  value = aws_organizations_account.module.name
}

output "parent_id" {
  value = var.parent_id
}

output "path" {
  value = var.path
}