terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.5.0"
    }

    http = {
      source = "hashicorp/http"
      version = "3.4.0"
    }
  }
}