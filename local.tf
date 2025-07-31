
locals {
  current_time = timestamp()
  time_tag     = formatdate("DD-MM-YYYY hh:mm ZZZ", local.current_time)

  common_tags = {
    managed_by    = "terraform"
    Environment   = var.environment
    modified_date = local.time_tag
  }

  Vm-size = {
    Dev   = "Standard_B1s"
    Stage = "Standard_B2s"
    Prod  = "Standard_D4s_v3"
  }

  nsg_rules = {
    allow_http = {
      priority               = 110
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "80"
    }

    allow_https = {
      priority               = 100
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "443"
    }

    allow_ssh = {
      priority               = 120
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "22"
    }
  }
}