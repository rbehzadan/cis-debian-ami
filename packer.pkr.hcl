packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "debian" {
  ami_name        = "cis-hardened-debian12-amd64-{{timestamp}}"
  instance_type   = "t3.micro"
  region          = var.region
  ssh_username    = "admin"

  source_ami_filter {
    filters = {
      name                = "debian-12-amd64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["136693071363"] # Official Debian AMI publisher
    most_recent = true
  }
}

build {
  name    = "cis-debian12-ami"
  sources = ["source.amazon-ebs.debian"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
  }
}

