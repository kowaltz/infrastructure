variable "directory" {
  type = string
  default = "infrastructure"
}

variable "organization" {
  type = string
  default = "kowaltz"
}

variable "repository" {
  type = string
  default = "monorepo"
}

variable "set_of_clouds" {
  type = set(string)
  default = ["aws", "azure"]
}

variable "set_of_environments" {
  type = set(string)
  default = ["dev", "prod"]
}

variable "terraform_version" {
  type = string
  default = "1.5.7"
}