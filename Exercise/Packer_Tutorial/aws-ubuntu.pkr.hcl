# Necessary Plugins

packer {
    required_plugins {
      amazon = {
        version = ">=1.2.8"
        source = "github.com/hashicorp/amazon"
      }
    }
}

# Source of the base image

source "amazon-ebs" "my-custom-ubuntu" {
    ami_name        = "my-custom"
    instance_type   = "t2.micro"
    region          = "us-east-1"
    source_ami      = "ami-0005a7fa4210bc7a8"
    ssh_username    = "ubuntu"
}

# Build Block

build {
    name            = "learn-packer"
    source          = ["source.amazon-ebs.my-custom-ubuntu"]
}
