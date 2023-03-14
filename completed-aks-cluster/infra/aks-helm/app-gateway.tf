# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.app-gw-virtual-network.name}-backend-pool"
  frontend_port_name             = "${azurerm_virtual_network.app-gw-virtual-network.name}-frontend-port"
  frontend_ip_configuration_name = "${azurerm_virtual_network.app-gw-virtual-network.name}-frontend-ip"
  http_setting_name              = "${azurerm_virtual_network.app-gw-virtual-network.name}-http-listening"
  listener_name                  = "${azurerm_virtual_network.app-gw-virtual-network.name}-https-listening"
  request_routing_rule_name      = "${azurerm_virtual_network.app-gw-virtual-network.name}-request-routing-rule"
}

# Public Ip 
resource "azurerm_public_ip" "app-gw-publicip" {
  name                = "app-gw-publicip-test"
  location            = azurerm_resource_group.app-gw-cluster-rg.location
  resource_group_name = azurerm_resource_group.app-gw-cluster-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app-gw" {
  name                = "app-gw-test"
  resource_group_name = azurerm_resource_group.app-gw-cluster-rg.name
  location            = azurerm_resource_group.app-gw-cluster-rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "app-gw-publicip-test"
    subnet_id = data.azurerm_subnet.app-gw-subnet.id #Review this at the moment
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app-gw-publicip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  depends_on = [azurerm_virtual_network.app-gw-virtual-network, azurerm_public_ip.app-gw-publicip]


}


