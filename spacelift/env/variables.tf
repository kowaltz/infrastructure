variable "aws_account_id" {
  type = string
}

variable "aws_account_id_infrastructure_env_vms" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "organization" {
  type    = string
  default = "kowaltz"
}

variable "repository" {
  type    = string
  default = "infrastructure"
}

variable "terraform_version" {
  type    = string
  default = "1.5.7"
}