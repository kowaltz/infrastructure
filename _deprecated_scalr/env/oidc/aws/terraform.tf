terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
    
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}