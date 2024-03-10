terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # define region as per your account
}

resource "aws_instance" "sign-in-demo-terraform-automation" {
  # Which virtual machine image this VM should be based on
  ami = "ami-07d9b9ddc6cd8dd30"
  # How much hardware resources does this instance need
  instance_type = "t2.micro"
  # What commands should be executed when the VM boots
  user_data = file("install.sh")
  # The ssh key pair to apply to this virtual machine
  key_name = "connect-demo-terraform"
  # Required for network setup
  security_groups = ["demo-terraform"]
}
