# output "custom_cluster_command" {
#   value       = rancher2_cluster_v2.bigbang.cluster_registration_token.0.insecure_node_command
#   description = "kubectl command used to add a node to the MCM cluster"
#   sensitive = true
# }