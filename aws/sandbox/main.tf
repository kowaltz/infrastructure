# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  /* WITH OIDC
  assume_role_with_web_identity {
    role_arn                = local.root_role_arn
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }
  */
}


resource "aws_cloudformation_stack_set" "iam_role_stack_set" {
  name = "IAMRoleStackSet"

  administration_role_arn = "arn:aws:iam::${var.aws_account_id}:role/AWSCloudFormationStackSetAdministrationRole"
  execution_role_name     = "AWSCloudFormationStackSetExecutionRole"

  template_body = templatefile("iam_role_template.yaml", {
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
  stack_set_name = aws_cloudformation_stack_set.iam_role_stack_set.name

  account_id = var.aws_account_id_sandbox
  region     = var.aws_region
}


/*provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias  = "sandbox"
  region = var.aws_region
}*/

resource "aws_iam_role" "sandbox-spacelift_default" {
  provider    = aws.sandbox
  
  name        = ""
