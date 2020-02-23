
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
    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
      <openid-config url="https://${var.b2c_tenant_name}.b2clogin.com/${var.b2c_tenant_name}.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=${var.b2c_policy_name}" />
      <required-claims>
          <claim name="aud">
              <value>${var.b2c_api_client_id}</value>
          </claim>
      </required-claims>
    </validate-jwt>
    <set-header name="${var.bearer_token_header_passthru_prefix}_UID" exists-action="append">
        <value>@(context.Request.Headers["Authorization"].First().Split(' ')[1].AsJwt()?.Claims["oid"].FirstOrDefault())</value>
    </set-header>
    <set-header name="${var.bearer_token_header_passthru_prefix}_EMAIL" exists-action="append">
        <value>@(context.Request.Headers["Authorization"].First().Split(' ')[1].AsJwt()?.Claims["emails"].FirstOrDefault())</value>
    </set-header>
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
