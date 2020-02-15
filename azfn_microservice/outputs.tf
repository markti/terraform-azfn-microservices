output "api_name" {
    value = "${azurerm_api_management_api.apim_api.name}"
}
output "backend_name" {
    value = "${azurerm_api_management_backend.apim_backend.name}"
}