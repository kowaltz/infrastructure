variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "organization" {
  type = string
}

variable "path_org_structure_yaml" {
  type    = string
  default = "./org_structure.yaml"
}

variable "plan_version" {
  type    = string
  default = "0.0.4"
}

variable "root_role_name" {
  type = string
}