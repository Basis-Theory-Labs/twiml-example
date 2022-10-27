# TwiML Example

This repository shows how to accept incoming requests from Twilio and tokenize sensitive data (card number) from user input using [Basis Theory Proxy](https://docs.basistheory.com/#proxy).

1. TwiML will make a request via Webhook:

```shell
curl "https://api.basistheory.com/proxy?bt-proxy-key={{inbound_proxy_key}}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X "POST" \
  -d 'AccountSid=....&Digits=4242424242424242&...'
```

2. Basis Theory Proxy will tokenize the card number and call the destination URL:
```shell
curl "https://echo.basistheory.com/anything" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X "POST" \
  -d 'AccountSid=....&Digits=26818785-547b-4b28-b0fa-531377e99f4e&...'
```

3. Basis Theory Proxy will return the destination URL response to Twilio.

## Run this POC

[Create a new Management Application](https://portal.basistheory.com/applications/create?name=Terraform&permissions=application%3Acreate&permissions=application%3Aread&permissions=application%3Aupdate&permissions=application%3Adelete&permissions=reactor%3Acreate&permissions=reactor%3Aread&permissions=reactor%3Aupdate&permissions=reactor%3Adelete&type=management) with full `application` and `reactor` permissions.

Paste the API key to a new `secret.tfvars` file at this repository root:

```terraform
management_api_key = "key_W8wA8CmcbwXxJsomxeWHVy"
```

Initialize Terraform:

```shell
terraform init
```

And run Terraform to provision all the required resources:

```shell
terraform apply -var-file=secret.tfvars
```

Use the `inbound_proxy_key` Terraform output to generate the TwiML Webhook URL: `https://api.basistheory.com/proxy?bt-proxy-key={{inbound_proxy_key}}`.

