variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "organization" {
  type = string
}

variable "path_config_yaml" {
  type    = string
  default = "./config.yaml"
}