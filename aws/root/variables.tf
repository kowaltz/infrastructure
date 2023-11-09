variable "aws_account_id" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "aws_organization_id" {
  type = string
}

variable "aws_organization_root_id" {
  type = string
}

variable "organization" {
  type    = string
  default = "kowaltz"
}