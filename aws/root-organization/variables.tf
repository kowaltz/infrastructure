variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "set_of_environments" {
  type    = set(string)
  default = ["dev", "prod"]
}

variable "organization" {
  type    = string
  default = "kowaltz"
}

variable "root_role_name" {
  type = string
}