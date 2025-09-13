resource "azurerm_lb" "LoadBalancer" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name

 #front end ip configuration
  frontend_ip_configuration {
    name                 = var.frontend_ip_name
    public_ip_address_id = var.public_ip_id
  }
}

#backend address pool
resource "azurerm_lb_backend_address_pool" "backendpool" {
  loadbalancer_id = azurerm_lb.LoadBalancer.id
  name            = var.backend_pool_name

}


#health probe
resource "azurerm_lb_probe" "healthprobe" {
  loadbalancer_id = azurerm_lb.LoadBalancer.id
  name            = var.probe_name
  protocol        = "Tcp"
  port            = 80
}

#LB Rule

resource "azurerm_lb_rule" "LB-Rule" {
  loadbalancer_id                =azurerm_lb.LoadBalancer.id
   name                           = var.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = var.frontend_ip_name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backendpool.id]
    probe_id                    = azurerm_lb_probe.healthprobe.id
}

