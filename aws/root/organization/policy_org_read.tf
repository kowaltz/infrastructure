resource "aws_iam_policy_attachment" "org_read" {
  name       = "org_read"
  roles      = ["AWSOrganizationsReadOnlyAccess"]
  policy_arn = aws_iam_policy.org_create.arn
}