data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = [var.aws_account_id]
}


source "amazon-ebs" "ubuntu" {
  ami_name                    = "${local.image_name}"
  ami_regions                 = var.ami_regions
  associate_public_ip_address = var.public_ip_bool
  encrypt_boot                = true
  instance_type               = "t2.micro"
  kms_key_id                  = var.build_region_kms

  source_ami         = data.amazon-ami.ubuntu.id
  region             = var.build_region
  region_kms_key_ids = var.region_kms_keys
  skip_create_ami    = var.skip_create_image
  ssh_username       = var.ssh_username

  # Many Linux distributions are now disallowing the use of RSA keys,
  # so it makes sense to use an ED25519 key instead.
  temporary_key_pair_type = "ed25519"

  # Tags for searching for the image
  tags = {
    Base_Image_Name = data.amazon-ami.ubuntu.name
    OS_Version      = local.os
    Release         = var.release_tag
  }
}