terraform {
  required_version = ">= 1.3.0"
  required_providers {
    xelon = {
      source  = "Xelon-AG/xelon"
      version = ">= 1.0.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
