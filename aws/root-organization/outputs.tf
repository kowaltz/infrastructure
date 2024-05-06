output "aws_account_id_root" {
  value = var.aws_account_id
  sensitive = true
}

output "aws_region" {
  value = var.aws_region
}

output "aws_account_id_infrastructure_env_vms" {
  value = { for env in var.set_of_environments :
    env => module.aws_account_infrastructure_env_vms[env].id
  }
  sensitive = true
}

output "aws_account_id_infrastructure_env_network" {
  value = { for env in var.set_of_environments :
    env => module.aws_account_infrastructure_env_network[env].id
  }
  sensitive = true
}