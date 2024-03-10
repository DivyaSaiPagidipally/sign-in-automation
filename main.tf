terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

terraform{
  required_version = ">= 0.12"
  backend "s3" {
    bucket= "3terraform-2demo-1automation"
    key= "path/to/state.tf"
    region= "us-east-1"
  }
}


provider "aws" {
  region     = "us-east-1"
  access_key = "AKIATZNLDOGR3LTVBWUC"
  secret_key = "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"
}



// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default= "ssh_key"
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name

  provisioner "local-exec" {
    command = "chmod 400 ${var.key_name}"
  }
}

# Create a security group
resource "aws_security_group" "sg_ec2_demo" {
  name        = "sg_ec2_demo"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2_demo.id]

  tags = {
    Name = "public_instance"
  }
  
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'EC2 instance is ready.'"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = tls_private_key.rsa_4096.private_key_pem
    }
  }
}


data "template_file" "inventory" {
  template = <<-EOT
    [ec2_instances]
    ${aws_instance.public_instance.public_ip} ansible_user=ubuntu ansible_private_key_file=${path.module}/${var.key_name}
    EOT
}

resource "local_file" "dynamic_inventory" {
  depends_on = [aws_instance.public_instance]

  filename = "dynamic_inventory.ini"
  content  = data.template_file.inventory.rendered

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.dynamic_inventory.filename}"
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.dynamic_inventory]

  provisioner "local-exec" {
    command = "ansible-playbook -i dynamic_inventory.ini deploy-app.yml"
    working_dir = path.module
  }
}
