variable "lb_name" {}
variable "rg_name" {}   
variable "location" {}

#front end ip configuration
variable "frontend_ip_name" {}      
variable "public_ip_id" {}

#backend address pool
variable "backend_pool_name" {}


#health probe
variable "probe_name" {}

#LB Rule
variable "lb_rule_name"  {}
variable "frontend_port" {}
variable "backend_port"  {}

