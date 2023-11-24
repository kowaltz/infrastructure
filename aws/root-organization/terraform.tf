terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.16.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}