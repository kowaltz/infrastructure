output "id" {
  value = aws_organizations_account.module.id
}

output "name" {
  value = aws_organizations_account.module.name
}

output "details" {
  value = var.account_details
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