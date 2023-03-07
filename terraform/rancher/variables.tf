variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id under which resources will be provisioned"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client id used to create resources"
}

variable "azure_client_secret" {
  type        = string
  description = "Client secret used to authenticate with Azure apis"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id used to create resources"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher"
}

variable "azure_location" {
  type        = string
  description = "Azure location used for all resources"
  default     = "East US"
}

locals {
  node_username = "azureuser"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "Standard_DS2_v2"
}

variable "cluster_token" {
  type        = string
  description = "The token for cluster joining in RKE2"
  default     = "mysharedtoken"
}

variable "rancher_server_dns" {
  type        = string
  description = "The DNS entry for rancher server"
  default     = "rancher.lol"
}

variable "rke2_version" {
  type        = string
  description = "The RKE2 version to install"
  default     = "v1.24.9+rke2r1"
}

variable "worker_count" {
  type        = number
  description = "The amount of worker nodes to create"
  default     = 3
}