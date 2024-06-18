variable "aws_account_id" {
  type = string
}

variable "path_architecture_yaml" {
  type    = string
  default = "./architecture.yaml"
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