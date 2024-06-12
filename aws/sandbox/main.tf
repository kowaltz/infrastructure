# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "null_resource" "create_iam_role" {
  provisioner "local-exec" {
    command = <<EOT
aws sts get-caller-identity
EOT
  }
}

/*
provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias      = "sandbox"
  region     = var.aws_region
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

cat assume_role_credentials.txt

export AWS_ACCESS_KEY_ID=$(cut -f1 assume_role_credentials.txt)
export AWS_SECRET_ACCESS_KEY=$(cut -f2 assume_role_credentials.txt)
export AWS_SESSION_TOKEN=$(cut -f3 assume_role_credentials.txt)

# IAM Role policy document
echo '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::324880187172:root"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringLike": {
          "sts:ExternalId": [
            "${var.organization}-github@*@${var.organization}-stack-${var.env}-aws_${var.name}@*",
            "${var.organization}-github@*@${var.organization}-stack-${var.env}-spacelift@*"
          ]
        }
      }
    }
  ]
}' > assume_role_policy.json

# Policy document
echo '${local.policy_document}' > policy_document.json

aws cloudformation create-stack \
    --stack-name "iam-role-stack" \
    --template-body file://iam_role_spacelift.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --region ${var.aws_region} \
    --parameters \
        ParameterKey=RoleName,ParameterValue=rolespaceliftdefault \
        ParameterKey=AssumeRolePolicyDocument,ParameterValue=file://assume_role_policy.json \
        ParameterKey=PolicyDocument,ParameterValue=file://policy_document.json

# Attach the policy to the IAM role
aws iam put-role-policy \
    --role-name "rolespaceliftdefault" \
    --policy-name "SpaceliftPermissions" \
    --policy-document file://policy_document.json

# Clean up temporary credentials file
rm assume_role_credentials.txt
EOT
  }
}

  # Define local variable for the policy document
locals {
    policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

*/

/*
resource "aws_cloudformation_stack_set" "role_spaceliftdefault" {
  // This resource creates the Stack Set for the IAM role.
  name = "${var.organization}-stackset-sandbox-rolespaceliftdefault"

  permission_model = "SERVICE_MANAGED"
  # administration_role_arn = "arn:aws:iam::${var.aws_account_id}:role/AWSServiceRoleForCloudFormationStackSetsOrgAdmin"

  auto_deployment {
    enabled = true
    retain_stacks_on_account_removal = false
  }

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
  deployment_targets {
    organizational_unit_ids = [var.ou_sandbox_id]
  }
  stack_set_name = aws_cloudformation_stack_set.role_spaceliftdefault.name
  region = var.aws_region
}
*/