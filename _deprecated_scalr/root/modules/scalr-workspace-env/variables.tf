variable "account_id" {
  type = string
}

variable "env" {
  type = string
}

variable "hostname" {
  type = string
}

variable "path_scalr_dir" {
  type = string
}

variable "scalr_environment_id" {
  type = string
}

variable "list_of_provider_configurations" {
  type = list(map(string))
}

variable "vcs_provider_id" {
  type = string
}