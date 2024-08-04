output "vpc_id" {
  value = aws_vpc.env-default.id
}

output "map_of_subnet_ids" {
  value = { for details in local.account_network_details : 
    "${details.ou_name}_${details.account_name}" => aws_subnet.env-public[details].id
  }
}

output "map_of_security_group_ids" {
  value = { for details in local.account_network_details :
    "${details.ou_name}_${details.account_name}" => [
      for sg in details.security_groups : aws_security_group.env[sg].id
    ]
  }
}