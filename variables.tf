# set the variables to create VMs for bi2
variable "prefix" {
    default = ""
}
variable "rgroup_name" {
    default = "${var.prefix}-rg"
    }
variable "plan_name" {
    default = "${var.rgroup_name}-ddos-plan"
    }
variable "nsg_name" {
    default = "${var.rgroup_name}-nsg"
    }
variable "vnet_name" {
    default = "${var.rgroup_name}-vnet"
    }
variable "vnet_addr" {
    default = "10.1.0.0/16"
    }
variable "subnet_name" {
    default = "${var.rgroup_name}-snet"
    }
variable "subnet_addr" {
    default = "10.1.0.0/24"
      }
variable "resource_location" {
    default = "westeurope"
    }
variable "vm_sku_size" {
    default = "Standard_B1S"
    }
variable "cmd_user" {
    type = "string"
    }
variable "cmd_pass" {
    type = "string"
    }
