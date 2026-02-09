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
  ami_name      = "my-custom-nginx"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0028af9e4c352ac53"
  ssh_username  = "ubuntu"
}

# Build Block

build {
  name   = "learn-packer"
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