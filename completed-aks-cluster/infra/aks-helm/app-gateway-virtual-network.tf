##############################################
# Configuring Networking
##############################################

#Create app-gw Virtual Network for Node node-pools
resource "azurerm_virtual_network" "app-gw-virtual-network" {
  name                = "app-gw-virtual-network-test"
  location            = azurerm_resource_group.app-gw-cluster-rg.location
  resource_group_name = azurerm_resource_group.app-gw-cluster-rg.name
  address_space       = ["10.20.0.0/16"]
  tags = {

    environment = "Application Gateway Virtual Network"
  }

}

#Create Kubernetes Service Subnet for Node Pools [Worker Nodes]
resource "azurerm_subnet" "app-gw-subnet" {
  name                 = "app-gw-subnet-test"
  virtual_network_name = azurerm_virtual_network.app-gw-virtual-network.name
  resource_group_name  = azurerm_resource_group.app-gw-cluster-rg.name
  address_prefixes     = ["10.20.0.0/24"]
}

data "azurerm_subnet" "app-gw-subnet" {
  name                 = "app-gw-subnet-test"
  virtual_network_name = azurerm_virtual_network.app-gw-virtual-network.name
  resource_group_name  = azurerm_resource_group.app-gw-cluster-rg.name
  depends_on           = [azurerm_subnet.app-gw-subnet]
}