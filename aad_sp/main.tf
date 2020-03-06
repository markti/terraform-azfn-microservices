
resource "azuread_application" "aad_app" {
  name                       = "${var.name}"
}

resource "random_password" "aad_app" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azuread_application_password" "aad_app" {
  application_object_id = "${azuread_application.aad_app.object_id}"
  value          = "${random_password.aad_app.result}"
  end_date       = "2021-01-01T01:02:03Z"
}

resource "azuread_service_principal" "aad_sp" {
  application_id         = "${azuread_application.aad_app.application_id}"
  
}

resource "random_password" "aad_sp" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azuread_service_principal_password" "aad_sp" {
  service_principal_id = "${azuread_service_principal.aad_sp.id}"
  value                = "${random_password.aad_sp.result}"
  end_date             = "2021-01-01T01:02:03Z"
}

output "client_id"{
  value=["${azuread_service_principal.aad_sp.id}"]
}
output "client_secret"{
  value=["${azuread_service_principal_password.aad_sp.value}"]
}
