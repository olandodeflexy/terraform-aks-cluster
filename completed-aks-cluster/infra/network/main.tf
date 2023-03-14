
#Create Resource Group for AKS Cluster
resource "azurerm_resource_group" "vnet-dev-eus-rg" {
  name     = "vnet-dev-eus-rg"
  location = var.resource_group_location
}