
# This will deploy an Azure Function to the target Resource Group / App Service Plan
resource "azurerm_function_app" "function_app" {
  name                      = "${var.name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${var.app_service_plan_id}"
  storage_connection_string = "${var.storage_connection_string}"
  version                   = "${var.azure_function_version}"

  app_settings = "${var.app_settings}"

}

# This will obtain the Azure Function's Key that can be used to integrate with the Azure Function by API Management
resource "azurerm_template_deployment" "function_keys" {
  name = "${var.name}-key-rgt"
  parameters = {
    "functionApp" = "${azurerm_function_app.function_app.name}"
  }
  resource_group_name    = "${var.resource_group_name}"
  deployment_mode = "Incremental"

  template_body = <<BODY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
          "functionApp": {"type": "string", "defaultValue": ""}
      },
      "variables": {
          "functionAppId": "[resourceId('Microsoft.Web/sites', parameters('functionApp'))]"
      },
      "resources": [
      ],
      "outputs": {
          "functionkey": {
              "type": "string",
              "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').functionKeys.default]"
              },              
          "eventGridKey": {
              "type": "string",
              "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').systemKeys.eventgrid_extension]"
              }
      }
  }
  BODY
}