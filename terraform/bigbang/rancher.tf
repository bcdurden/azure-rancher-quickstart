# # Initialize Rancher server
# resource "rancher2_bootstrap" "admin" {

#   provider = rancher2.bootstrap

#   password  = var.admin_password
#   telemetry = true
# }

# resource "rancher2_cluster" "bigbang" {
#   name = "bigbang"
#   description = "BigBang imported cluster"
# }

# resource "rancher2_cluster_v2" "bigbang" {
#   provider = rancher2.admin

#   name               = var.workload_cluster_name
#   kubernetes_version = var.rke2_version
# }