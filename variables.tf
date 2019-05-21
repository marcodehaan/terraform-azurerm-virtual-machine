variable "vm_name" {
    description = "Name for the virtual machine"
    default = "somedummyname-vm"
}
variable "rgroup_name" {
    description = "name of the resource group"
    default = "somedummyname-rg"
}
variable "resource_location" {
    description = "location of the resource"
    default = "westeurope"
}
variable "vm_sku_size" {
    description = "SKU for Virtual Machine"
    default = "Standard_B1S"
    }
variable "cmd_user" {
    description = "Username to log on to Virtual Machine"
    default = "dummyuser"
    type = "string"
    }
variable "cmd_pass" {
    description = "Password for Virtual Machine User"
    default = "s0M3Stup1dPassW0rd"
    type = "string"
    }
variable "subnet_id" {
    description = "id of the subnet to use for the VM"
}
