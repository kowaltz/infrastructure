# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}


resource "aws_organizations_organization" "root" {
  aws_service_access_principals = [
    "cloudformation.amazonaws.com"
  ]

  feature_set = "ALL"
}

resource "aws_cloudformation_stack_set" "iam_role_stack_set" {
  // This resource creates the Stack Set for the IAM role.
  name = "${var.organization}-stackset-sandbox-rolespaceliftdefault"

  administration_role_arn = "arn:aws:iam::${var.aws_account_id}:role/AWSCloudFormationStackSetAdministrationRole"
  execution_role_name     = "AWSCloudFormationStackSetExecutionRole"

  template_body = templatefile("iam_role_spacelift.yaml.tpl", {
    organization = var.organization
    env = "root"
    name = "sandbox"
  })

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]

  parameters = {
    RoleName = "CrossAccountRole"
  }
}

resource "aws_cloudformation_stack_set_instance" "iam_role_stack_set_instance" {
  // This resource specifies the target of the Stack Set.
  stack_set_name = aws_cloudformation_stack_set.iam_role_stack_set.name

  account_id = var.aws_account_id_sandbox
  region     = var.aws_region
}


provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias  = "sandbox"
  region = var.aws_region
}
