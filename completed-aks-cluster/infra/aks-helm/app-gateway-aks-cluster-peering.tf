resource "azurerm_virtual_network_peering" "app-gw-vnet-to-aks-vnet" {
  name                      = "app-gw-vnet-peer-to-aks-vnet-test"
  resource_group_name       = azurerm_resource_group.app-gw-cluster-rg.name
  virtual_network_name      = azurerm_virtual_network.app-gw-virtual-network.name
  remote_virtual_network_id = "/subscriptions/46081af3-7258-44cd-899c-db7516f0a121/resourceGroups/MC_aks-cluster-rg-test_aks-cluster-test_westeurope/providers/Microsoft.Network/virtualNetworks/aks-vnet-11552782"
  #azurerm_virtual_network.aks-vnet-11552782.id
}

resource "azurerm_virtual_network_peering" "aks-vnet-peer-to-app-gw-vnet" {
  name                      = "aks-vnet-peer-to-app-gw-vnet"
  resource_group_name       = "MC_aks-cluster-rg-test_aks-cluster-test_westeurope"
  virtual_network_name      = "aks-vnet-11552782"
  remote_virtual_network_id = azurerm_virtual_network.app-gw-virtual-network.id


}