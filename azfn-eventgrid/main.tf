resource "azurerm_eventgrid_topic" "eventgrid" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags = "${var.tags}"
}

resource "azurerm_key_vault_secret" "kv_endpoint" {
  name         = "${var.name}-Endpoint"
  value        = "${azurerm_eventgrid_topic.eventgrid.endpoint}"
  key_vault_id = "${var.keyvault_id}"

  tags = "${var.tags}"
}


resource "azurerm_key_vault_secret" "kv_accesskey" {
  name         = "${var.name}-AccessKey"
  value        = "${azurerm_eventgrid_topic.eventgrid.primary_access_key}"
  key_vault_id = "${var.keyvault_id}"

  tags = "${var.tags}"
}
