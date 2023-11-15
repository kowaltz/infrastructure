variable "aws_account_id" {
  type = string
}

variable "env" {
  type = string
}

variable "set_of_github_repos" {
  type = set(string)
}

variable "organization" {
  type    = string
  default = "kowaltz"
}