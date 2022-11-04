terraform {
  required_providers {
    basistheory = {
      source  = "basis-theory/basistheory"
      version = ">= 0.5.0"
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

resource "basistheory_reactor_formula" "card_tokenizer_formula" {
  name        = "Card Tokenizer Formula"
  description = "Receives card from Twilio and tokenizes it"
  type        = "private"
  icon        = "data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=="
  code        = file("./card-tokenizer.js")
}

resource "basistheory_reactor" "card_tokenizer_reactor" {
  name           = "Card Tokenizer Reactor"
  formula_id     = basistheory_reactor_formula.card_tokenizer_formula.id
  application_id = basistheory_application.card_tokenizer_application.id
}

resource "basistheory_proxy" "inbound_proxy" {
  name               = "My Proxy"
  destination_url    = "https://echo.basistheory.com/anything" // replace this with your API endpoint
  request_reactor_id = basistheory_reactor.card_tokenizer_reactor.id
  require_auth       = false
}

output "inbound_proxy_key" {
  value       = basistheory_proxy.inbound_proxy.key
  description = "Inbound Proxy API Key"
  sensitive   = true
}