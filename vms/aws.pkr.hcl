data "amazon-ami" "debian_11" {
  filters = {
    name                = "debian-11-amd64-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners = [var.aws_account_id]
}


source "amazon-ebs" "debian" {
  ami_name                    = "${local.image_name}"
  ami_regions                 = var.ami_regions
  associate_public_ip_address = var.public_ip_bool
  encrypt_boot                = true
  instance_type               = "t2.micro"
  kms_key_id                  = var.build_region_kms

  source_ami         = data.amazon-ami.debian_11.id
  region             = var.build_region
  region_kms_key_ids = var.region_kms_keys
  skip_create_ami    = var.skip_create_image
  ssh_username       = var.ssh_username

  # Many Linux distributions are now disallowing the use of RSA keys,
  # so it makes sense to use an ED25519 key instead.
  temporary_key_pair_type = "ed25519"

  # Tags for searching for the image
  subnet_filter {
    filters = {
      "tag:Name" = "AMI Vault"
    }
  }
  vpc_filter {
    filters = {
      "tag:Name" = "AMI Vault"
    }
  }

  tags = {
    Application        = "Debian"
    Base_Image_Name      = data.amazon-ami.debian_11.name
    Created-by = "Packer"
    OS_Version         = "Debian 11"
    Release            = var.release_tag
    Team               = "Kowaltz Engineering"
  }
}