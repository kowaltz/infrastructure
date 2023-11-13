source "azure-arm" "debian" {
  managed_image_name                     = "${local.image_name}"
  location                               = "Central France"
  private_virtual_network_with_public_ip = var.public_ip_bool
  vm_size                                = "B1ls"
  subscription_id                        = var.azure_subscription_id
  managed_image_resource_group_name      = "packer_images"

  os_type           = "Linux"
  image_publisher   = "Debian"            # OpenLogic
  image_offer       = "debian-11"         # CentOS
  image_sku         = "11-backports-gen2" # 8_5-gen2
  skip_create_image = var.skip_create_image
  ssh_username      = var.ssh_username

  azure_tags = {
    Created-by      = "Packer"
    Base_Image_Name = "11-backports-gen2"
    OS_Version      = "Debian 11"
    Release         = var.release_tag
  }
}
