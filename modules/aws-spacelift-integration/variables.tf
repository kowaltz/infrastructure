variable "account_id" {
  type = string
}

variable "account_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "path" {
  type = string
}

variable "organization" {
  type = string
}

variable "ou_id" {
  type = string
}

variable "set_of_managed_policies" {
  type = set(string)
}