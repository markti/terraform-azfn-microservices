

resource "azurerm_api_management_api_operation" "op" {
  operation_id        = "${var.operation_id}"
  api_name            = "${var.api_name}"
  api_management_name = "${var.apim_name}"
  resource_group_name = "${var.resource_group_name}"
  display_name        = "${var.display_name}"
  description         = "${var.description}"
  method              = "${var.method}"
  url_template        = "${var.url_template}"

  response {
    status_code = 200
  }

  template_parameter {
    name        = "${var.param1}"
    required    = "true"
    type        = "string"
  }
}

resource "azurerm_api_management_api_operation_policy" "op_policy" {
  api_name            = "${var.api_name}"
  api_management_name = "${var.apim_name}"
  resource_group_name = "${var.resource_group_name}"
  operation_id        = "${azurerm_api_management_api_operation.op.operation_id}"

  xml_content = <<XML
<policies>
  <inbound>
    <base />
  </inbound>
</policies>
XML
}
