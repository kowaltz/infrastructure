packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}


source "amazon-ebs" "ubuntu" {
  ami_name                    = local.image_name
  ami_regions                 = var.ami_regions
  associate_public_ip_address = var.public_ip_bool
  encrypt_boot                = true
  instance_type               = local.instance_type
  kms_key_id                  = var.build_region_kms

  source_ami         = data.amazon-ami.ubuntu.id
  region             = var.build_region
  region_kms_key_ids = var.region_kms_keys
  skip_create_ami    = var.skip_create_image
  ssh_username       = "ubuntu"

  # Many Linux distributions are now disallowing the use of RSA keys,
  # so it makes sense to use an ED25519 key instead.
  temporary_key_pair_type = "ed25519"

  # Tags for searching for the image
  tags = {
    Base_Image_Name = data.amazon-ami.ubuntu.name
    OS_Version      = local.os_name
    Release         = var.release_tag
  }
}