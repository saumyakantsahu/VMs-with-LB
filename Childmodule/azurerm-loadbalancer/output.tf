output "loadbalancer_id" {
  value = azurerm_lb.LoadBalancer.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.backendpool.id
}

output "health_probe_id" {
  value = azurerm_lb_probe.healthprobe.id
}

