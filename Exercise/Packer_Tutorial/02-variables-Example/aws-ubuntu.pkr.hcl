# Necessary Plugins

packer {
  required_plugins {
    amazon = {
      version = ">=1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Source of the base image

source "amazon-ebs" "my-custom-ubuntu" {
  ami_name      = var.ami_name
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters ={
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username  = var.ssh_username
}

# Build Block

build {
  name   = "dev-image-building"
  sources = ["source.amazon-ebs.my-custom-ubuntu"]
/*
  provisioner "shell" {
    inline = [
      "echo Installing redis",
      "sleep 10"
      "sudo apt update",
      "sudo apt install -y redis-server",
    ]
  }
*/
  provisioner "shell" {
    script = "scripts/setup.sh"
  }

  provisioner "file" {
    source = "Files/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "echo copying files",
      "sudo cp /tmp/index.html /var/www/html/",
    ]
  }
}