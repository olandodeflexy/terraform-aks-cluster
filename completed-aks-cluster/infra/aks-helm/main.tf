
#Create Resource Group for AKS Cluster
resource "azurerm_resource_group" "aks-cluster-rg" {
  name     = "aks-cluster-rg-test"
  location = var.resource_group_location
}

#Create Resource Group for Application Gateway
resource "azurerm_resource_group" "app-gw-cluster-rg" {
  name     = "app-gw-cluster-rg-test"
  location = var.resource_group_location
}

###########Operational Functions - Azure Starts###########

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}



####Create Work Analytics Workspace


resource "azurerm_log_analytics_workspace" "aks-log-analytics" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
  sku                 = var.log_analytics_workspace_sku
}

####Create ContainerInsights for Log Analytics
resource "azurerm_log_analytics_solution" "aks-container-insights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.aks-log-analytics.location
  resource_group_name   = azurerm_resource_group.aks-cluster-rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.aks-log-analytics.id
  workspace_name        = azurerm_log_analytics_workspace.aks-log-analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  ###########Operational Functions - Azure Ends###########
}


# ArgoCD Deployment
resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  cleanup_on_fail  = true
  chart = "argo-cd"
  namespace = "argocd"
    set {
    name  = "argocd.server.service.type"
    value = "LoadBalancer"
  }
}

resource "kubernetes_service" "argocd" {
  metadata {
    name = "argocd-server"
    labels = {
      app = "argocd-server"
    }
  }

  spec {
    selector = {
      app = "argocd-server"
    }

    port {
      name = "http"
      port = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "null_resource" "kubectl" {
  depends_on = [azurerm_kubernetes_cluster.aks-cluster]
}


