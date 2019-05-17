output "resource_group_location" {
    description = "Location of the resource_group"
    value = "${azurerm_resource_group.main.location}"
}

output "resource_group_name" {
    description = "Name of the resource_group"    
    value = "${azurerm_resource_group.main.name}"
}

output "subnet_id" {
    description = "ID of the Subnet"  
    value = "${azurerm_subnet.main.id}"
}
