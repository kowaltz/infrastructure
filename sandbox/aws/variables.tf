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

variable "ou_sandbox_id" {
  type    = string
}