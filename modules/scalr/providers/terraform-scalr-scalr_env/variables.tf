variable "account_id" {
  type = string
}

variable "env" {
  type = string
}

variable "list_of_shared_environments_ids" {
  type    = list(string)
  default = []
}

variable "hostname" {
  type = string
}

variable "list_of_roles_ids" {
  type = list(string)
}