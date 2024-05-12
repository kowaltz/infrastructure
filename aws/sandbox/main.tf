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

provider "aws" {
  region = var.aws_region
  #new line added here
  access_key = 
  secret_key = 
  
}

/*provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::${var.aws_account_id_sandbox}:role/OrganizationAccountAccessRole"
    external_id = "kowaltz-github@*@kowaltz-stack-root-aws_sandbox"
    #"${organization}-github@*@${organization}-stack-${env}-aws_${name}@*"
  }

  alias  = "sandbox"
  region = var.aws_region
}*/

resource "aws_iam_role" "sandbox-spacelift_default" {
  provider    = aws.sandbox
  
  name        = "${var.organization}-role-sandbox-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to the sandbox account."
  assume_role_policy = templatefile("./policy_spacelift.json.tpl", {
    organization = var.organization
    env = "root"
    name = "sandbox"
  })
}