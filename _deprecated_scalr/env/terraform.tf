terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }

    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "~> 1.4.0"
    }
    
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}