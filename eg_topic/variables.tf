variable "name" {
    description = "The name used for the Azure Function Resource"
}
variable "keyvault_keyname" {
    description = "The name used for the Key Vault Prefix"
}
variable "location" {    
    description = "The Azure Region to deploy into"
}
variable "resource_group_name" {    
    description = "The Azure Resource Group to deploy into"
}
variable "keyvault_id" {    
    description = "The Key Vault to store endpoint details into"
}
variable "tags" {    
    description = "The Key Vault to store endpoint details into"
}