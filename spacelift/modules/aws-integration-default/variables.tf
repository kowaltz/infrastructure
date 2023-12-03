variable "account_id" {
  type = string
}

variable "organization" {
  type = string
}

variable "role_path" {
  type = string
}

variable "space_id" {
  type = string
}

variable "space_short_id" {
  type = string
}

variable "stack_short_name" {
  type = string
}

variable "stack_id" {
  type = string
}

variable "read" {
  type    = bool
  default = true
}

variable "write" {
  type    = bool
  default = false
}