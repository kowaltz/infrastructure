variable "organization" {
  type = string
  default = "kowaltz"
}

variable "set_of_environments" {
  type = set(string)
  default = toset(["dev", "prod"])
}