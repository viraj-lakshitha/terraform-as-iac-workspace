1. Getting started terraform script

- Create EC2 instance ap-south-1 region with use of given profile.

```terraform
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "personal-tf" # Profile configured for the terraform
}

# Where to find AMI: https://ap-south-1.console.aws.amazon.com/ec2/home?region=ap-south-1#LaunchInstances:
resource "aws_instance" "example_instance" {
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.nano"
}
```