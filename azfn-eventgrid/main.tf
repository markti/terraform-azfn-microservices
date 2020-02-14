resource "azurerm_eventgrid_topic" "eventgrid" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags = {
    environment = "${var.env_name}"
  }
}

resource "azurerm_key_vault_secret" "eventgrid" {
  name         = "${var.name}-Endpoint"
  value        = "${azurerm_eventgrid_topic.eventgrid_transcription.endpoint}"
  key_vault_id = "${var.keyvault_id}"

  tags = {
    environment = "${var.env_name}"
  }
}


resource "azurerm_key_vault_secret" "eventgrid" {
  name         = "${var.name}-AccessKey"
  value        = "${azurerm_eventgrid_topic.eventgrid_transcription.primary_access_key}"
  key_vault_id = "${var.keyvault_id}"

  tags = {
    environment = "${var.env_name}"
  }
}
