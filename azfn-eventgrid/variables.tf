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
variable "keyvault_id" {    
    type = "string"
    description = "The Key Vault to store endpoint details into"
}