terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.53.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.12.0"
    }
  }
}