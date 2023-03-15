terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.16.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.2"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "1.2.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}
provider "cloudinit" {
}
# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  bootstrap = true
}
provider "rancher2" {
  alias = "admin"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = rancher2_bootstrap.admin.token
  timeout   = "300s"
}