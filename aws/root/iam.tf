resource "aws_iam_policy" "manage_organization" {
  name        = "${var.organization}-iam-policy-root-organizations_manage"
  path        = "/root/"
  description = "Policy for managing an organization, OUs and their accounts at the root level. It also allows the role to manage policies at the organizational level."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:ListAccounts",
          "organizations:ListChildren",
          "organizations:ListCreateAccountStatus",
          "organizations:ListAccountsForParent",
          "organizations:ListOrganizationalUnitsForParent",
          "organizations:ListParents",
          "organizations:ListPolicies",
          "organizations:ListPoliciesForTarget",
          "organizations:ListRoots",
          "organizations:ListTargetsForPolicy",
          "organizations:DescribeAccount",
          "organizations:DescribeCreateAccountStatus",
          "organizations:DescribeEffectivePolicy",
          "organizations:DescribeOrganizationalUnit",
          "organizations:DescribePolicy",
          "organizations:AttachPolicy",
          "organizations:CloseAccount",
          "organizations:CreateAccount",
          "organizations:CreateOrganizationalUnit",
          "organizations:CreatePolicy",
          "organizations:DeleteOrganizationalUnit",
          "organizations:DeletePolicy",
          "organizations:DescribeOrganization",
          "organizations:DetachPolicy",
          "organizations:DisablePolicyType",
          "organizations:EnablePolicyType",
          "organizations:InviteAccountToOrganization",
          "organizations:MoveAccount",
          "organizations:RemoveAccountFromOrganization",
          "organizations:UpdateOrganizationalUnit",
          "organizations:UpdatePolicy"
        ],
        "Resource" : [
          data.aws_iam_role.root_role.arn
        ]
      }
    ]
  })
}