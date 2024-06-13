variable "aws_account_id" {
  type = string
}

variable "path_org_structure_yaml" {
  type    = string
  default = "./org_structure.yaml"
}

variable "organization" {
  type = string
}

variable "repository" {
  type    = string
}

variable "terraform_version" {
  type = string
}