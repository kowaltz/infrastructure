resource "aws_iam_policy_attachment" "org_read" {
  name       = "AWSOrganizationsReadOnlyAccess"
  roles      = [local.root_role_name]
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}