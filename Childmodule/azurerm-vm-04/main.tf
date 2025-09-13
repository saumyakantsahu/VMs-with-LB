

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
    admin_password      = var.admin_password
    disable_password_authentication = false
  network_interface_ids = var.nic_ids


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

#add custome data -basically try to install NGINX
 

  custom_data = base64encode(<<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>Welcome to VIRTUAL MACHINE - Created with Modular Approach - ${var.vm_name}</h1>" > /var/www/html/index.html
  EOT
  )
}