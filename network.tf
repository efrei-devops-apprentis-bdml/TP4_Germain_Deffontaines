data "azurerm_virtual_network" "tp4-network" {
    name = "example-network"
    resource_group_name = data.azurerm_resource_group.tp4.name
}

data "azurerm_subnet" "tp4-subnet" {
    name = "internal"
    resource_group_name = data.azurerm_resource_group.tp4.name
    virtual_network_name = data.azurerm_virtual_network.tp4-network.name
}

resource "azurerm_public_ip" "tp4-public-ip" {
  name                = "tp4-public-ip-20190604"
  location            = data.azurerm_resource_group.tp4.location
  resource_group_name = data.azurerm_resource_group.tp4.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup-20180604"
  location            = data.azurerm_resource_group.tp4.location
  resource_group_name = data.azurerm_resource_group.tp4.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tp4-nic" {
  name                = "tp4-nic"
  location            = data.azurerm_resource_group.tp4.location
  resource_group_name = data.azurerm_resource_group.tp4.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.tp4-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tp4-public-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.tp4-nic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


#création de la clef privée RSA
resource "tls_private_key" "tp4-prkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

