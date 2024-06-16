variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "organization" {
  type = string
}

variable "path_org_structure_yaml" {
  type    = string
  default = "./org_structure.yaml"
}