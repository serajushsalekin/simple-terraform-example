terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "aws region"
  type = string
}

# variable "vpc_cidr_block" {
#   description = "vpc cidr block"
#   type = string
# }

# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
#   default = "10.10.0.0/24"
#   type = string
# }

variable "cidr_blocks" {
  description = "cidr blocks and name tags for vpc and subnets"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block

  tags = {
    Name = var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "ap-south-1a"

  tags = {
    Name = var.cidr_blocks[1].name
  }

}

data "aws_vpc" "existing-vpc" {
  default = true
}

resource "aws_subnet" "default-subnet-4" {
  vpc_id = data.aws_vpc.existing-vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "ap-south-1a"

    tags = {
      "Name" = "default-subnet-4"
    }
}


# resource "aws_instance" "MyAmazonEC2" {
#   ami = "ami-090fa75af13c156b4" #amazon linux 2
#   instance_type = "t2.micro"
#   tags = {
#     "Name" = "MyAmazonEC2"
#   }
# }