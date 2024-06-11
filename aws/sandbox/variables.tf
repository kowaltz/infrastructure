variable "aws_account_id_sandbox" {
  type = number
}

variable "aws_account_id" {
  type = number
}

variable "aws_region" {
  type = string
}

variable "organization" {
  type    = string
  default = "kowaltz"
}

variable "name" {
  type    = string
  default = "sandbox"
}

variable "env" {
  type    = string
  default = "root"
}