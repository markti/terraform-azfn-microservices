
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
resource "azurerm_template_deployment" "azfn_function_keys" {
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
              }
      }
  }
  BODY
}

/*
data "external" "azfn_system_key" {
	program = ["bash", "-c", "az rest --method post --uri ${var.resource_group_name}/providers/Microsoft.Web/sites/${azurerm_function_app.function_app.name}/host/default/listKeys?api-version=2018-11-01 --query systemKeys"]

	depends_on = [
		azurerm_function_app.function_app
	]
}
*/

/*
data "external" "hostKey" {
	program = ["bash", "-c", "az rest --method post --uri ${azurerm_resource_group.storage_service.id}/providers/Microsoft.Web/sites/${azurerm_function_app.function.name}/host/default/listKeys?api-version=2018-11-01 --query systemKeys"]

	depends_on = [
		azurerm_function_app.function
	]
}*/

/*
resource "azurerm_template_deployment" "azfn_system_keys" {
  name = "${var.name}-systemkey-rgt"
  parameters = {
    "functionApp" = "${azurerm_function_app.function_app.name}"
  }
  resource_group_name    = "${var.resource_group_name}"
  deployment_mode = "Incremental"
  
  template_body   = <<BODY
  {
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "functionApp": {"type": "string", "defaultValue": ""}
    },
    "variables": {
      "functionAppId": "[resourceId('Microsoft.Web/sites', parameters('functionApp'))]"
    },
    "resources": [],
    "outputs": {
      "eventgridKey": {
        "type": "string",
        "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').systemKeys.eventgridKey]"
      }
    }
  }
  BODY
}*/