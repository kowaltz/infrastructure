variable "aws_account_id" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "set_of_github_repos" {
  type = set(string)
}

variable "organization" {
  type    = string
  default = "kowaltz"
}