
resource "azurerm_virtual_network" "vnet1" {
  name                = "sudheesh-Vnet01"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  tags = local.common_tags
}

resource "azurerm_subnet" "sub1" {
  name                 = "Application_Subnet"
  resource_group_name  = azurerm_resource_group.lb-rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/20"]
}

resource "azurerm_subnet" "sub2" {
  name                 = "Management_Subnet"
  resource_group_name  = azurerm_resource_group.lb-rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.16.0/20"]
}



resource "azurerm_network_security_group" "nsg-1" {
  name                = "sudheesh-nsg-lb-01"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name


  # security rules creation using dynamic
  dynamic "security_rule" {
    for_each = local.nsg_rules

    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg-1.id
}


resource "azurerm_public_ip" "pub-nat-02" {
  name                = "${random_pet.ran_name.prefix}-nat-ip02"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
  zones               = ["1"]
}


resource "azurerm_nat_gateway" "nat-01" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.lb-rg.location
  resource_group_name     = azurerm_resource_group.lb-rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "sub-nat" {
  subnet_id      = azurerm_subnet.sub1.id
  nat_gateway_id = azurerm_nat_gateway.nat-01.id
}


resource "azurerm_nat_gateway_public_ip_association" "nat-pub" {
  nat_gateway_id       = azurerm_nat_gateway.nat-01.id
  public_ip_address_id = azurerm_public_ip.pub-nat-02.id

}

