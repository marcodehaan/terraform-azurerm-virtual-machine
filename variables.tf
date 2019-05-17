# set the variables to create VMs for bi2
variable "prefix" {
  default = "hannl-hlo-haanw"
}

  variable "rgroup_name" {
    default = "hannl-hlo-haanw-test007-rg"
  }

  variable "plan_name" {
    default = "hannl-hlo-haanw-test007-rg-ddos-plan"
  }

  variable "nsg_name" {
    default = "hannl-hlo-haanw-test007-rg-nsg"
  }

  variable "vnet_name" {
    default = "hannl-hlo-haanw-test007-rg-vnet"
  }
    variable "vnet_addr" {
    default = "10.1.0.0/16"
  }
  
  variable "subnet_name" {
    default = "hannl-hlo-haanw-test007-rg-snet"
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
