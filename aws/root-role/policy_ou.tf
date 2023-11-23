resource "aws_iam_policy_attachment" "read_organizations" {
  name       = "AWSOrganizationsReadOnlyAccess"
  roles      = [local.root_role_name]
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}
