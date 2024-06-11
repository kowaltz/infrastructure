# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}


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
