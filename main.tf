terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  s3_use_path_style           = true

  # Point every AWS service you plan to use to Floci
  endpoints {
    s3             = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    iam            = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
  }
}

# Example Resource: Create a local S3 bucket
resource "aws_s3_bucket" "local" {
  bucket = "local.bucket_name"

  tags = {
    Name        = "local.bucket_name"
    Environment = "var.environment"
   

  }
}

output "created_bucket_arn" {
value = aws_s3_bucket.local.arn
}

resource "aws_s3_bucket" "app_buckets" {
  for_each = var.bucket-purposes
  bucket = "${local.name_prefix}-${each.key}"


tags = {
  Purpose = each.key
  Environment = var.environment
}
}
resource "aws_instance" "firstserver" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name        = "My First Server"
    Environment = "Local"
    Project     = "Floci-Testing"
    ManagedBy   = "Terraform"
  }
}

output "ami_id" {
  description = "Ami Id for Firs Server"
  value       = aws_instance.firstserver.ami
}

resource "aws_security_group" "web_sg" {
  name        = "allow-web-traffic"
  description = "Allow HTTP and SSH Traffic"


  # Incoming Traffic Rules

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outgoing Traffic Rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-Server-SG"
  }

}

locals {
  name_prefix = "${var.application_name}-${var.environment}"
  bucket_name = "${local.name_prefix}-data-bucket"
}