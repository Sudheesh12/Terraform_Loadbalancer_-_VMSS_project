#public IP for the frontend LB.
resource "azurerm_public_ip" "pub-01" {
  name                = "${random_pet.ran_name.prefix}-ip01"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower("${azurerm_resource_group.lb-rg.name}-${random_pet.ran_name.id}")
  tags                = local.common_tags
}


#load balancer
resource "azurerm_lb" "lb-01" {
  name                = "${random_pet.ran_name.id}-lb"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.pub-01.id
  }
}


resource "azurerm_lb_backend_address_pool" "lb-back" {
  name            = "backend_pool_address"
  loadbalancer_id = azurerm_lb.lb-01.id

}

resource "azurerm_lb_probe" "lb-probe" {
  name            = "http-probe1"
  port            = 80
  loadbalancer_id = azurerm_lb.lb-01.id
  protocol        = "Http"
  request_path    = "/"
}


resource "azurerm_lb_rule" "lb_rule01" {
  loadbalancer_id                = azurerm_lb.lb-01.id
  name                           = "http-rule-new"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontendip"
  probe_id = azurerm_lb_probe.lb-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-back.id]
}

resource "azurerm_lb_rule" "lb_rule02" {
  loadbalancer_id                = azurerm_lb.lb-01.id
  name                           = "https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "frontendip"
  probe_id = azurerm_lb_probe.lb-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-back.id]
}


resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh"
  resource_group_name            = azurerm_resource_group.lb-rg.name
  loadbalancer_id                = azurerm_lb.lb-01.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "frontendip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-back.id
}





