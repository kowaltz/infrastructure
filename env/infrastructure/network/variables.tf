variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "organization" {
  type = string
}

variable "path_architecture_yaml" {
  type    = string
  default = "./architecture.yaml"
}