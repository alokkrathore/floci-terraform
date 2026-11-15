variable "ami_id" {
  description = "AMI ID for EC2 Server"
  type = string
  default = "ami-12345"
}

variable "instance_type"{
    description = "Instance type for EC2 Server"
    type = string
    default = "t2.micro"
}

variable "application_name" {
    description = "Application Name"
    type = string
    default = "Flociapp"
}

variable "environment"{
    description = "Environment name (dev, test, prod)"
    type = string
    
}

variable "bucket-purposes" {
    type = set(string)
    default = ["logs", "data", "backups"]
}
