
module "azfn" {

	source                              = "../azfn"
	name                                = "${var.name}"
	resource_group_name                 = "${var.resource_group_name}"
	location                            = "${var.location}"
  app_service_plan_id                 = "${var.app_service_plan_id}"
	storage_connection_string           = "${var.storage_connection_string}"
  azure_function_version              = "${var.azure_function_version}"
  app_settings                        = "${var.app_settings}"
	
}

resource "azurerm_api_management_api" "apim_api" {
  name                = "${var.name}-api"
  resource_group_name = "${var.resource_group_name}"
  api_management_name = "${var.apim_name}"
  revision            = "1"
  display_name        = "${var.api_display_name}"
  path                = "${var.api_path}"
  protocols           = ["https"]
}


resource "azurerm_api_management_api_policy" "api_policy" {
  api_name            = "${azurerm_api_management_api.apim_api.name}"
  api_management_name = "${var.apim_name}"
  resource_group_name = "${var.resource_group_name}"

  xml_content = <<XML
<policies>
  <inbound>
    <set-backend-service id="tf-generated-policy" backend-id="${azurerm_api_management_backend.apim_backend.name}" />
  </inbound>
</policies>
XML
}

# this product is used for all Admin APIs
resource "azurerm_api_management_product_api" "product_api" {
  api_name            = "${azurerm_api_management_api.apim_api.name}"
  product_id          = "${var.apim_product_id}"
  api_management_name = "${var.apim_name}"
  resource_group_name = "${var.resource_group_name}"
}

# this product is used for all User APIs
resource "azurerm_api_management_backend" "apim_backend" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  api_management_name = "${var.apim_name}"
  protocol            = "http"
  url                 = "https://${module.azfn.hostname}/api"

  credentials {
        header              = {
        "x-functions-key" = "${azurerm_api_management_property.apim_prop_azfn_key.value}",
        }
  }
}

resource "azurerm_api_management_property" "apim_prop_azfn_key" {
  name                = "${var.name}-key"
  resource_group_name = "${var.resource_group_name}"
  api_management_name = "${var.apim_name}"
  display_name        = "${var.name}-key"
  value               = "${module.azfn.function_key}"
  secret              = "true"
}
