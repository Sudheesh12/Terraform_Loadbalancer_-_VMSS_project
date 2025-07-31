resource "azurerm_resource_group" "lb-rg" {
  name     = random_pet.ran_name.id
  location = var.valid_location
  tags     = local.common_tags
}

