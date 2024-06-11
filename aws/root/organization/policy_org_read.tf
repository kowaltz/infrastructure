resource "aws_iam_policy_attachment" "org_read" {
  name       = "org_read"
  roles      = [var.root_role_name]
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}