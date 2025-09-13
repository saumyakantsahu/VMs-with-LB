variable "subnet_name" {}

variable "address_prefixes_subnet" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

variable "rg_name" { }

variable "vnet_name" { }
