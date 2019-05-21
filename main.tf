# create the VM
resource "azurerm_public_ip" "main" {
  name                = "${var.vm_name}-pip"
  location            = "${var.resource_location}"
  resource_group_name = "${var.rgroup_name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                  = "${var.vm_name}-nic"
  location              = "${var.resource_location}"
  resource_group_name   = "${var.rgroup_name}"

  ip_configuration {
    name                          = "vm-ip-conf"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.vm_name}-vm"
  location              = "${var.resource_location}"
  resource_group_name   = "${var.rgroup_name}"
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
    admin_username = "${var.cmd_user}"      # manier zoeken om dit vanuit de keyvault te pakken
    admin_password = "${var.cmd_pass}"  # manier zoeken om dit vanuit de keyvault te pakken
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
