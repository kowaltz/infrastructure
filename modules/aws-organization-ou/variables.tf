variable "name" {
  type = string
}

variable "organization" {
  type = string
}

variable "parent_id" {
  type = string
}

variable "set_of_accounts" {
  type = set(string)
}

variable "set_of_environments" {
  type = set(string)
}

variable "unique_identifier" {
  type = string
}