variable "aws_account_id" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "set_of_environments" {
  type    = set(string)
  default = toset(["dev", "prod"])  
}

variable "organization" {
  type    = string
  default = "kowaltz"
}