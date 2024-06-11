# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias      = "sandbox"
  region     = var.aws_region
}

resource "aws_iam_policy" "sts_assume" {
  provider = aws.sandbox
  
  name        = "${var.organization}-iam-policy-root-sts_assume"
  path        = "/root/${var.organization}/"
  description = "Policy for being able to assume STS roles in any account in the organization."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/${var.organization}-*",
          "arn:aws:iam::*:role/OrganizationAccountAccessRole"
        ]
      }
    ]
  })
}

resource "null_resource" "create_iam_role" {
  triggers = {
    # Define triggers here if needed, e.g., changes in variables
  }

  provisioner "local-exec" {
    command = <<EOT
aws sts assume-role \
    --role-arn "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole" \
    --role-session-name "TerraformCreateIAMRoleSession" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text > assume_role_credentials.txt

export AWS_ACCESS_KEY_ID=$(cut -f1 assume_role_credentials.txt)
export AWS_SECRET_ACCESS_KEY=$(cut -f2 assume_role_credentials.txt)
export AWS_SESSION_TOKEN=$(cut -f3 assume_role_credentials.txt)

aws iam create-role \
    --role-name "rolespaceliftdefault" \
    --assume-role-policy-document file://assume_role_policy.json

# Attach the policy to the IAM role
aws iam put-role-policy \
    --role-name "ROLE_NAME" \
    --policy-name "SpaceliftPermissions" \
    --policy-document file://policy_document.json

# Clean up temporary credentials file
rm assume_role_credentials.txt
EOT
  }
}


/*
resource "aws_cloudformation_stack_set" "role_spaceliftdefault" {
  // This resource creates the Stack Set for the IAM role.
  name = "${var.organization}-stackset-sandbox-rolespaceliftdefault"

  # administration_role_arn = "arn:aws:iam::${var.aws_account_id}:role/AWSServiceRoleForCloudFormationStackSetsOrgAdmin"
  permission_model = "SERVICE_MANAGED"

  template_body = templatefile("iam_role_spacelift.yaml.tpl", {
    organization = var.organization
    env = "root"
    name = "sandbox"
  })

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]
}

resource "aws_cloudformation_stack_set_instance" "role_spaceliftdefault" {
  // This resource specifies the target of the Stack Set.
  stack_set_name = aws_cloudformation_stack_set.role_spaceliftdefault.name

  account_id = var.aws_account_id_sandbox
  region     = var.aws_region
}


provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias      = "sandbox"
  region     = var.aws_region
}
*/