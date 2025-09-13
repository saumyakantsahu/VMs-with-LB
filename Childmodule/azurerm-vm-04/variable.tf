variable "nic_name" {}
variable "rg_name" {}
variable "location" {}
variable "subnet_id" {}
variable "vm_name" {}
variable "vm_size" {}
variable "admin_password" {}
variable "admin_username" {}
variable "nic_ids" {
  type = list(string)
}


