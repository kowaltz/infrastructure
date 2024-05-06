# VMs

## Instance types and regions

Certain instance types are not available in certain regions.
Selection of the build region should take this restriction into account.

Once built in any region,
the AMI can be pushed to other regions by configuration of the ami_regions variable.
However, it must be supported in the other regions.