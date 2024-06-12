variable "aws_account_id" {
  type = string
}

variable "organization" {
  type    = string
}

variable "repository" {
  type    = string
  default = "infrastructure"
}

variable "set_of_environments" {
  type = set(string)
}

variable "terraform_version" {
  type = string
}