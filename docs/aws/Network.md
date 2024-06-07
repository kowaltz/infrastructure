## VPCs, Subnets, and Security Groups

At least one VPC is created for every environment and region.

At least one subnet is created for every workload. Workloads are specified with their respective CIDR blocks.

At least one or two security groups are created per subnet. One grants public access to the Internet. The other one grants egress only.