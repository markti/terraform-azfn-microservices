output "function_key" {
  value = "${lookup(azurerm_template_deployment.azfn_function_key.outputs, "functionkey")}"
}

output "eventgrid_key" {
  value = "${lookup(azurerm_template_deployment.azfn_function_egkey.outputs, "eventgridKey")}"
}

output "hostname" {
    value = "${azurerm_function_app.function_app.default_hostname}"
}