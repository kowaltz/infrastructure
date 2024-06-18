variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_oidc_enabled" {
  type = bool
}

variable "path_config_yaml" {
  type    = string
  default = "./config.yaml"
}