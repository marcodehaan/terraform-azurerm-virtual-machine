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
#}

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

# create the VM

resource "azurerm_public_ip" "main" {
  name                = "${var.vm_name}-pip"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                  = "${var.vm_name}-nic"
  location              = "${var.resource_group_location}"
  resource_group_name   = "${var.resource_group_name}"

  ip_configuration {
    name                          = "vm-ip-conf"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.vm_name}-vm"
  location              = "${var.resource_group_location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "${var.vm_sku_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.vm_name}-vm"
    admin_username = "${var.admin_user}"      # manier zoeken om dit vanuit de keyvault te pakken
    admin_password = "${var.admin_pass}"  # manier zoeken om dit vanuit de keyvault te pakken
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}