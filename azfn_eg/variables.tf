variable "name" {
    type = "string"
    description = "The name used for the Azure Function Resource"
}
variable "location" {    
    type = "string"
    description = "The Azure Region to deploy into"
}
variable "resource_group_name" {    
    type = "string"
    description = "The Azure Resource Group to deploy into"
}
variable "app_service_plan_id" {    
    type = "string"
    description = "The Azure App Service Plan to deploy into"
}
variable "storage_connection_string" {    
    type = "string"
    description = "The Azure Blob Storage Account to be used by the Azure Function for diagnostics"
}
variable "azure_function_version" {    
    type = "string"
    description = "The version of Azure Functions you want to use"
}
variable "app_settings" {
    description = "An array of properties to pass into the Azure Function for its app settings collection"
}