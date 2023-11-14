variable "aws_account_id" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "list_of_github_repos" {
  type = list(string)
}

variable "organization" {
  type    = string
  default = "kowaltz"
}