output "vpc_id" {
  value = aws_vpc.env-default.id
}

output "subnet_ids" {
  value = [
    for details in local.account_network_details : {
      account_fullname = "${details.ou_name}_${details.account_name}"
      subnet_id    = aws_subnet.workload-env-public[details].id
    }
  ]
}