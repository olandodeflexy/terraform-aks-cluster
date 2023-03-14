
# Create (and display) an SSH key
resource "tls_private_key" "aksvmshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}




####Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks-cluster-rg.location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = tls_private_key.aksvmshkey.public_key_openssh

    }
  }

  ####Create AKS Cluster Master [System] Node
  default_node_pool {
    name       = "test"
    node_count = 1
    vm_size    = "Standard_D2_v2" #Specify Good Compute Size for Cluster Master

  }


  ###Service Principal Starts
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }

  #Enable Azure Policy
  azure_policy_enabled = true

  #CNI
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Development"
  }
  ###Service Principal Ends


  #This configures the AKS Cluster to use the Application Gateway
  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.app-gw.id
  }
  depends_on = [
    azurerm_virtual_network.app-gw-virtual-network,
    azurerm_application_gateway.app-gw
  ]
}

#Create Node Pools with Predefined Variable Lists - Set Count based on List length(s)
resource "azurerm_kubernetes_cluster_node_pool" "aks-node-pool" {
  name                  = var.node_pool_names[count.index]
  availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
  vm_size               = "standard_a2_v2" #"Standard_B1s"   #"Standard_D2_v2"
  os_disk_size_gb       = 30               # decide on disk sizes later.
  node_count            = var.agent_count  # set it to 2 for production
  min_count             = var.agent_count
  max_count             = var.node_max_count
  orchestrator_version  = "1.23.8"
  os_sku                = "Ubuntu"
  count                 = length(var.node_pool_names)

  tags = {
    Environment = "Node Pools - ${var.node_pool_names[count.index]}"
  }

}
##End of Node Pool Creation

