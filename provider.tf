terraform {
  required_version = ">= 1.3.0"
  required_providers {
    xelon = {
      source  = "Xelon-AG/xelon"
      version = ">= 1.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.3"
    }
    gitfile = {
      source  = "igal-s/gitfile"
      version = "1.0.0"
    }
  }
}

provider "xelon" {
  token     = var.xelon_token
  client_id = var.xelon_client_id
}
