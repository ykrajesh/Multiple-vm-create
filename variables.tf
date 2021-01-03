variable "resource_group_name" {
    type = string
    default = "network-interface1"
  }
variable "resource_group_location" {
  type = string
  default = "East us"
}
variable "Vnet_name" {
      default = "vnet" 
    description = "Deaclear vnet name "
}
variable "subnet_name" {
      default = "vnet-subnet" 
    description = "Deaclear Subnet name "
}
variable "NIC" {
  type = map(string)
  default = {
    DC1 = "10.0.2.5"
    DC2 = "10.0.2.5"
  }
}

variable "Virtual_Machine_name" {
  type = map(string)
  default = {
    TESTDC1 = "10.0.2.5"
    TESTDC2 = "10.0.2.6"
  }
}
