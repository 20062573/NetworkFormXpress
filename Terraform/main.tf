terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.0"
}

# ---------- Provider ----------
provider "aws" {
  region = var.aws_region
}

# ---------- Security Group ----------
resource "aws_security_group" "formsub_sg" {
  name        = "formsub-sg"
  description = "Allow SSH and HTTP access for form submission app"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "formsub-sg"
  }
}

# ---------- EC2 Instance ----------
resource "aws_instance" "formsub_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.formsub_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              EOF

  tags = {
    Name = "FormSubServer"
  }
}

# ---------- Outputs ----------
output "instance_public_ip" {
  description = "Public IP of the deployed instance"
  value       = aws_instance.formsub_instance.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.formsub_instance.id
}

# ---------- Variables ----------
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-west-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0ef0fafba270833fc"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
  default     = "FormSubKeyPair"
}
