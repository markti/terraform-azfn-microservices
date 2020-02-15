output "func_keys" {
  value = "${lookup(azurerm_template_deployment.function_keys.outputs, "functionkey")}"
}
output "eventgrid_key" {
  value = "${lookup(azurerm_template_deployment.azfn_system_keys.outputs, "eventgridKey")}"
}


output "hostname" {
    value = "${azurerm_function_app.function_app.default_hostname}"
}