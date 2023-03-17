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
  }
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = "rancher-bigbang"
    storage_account_name = "rgsazurestore"
    container_name       = "tfstate"
    key                  = "rancher.terraform.tfstate"
  }
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