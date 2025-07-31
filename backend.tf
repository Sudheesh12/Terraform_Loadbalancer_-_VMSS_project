terraform {
  backend "azurerm" {
    resource_group_name  = "sudheesh-st-test"
    storage_account_name = "sudheesh1229"
    container_name       = "terraform-state-files"
    key                  = "NIC_expression_test"
  }
}