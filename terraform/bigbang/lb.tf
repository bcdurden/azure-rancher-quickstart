resource "azurerm_public_ip" "rancher_lb_ip" {
  name                = "${var.prefix}-lb"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name
  allocation_method   = "Static"

  tags = {
    demo_type = "bigbang"
  }
}

resource "azurerm_lb" "rancher_lb" {
  name                = "${var.prefix}-lb"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend"
    public_ip_address_id = azurerm_public_ip.rancher_lb_ip.id
  }

  tags = {
    demo_type = "bigbang"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id     = "${azurerm_lb.rancher_lb.id}"
  name                = "${var.prefix}-backend_address_pool"
}

resource "azurerm_lb_rule" "load_balancer_https6443_rule" {
  loadbalancer_id                = azurerm_lb.rancher_lb.id
  name                           = "HTTPS6443Rule"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "${var.prefix}-frontend"
  probe_id                       = azurerm_lb_probe.load_balancer_probe.id
  depends_on                     = [azurerm_lb_probe.load_balancer_probe]
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}

resource "azurerm_lb_rule" "load_balancer_https_rule" {
  loadbalancer_id                = azurerm_lb.rancher_lb.id
  name                           = "HTTPS443Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${var.prefix}-frontend"
  probe_id                       = azurerm_lb_probe.load_balancer_probe.id
  depends_on                     = [azurerm_lb_probe.load_balancer_probe]
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}

resource "azurerm_lb_probe" "load_balancer_probe" {
  loadbalancer_id     = "${azurerm_lb.rancher_lb.id}"
  name                = "HTTPS6443"
  port                = 6443
}

# may need multiples of these
resource "azurerm_network_interface_backend_address_pool_association" "rancher_demo_pool" {
  network_interface_id    = azurerm_network_interface.rancher_server_interface.id
  ip_configuration_name   = azurerm_network_interface.rancher_server_interface.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}