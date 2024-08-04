variable "env" {
  type = string
}

variable "path_config_yaml" {
  type    = string
  default = "./config.yaml"
}

variable "map_of_security_group_ids" {
  type = map(list(string))
}

variable "map_of_subnet_ids" {
  type = map(string)
}