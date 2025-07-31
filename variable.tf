
resource "random_pet" "ran_name" {
  prefix = "Sudheesh-test"
  length = 1
}


variable "environment" {
  type        = string
  description = "Environment"
  default     = "Dev"
  validation {
    condition     = contains(["Dev", "Prod", "Stage"], var.environment)
    error_message = "enter the correct environment"
  }
}


variable "valid_location" {
  type        = string
  description = "Valid location for the resource group"
  validation {
    condition     = contains(["East US", "West Europe", "Southeast Asia", "Central India"], var.valid_location)
    error_message = "Enter the valid location : East US, West Europe, Southeast Asia"
  }
}

