variable "aws_account_id_infrastructure_env_network" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_role_name" {
  type = string
}

variable "env" {
  type = string
}

variable "organization" {
  type = string
  default = "kowaltz"
}

variable "map_of_workloads_cidr_blocks_and_account_ids" {
  type    = map(map(string))
  /* Example:
  {
    workloadid1 = {
      cidr = "10.0.1.0/25"
      account_id = "123456789012"
    },
    workloadid2 = {
      cidr = "10.0.3.0/24"
      account_id = "123456789013"
    }
  }*/
}