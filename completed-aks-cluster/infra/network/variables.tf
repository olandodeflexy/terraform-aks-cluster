#Create Resource Group Location for AKS
variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "end_date" {
  description = "The End Date which the Password is valid until, formatted as a RFC3339 date string (e.g. 2018-01-01T01:02:03Z)."
  type        = string
  default     = "2030-01-01T00:00:00Z"
}

variable "prefix" {
  description = "(Required) Base name used by resources (cluster name, main service and others)."
  type        = string
}
