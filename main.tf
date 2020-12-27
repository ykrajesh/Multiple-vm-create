provider "azurerm" {
  features {}
}
# create the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
# create virtual network 
resource "azurerm_virtual_network" "vnet" {
  name = var.Vnet_name
  //name                = "${var.Virtual_Machine_name1[1]}-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# create subnet in vnet
resource "azurerm_subnet" "subnet" {

  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
#create Network interface 
resource "azurerm_network_interface" "Interface" {
  for_each = var.Virtual_Machine_name
 name = "${each.key}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {

    name                          = each.key
    subnet_id                     = azurerm_subnet.subnet.id
    //private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public[each.key].id
    private_ip_address_allocation = "Static"
    //for_each = var.NIC
    private_ip_address = each.value
    //private_ip_address = var.dc_ips[0]
  }
}

#create public ip address
resource "azurerm_public_ip" "public" {
  for_each = var.Virtual_Machine_name
 name = "${each.key}-pip"
  //name                    = "PublicIP"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
}

# create the  Vm machine 
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.Virtual_Machine_name
  name = "${each.key}-MACHINE"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "vmadmin"
  admin_password      = "Welcome@1234"
  network_interface_ids = [azurerm_network_interface.Interface[each.key].id]
  
# Disk type define here
  os_disk {
    name = "${each.key}-OS-Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
# os Source 
 source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
