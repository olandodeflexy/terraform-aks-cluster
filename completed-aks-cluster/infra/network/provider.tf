# Speicify Provider SDK Connection
terraform {
  required_version = ">=0.4.0"
  
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       # version = "~>3.42.0"
#     }
#   }

    #Configure Remote State - Backend - on Azure Storage Account in a separate location away from resources
  # backend "azurerm" {
  #   resource_group_name  = "mec-tfstates-rg"
  #   storage_account_name = "vnetremotestate"
  #   container_name       = "tftstatevnetdev01"
  #   key                  = "vnet_dev.tfstate"
  # }
}

# provider "azurerm" {
#   features {}
# }


