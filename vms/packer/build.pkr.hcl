build {
  name        = local.image_name
  description = <<EOF
This build creates Debian images for the following builders:
* amazon-ebs
* azure-arm DEPRECATED
EOF

  sources = [
    "source.amazon-ebs.ubuntu",
    #"source.azure-arm.debian"
  ]

  /*
  provisioner "ansible" {
    playbook_file = "ansible/upgrade.yml"
    use_proxy     = false
    use_sftp      = true
  }
  The block below offers better visibility.
  */

  provisioner "shell" {
    inline = [
      "echo Installing updates...",
      "sudo apt-get update",
      "sudo apt-get upgrade -y"
    ]
  }

  /*
  # Install Nomad
  provisioner "shell" {
    inline = [
      # Install the required packages
      "sudo apt-get update && sudo apt-get install wget gpg coreutils",
      # Add the HashiCorp GPG key
      "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      # Add the official HashiCorp Linux repository
      "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
      # Update and install
      "sudo apt-get update && sudo apt-get install nomad"
    ]
  }
  */

  # Clean-up: Remove temp files, delete SSH keys, remove "admin" user.
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }} ; rm -f {{ .Path }}"
    inline = [
      "rm --force /root/.ssh/authorized_keys",
      "/usr/sbin/userdel --remove --force admin"
    ]
    skip_clean = true
  }

  post-processor "manifest" {}
}