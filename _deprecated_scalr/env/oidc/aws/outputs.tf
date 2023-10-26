output "arn" {
    value = aws_iam_role.env-role-scalr.arn
}

output "audience" {
  value = local.aws_audience
}