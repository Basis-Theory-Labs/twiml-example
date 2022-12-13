terraform {
  required_providers {
    basistheory = {
      source  = "basis-theory/basistheory"
      version = ">= 0.7.0"
    }
  }
}

variable "management_api_key" {}

provider "basistheory" {
  api_key = var.management_api_key
}

resource "basistheory_application" "card_tokenizer_application" {
  name        = "Card Tokenizer Application"
  type        = "private"
  permissions = [
    "token:create",
  ]
}

resource "basistheory_proxy" "inbound_proxy" {
  name               = "My Proxy"
  destination_url    = "https://echo.basistheory.com/anything" // replace this with your API endpoint
  require_auth       = false
  request_transform  = {
    code = file("./card-tokenizer.js")
  }
  application_id = basistheory_application.card_tokenizer_application.id
}

output "inbound_proxy_key" {
  value       = basistheory_proxy.inbound_proxy.key
  description = "Inbound Proxy API Key"
  sensitive   = true
}