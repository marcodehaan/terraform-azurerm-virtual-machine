# Create a resource group
resource "azurerm_resource_group" "main" {
	name = "${var.rgroup_name}"
	location = "${var.resource_location}"
  tags = {
    environment = "terraform-test" # needs to be a var
  }
}

# set the provider and terraform version
#provider "azurerm" {
#  version = "=1.27" # use version 1.27
  #region     = "westeurope"
}

# create a network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.nsg_name}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

# create a ddos protection plan
resource "azurerm_network_ddos_protection_plan" "main" {
  name                = "${var.plan_name}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "main" {
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  address_space       = ["${var.vnet_addr}"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  # activate the ddos protection plan
  ddos_protection_plan {
    id     = "${azurerm_network_ddos_protection_plan.main.id}"
    enable = true
  }

  #tags = {
  #  environment = "terraform-test" # needs to be a var
  #}
}

# create subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnet_addr}"
}

# asociate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = "${azurerm_subnet.main.id}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
}

# create network rule
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ALLOW_SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.main.name}"
}

# create network rule
resource "azurerm_network_security_rule" "http" {
  name                        = "ALLOW_HTTP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.main.name}"
}
