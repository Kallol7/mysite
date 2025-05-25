terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.112.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-subnet-tf"
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "AppServer-tf"
  }
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    encrypted             = false

    tags = {
      Name = "MyEbsVolume-tf"
    }
  }
  credit_specification {
    cpu_credits = "standard"
  }
}

# resource "aws_s3_bucket" "s3_bucket" {
#   bucket        = "kallol-s3-bucket-2025"
#   force_destroy = true

#   tags = {
#     Name = "MyS3Bucket-tf"
#   }
# }
