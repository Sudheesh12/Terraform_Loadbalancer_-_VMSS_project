resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss-01" {
  name                        = "sudheesh-VMSS"
  location                    = azurerm_resource_group.lb-rg.location
  resource_group_name         = azurerm_resource_group.lb-rg.name
  platform_fault_domain_count = 1
  sku_name                    = lookup(local.Vm-size, var.environment, "Standard_B2ms")
  instances                   = 2
  zones                       = ["1"]
  user_data_base64            = base64encode(file("${path.module}/user-data.sh"))


  os_profile {
    linux_configuration {
      admin_username                  = "adminuser"
      disable_password_authentication = true


      admin_ssh_key {
        username   = "adminuser"
        public_key = file("${path.module}/.ssh/id_rsa.pub")
      }
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }


  network_interface {
    name    = "sudheesh-vmss-nic"
    primary = true


    ip_configuration {
      name                                   = "vmss-ip"
      subnet_id                              = azurerm_subnet.sub1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-back.id]
    }
  }



  lifecycle {
    ignore_changes = [instances]
  }

}


resource "azurerm_monitor_autoscale_setting" "scale-01" {
  name                = "sudheesh-cpu-auto-scale"
  resource_group_name = azurerm_resource_group.lb-rg.name
  location            = azurerm_resource_group.lb-rg.location
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss-01.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss-01.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss-01.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }
}