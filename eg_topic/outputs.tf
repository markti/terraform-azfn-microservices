
output "topic_name" {
    value = "${azurerm_eventgrid_topic.eventgrid.name}"
}
output "topic_id" {
    value = "${azurerm_eventgrid_topic.eventgrid.id}"
}