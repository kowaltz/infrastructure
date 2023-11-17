variable "aws_account_id" {
  type = string
}

variable "organization" {
  type = string
  default = "kowaltz"
}

variable "repository" {
  type = string
  default = "infrastructure"
}

variable "set_of_clouds" {
  type = set(string)
  default = ["aws"]
}

variable "set_of_environments" {
  type = set(string)
  default = ["dev", "prod"]
}

variable "terraform_version" {
  type = string
  default = "1.5.7"
}