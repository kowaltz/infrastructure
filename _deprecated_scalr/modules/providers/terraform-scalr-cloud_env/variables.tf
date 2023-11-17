variable "account_id" {
  type = string
}

variable "aws_audience" {
  type = string
}

variable "aws_role_arn" {
  type = string
}

variable "azure_audience" {
  type = string
}

variable "azure_credentials" {
  type = map(string)
}

variable "env" {
  type = string
}

variable "list_of_shared_environments_ids" {
  type    = list(string)
  default = []
}

variable "set_of_cloud_providers" {
  type = set(string)
}