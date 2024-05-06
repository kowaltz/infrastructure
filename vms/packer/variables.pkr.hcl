# Locals
locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  
  architecture = "amd64"
  os_family = "ubuntu"
  os_name = "${local.os_family}-jammy-22.04"
  image_name = "${local.os_name}-hvm-${local.timestamp}-${local.architecture}"

  instance_type = "t3.micro"
}

# Common Variables
variable "public_ip_bool" {
  default     = false
  description = "Whether to associate a public IP to the image."
  type        = bool
}

variable "release_tag" {
  default     = ""
  description = "The GitHub release tag to use for the tags applied to the created AMI."
  type        = string
}

variable "skip_create_image" {
  default     = true
  description = "Indicate if Packer should not create the AMI. Default is true to prevent unwanted resource creation."
  type        = bool
}

# AWS Variables
variable "ami_regions" {
  default     = []
  description = "The list of AWS regions to copy the AMI to once it has been created. Example: [\"us-east-1\"]"
  type        = list(string)
}

variable "aws_account_id" {
  default     = ""
  description = "AWS Account ID. Not necessarily sensitive."
  type        = string
}

variable "build_region" {
  default     = "eu-south-2"
  description = "The region in which to retrieve the base AMI from and build the new AMI."
  type        = string
}

variable "build_region_kms" {
  default     = "alias/cool-amis"
  description = "The ID or ARN of the KMS key to use for AMI encryption."
  type        = string
}

variable "region_kms_keys" {
  default     = {}
  description = "A map of regions to copy the created AMI to and the KMS keys to use for encryption in that region. The keys for this map must match the values provided to the aws_regions variable. Example: {\"us-east-1\": \"alias/example-kms\"}"
  type        = map(string)
}
