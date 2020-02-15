output "function_key" {
  value = "${lookup(azurerm_template_deployment.azfn_function_keys.outputs, "functionkey")}"
}
output "system_key" {
  value = "${data.external.azfn_system_key.result.eventgrid_extension}"
}

output "hostname" {
    value = "${azurerm_function_app.function_app.default_hostname}"
}