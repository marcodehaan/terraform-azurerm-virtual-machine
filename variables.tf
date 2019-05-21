<<<<<<< HEAD
=======
/*
# set the variables to create VMs for bi2
variable "rgroup_name" {
    description = "Name of the resourcegroup"
    default = "somedummyname-rg"
    }
variable "plan_name" {
    description = "Name of the DDOS protectionplan"
    default = "somedummyname-rg-ddos-plan"
    }
variable "nsg_name" {
    description = "Name of the Network Security Group"
    default = "somedummyname-rg-nsg"
    }
variable "vnet_name" {
    description = "Name of the Virtual Network"
    default = "somedummyname-rg-vnet"
    }
variable "vnet_addr" {
    description = "VNET Address range e.g. 10.1.0.0/16"
    default = "10.1.0.0/16"
    }
variable "subnet_name" {
    description = "Name of the Subnet"
    default = "somedummyname-rg-snet"
    }
variable "subnet_addr" {
    description = "SubNet Address Range e.g. 10.1.0.0/24"
    default = "10.1.0.0/24"
    }
variable "resource_location" {
    description = "Location to put all resources"
    default  = "westeurope"
    }
*/

>>>>>>> c86af040f18b188d3ad8d2f05f3a474e1502d320
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