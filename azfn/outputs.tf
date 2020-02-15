output "function_key" {
  value = "${lookup(azurerm_template_deployment.azfn_function_keys.outputs, "functionkey")}"
}

output "hostname" {
    value = "${azurerm_function_app.function_app.default_hostname}"
}