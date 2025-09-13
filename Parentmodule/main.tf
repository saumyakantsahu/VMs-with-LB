module "rg" {
  source   = "../Childmodule/azurerm-rg-0"
  rg_name  = "sept9-rg"
  location = "South Africa North"
}

module "stgacc" {
  source   = "../Childmodule/azurerm-stg-00"
  stg_name = "sept14stg"
  rg_name  = module.rg.rg_name
  location = module.rg.location
}

module "vnet" {
  source             = "../Childmodule/azurerm-vnet-01"
  vnet               = "sept9-vnet"
  rg_name            = module.rg.rg_name
  location           = module.rg.location
  vnet_address_space = ["10.0.0.0/16"]
}

module "subnet1" {
  source                  = "../Childmodule/azurerm-subnet-02"
  subnet_name             = "subnet-01"
  rg_name                 = module.rg.rg_name
  vnet_name               = module.vnet.vnet_name
  address_prefixes_subnet = ["10.0.1.0/24"]

}

module "subnet2" {
  source                  = "../Childmodule/azurerm-subnet-02"
  subnet_name             = "subnet-02"
  rg_name                 = module.rg.rg_name
  vnet_name               = module.vnet.vnet_name
  address_prefixes_subnet = ["10.0.2.0/24"]
}


module "nic1" {
  source    = "../Childmodule/azurerm-nic-03"
  nic_name  = "nic-01"
  rg_name   = module.rg.rg_name
  location  = module.rg.location
  subnet_id = module.subnet1.subnet_id
}

module "nic2" {
  source    = "../Childmodule/azurerm-nic-03"
  nic_name  = "nic-02"
  rg_name   = module.rg.rg_name
  location  = module.rg.location
  subnet_id = module.subnet2.subnet_id
}


module "vm1" {
  source         = "../Childmodule/azurerm-vm-04"
  nic_name       = "nic-01"
  rg_name        = module.rg.rg_name
  location       = module.rg.location
  subnet_id      = module.subnet1.subnet_id
  vm_name        = "vm-01"
  vm_size        = "Standard_B1s"
  admin_username = "azureuser"
  admin_password = "Password1234!"
  nic_ids        = [module.nic1.nic-id]
}
module "vm2" {
  source         = "../Childmodule/azurerm-vm-04"
  nic_name       = "nic-02"
  rg_name        = module.rg.rg_name
  location       = module.rg.location
  subnet_id      = module.subnet2.subnet_id
  vm_name        = "vm-02"
  vm_size        = "Standard_B1s"
  admin_username = "azureuser"
  admin_password = "Password1234!"
  nic_ids        = [module.nic2.nic-id]
}

# Bastion k through connect ke liye
#Bastion Subet
#Bastion Public IP

#Bastion Subnet


module "subnet_bastion_subnet" {
  source                  = "../Childmodule/azurerm-subnet-02"
  subnet_name             = "AzureBastionSubnet" #Bastion subnet must be named "AzureBastionSubnet"
  rg_name                 = module.rg.rg_name
  vnet_name               = module.vnet.vnet_name
  address_prefixes_subnet = ["10.0.3.0/24"] #Bastion subnet must be named "AzureBastionSubnet"
}

#bastion Public IP

module "bastion_PIP" {
  source            = "../Childmodule/azurererm-pip-05"
  pip_name          = "bastion-pip"
  rg_name           = module.rg.rg_name
  location          = module.rg.location
  allocation_method = "Static"
  sku               = "Standard"

}

#finally bastion host

module "bastion_host" {
  source                       = "../Childmodule/azurerm-bastion-06"
  bastion_name                 = "myBastionHost"
  rg_name                      = module.rg.rg_name
  location                     = module.rg.location
  bastion_subnet_id            = module.subnet_bastion_subnet.subnet_id
  bastion_public_ip_address_id = module.bastion_PIP.public_ip_id
}

#NSG and association
module "nsg1" {
  source    = "../Childmodule/azurerm-nsg"
  nsg_name  = "nsg-vm-01"
  rg_name   = module.rg.rg_name
  location  = module.rg.location
}

module "nsg2" {
  source    = "../Childmodule/azurerm-nsg"
  nsg_name  = "nsg-vm-02"
  rg_name   = module.rg.rg_name
  location  = module.rg.location
}

# Associate NSG with Subnets 
#Subnet1 with nsg1
#Subnet2 with nsg2
#Subnet1 with nsg1 with vm1  = actually vm1 is in subnet1 
#so associating nsg1 with subnet1 will apply to vm1 - Association is between subnet and nsg not directly with vm

  resource "azurerm_subnet_network_security_group_association" "association1" {
    subnet_id                 = module.subnet1.subnet_id
    network_security_group_id = module.nsg1.nsg_id
  }
  resource "azurerm_subnet_network_security_group_association" "association2" {
    subnet_id                 = module.subnet2.subnet_id
    network_security_group_id = module.nsg2.nsg_id
  }

# Load Balancer
module "public_ip_lb" {
  source            = "../Childmodule/azurererm-pip-05"
  pip_name          = "lb-pip"
  rg_name           = module.rg.rg_name
  location          = module.rg.location
  allocation_method = "Static"
  sku               = "Standard"

}

module "load_balancer" {
  source             = "../Childmodule/azurerm-loadbalancer"
  lb_name            = "myLoadBalancer"
  rg_name            = module.rg.rg_name
  location           = module.rg.location
  frontend_ip_name   = "LoadBalancerFrontEnd"
  public_ip_id       = module.public_ip_lb.public_ip_id
  backend_pool_name  = "myBackendPool"
  probe_name         = "myHealthProbe"
  lb_rule_name       = "myLoadBalancerRule"
  frontend_port      = 9080
  backend_port       = 80
  
}