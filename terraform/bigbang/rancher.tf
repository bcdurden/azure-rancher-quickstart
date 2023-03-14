# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {

  provider = rancher2.bootstrap

  password  = var.admin_password
  telemetry = true
}