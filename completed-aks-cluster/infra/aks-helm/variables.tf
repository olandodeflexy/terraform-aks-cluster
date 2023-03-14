#Create Resource Group Location for AKS
variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}


#Create Resource Group Location for Application Gateway
variable "app_gw_resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

#Names of Services
variable "cluster_name" {
  default = "aks-cluster-test"
}



#Service Principal Starts
variable "aks_service_principal_app_id" {
  description = "Application ID/Client ID  of the service principal. Used by AKS to manage AKS related resources on Azure like vms, subnets."
}

variable "aks_service_principal_client_secret" {
  description = "Secret of the service principal. Used by AKS to manage Azure."
}

variable "aks_service_principal_object_id" {
  description = "Object ID of the service principal."
}
#Service Principal Ends


#Node Pool Starts
#Create Predefined Lists
variable "node_pool_names" {
  description = "Node Pools Availability Zones"
  type        = list(string)
  default     = ["aksnpooltest"]
}

#Node Count for each NodePool
variable "agent_count" {
  default = 3
}


variable "node_min_count" {
  description = "Minimum number of nodes in the cluster"
  default     = 3
}

variable "node_max_count" {
  description = "Maximum number of nodes in the cluster"
  default     = 10
}

variable "max_pods" {
  description = "Total number of pods that can be started on a kubernetes node  "
  default     = 110
}



####Operational Functions

variable "log_analytics_workspace_name" {
  default = "aks-log-analytics"
}

variable "log_analytics_workspace_location" {
  default = "westeurope"
}

variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}



#Declare DNS

variable "dns_prefix" {
  default = "aks-dns"
}