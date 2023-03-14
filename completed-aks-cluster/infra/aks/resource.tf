locals {

  prefix    = var.prefix
  sp_name   = "${var.prefix}-sp"
  location  = var.resource_group_location
}

data "azurerm_subnet" "subnet" {
  name                 = var.network_subnet
  virtual_network_name = var.network_vnet
  resource_group_name  = var.netwok_resource_group
}

resource "local_file" "kubeconfig_file" {
  content  = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  filename = "${azurerm_kubernetes_cluster.aks-cluster.name}_config"
}