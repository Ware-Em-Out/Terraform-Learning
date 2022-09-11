# This file will let us know which platform we will be working on.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.20.0"
    }
  }
}

provider "azurerm" {
  // Configuration options (i.e. Subscription ID, Tenant ID.)
  subscription_id = "1635b9ea-d00f-4800-aabc-c7dde1c396a3"
  tenant_id       = "8d2e9fbb-af54-4389-9cb3-d447058b1220"
  client_id       = "15c188b9-f156-418a-928a-71d31427808e"
  client_secret   = "N9B8Q~S-YKikdrkb3iVDsH_W4e-bB~Jy~l0dgafg"
  features {}
}

locals {
  // Local variables for our resources will be defined here.
  resource_group_name    = "Terri"
  storage_account_name   = "storeterri"
  storage_container_name = "dataterri"
  storage_blob_name      = "terriblob"
  location               = "East US"
  virtual_network = {
    name          = "terri-vnet"
    address_space = "10.0.0.0/16"
  }
  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.0.0.0/24"
    },
    {
      name           = "subnet2"
      address_prefix = "10.0.1.0/24"
    }
  ]
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "storage" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "container" {
  name                  = local.storage_container_name
  storage_account_name  = local.storage_account_name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob" {
  name                   = local.storage_blob_name
  storage_account_name   = local.storage_account_name
  storage_container_name = local.storage_container_name
  type                   = "Block"
  source                 = "main.tf"
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]

  subnet {
    name           = local.subnets[0].name
    address_prefix = local.subnets[0].address_prefix
  }

  subnet {
    name           = local.subnets[1].name
    address_prefix = local.subnets[1].address_prefix
  }
}