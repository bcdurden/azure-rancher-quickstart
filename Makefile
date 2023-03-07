SHELL:=/bin/bash
REQUIRED_BINARIES := kubectl helm kubectx kubecm terraform
WORKING_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TERRAFORM_DIR := ${WORKING_DIR}/terraform

BASE_URL=sienarfleet.systems
CERT_MANAGER_VERSION=1.8.1
RANCHER_VERSION=2.7.0

# RKE2 details
RKE2_CP_VM_TYPE=Standard_DS2_v2
RKE2_WORKER_VM_TYPE=Standard_DS2_v2
LOCAL_CLUSTER_NAME="azure_rke2"
RKE2_WORKER_COUNT=3
RANCHER_URL=rancher.demo.${BASE_URL}

# Azure details
AZURE_CLIENT_ID=
AZURE_CLIENT_SECRET=
AZURE_SUBSCRIPTION_ID=
AZURE_TENANT_ID=
AZURE_LOCATION="East US"

check-tools: ## Check to make sure you have the right tools
	$(foreach exec,$(REQUIRED_BINARIES),\
		$(if $(shell which $(exec)),,$(error "'$(exec)' not found. It is a dependency for this Makefile")))
infra: check-tools
	@printf "\n=====> Terraforming Infra\n";
	@$(MAKE) _terraform COMPONENT=infra
rancher: check-tools  # state stored locally
	@printf "\n====> Terraforming RKE2 + Rancher\n";
	@kubecm delete $(LOCAL_CLUSTER_NAME) || true
	@$(MAKE) _terraform COMPONENT=rancher VARS='TF_VAR_worker_count=$(RKE2_WORKER_COUNT) TF_VAR_azure_client_id="$(AZURE_CLIENT_ID)" TF_VAR_azure_client_secret="$(AZURE_CLIENT_SECRET)" TF_VAR_azure_subscription_id="$(AZURE_SUBSCRIPTION_ID)" TF_VAR_azure_tenant_id="$(AZURE_TENANT_ID)" TF_VAR_azure_location="$(AZURE_LOCATION)" TF_VAR_rancher_cp_instance_type="$(RKE2_CP_VM_TYPE)" TF_VAR_rancher_worker_instance_type="$(RKE2_WORKER_VM_TYPE)"'
	@cp ${TERRAFORM_DIR}/rancher/kube_config_server.yaml /tmp/$(LOCAL_CLUSTER_NAME).yaml && kubecm add -c -f /tmp/$(LOCAL_CLUSTER_NAME).yaml && rm /tmp/$(LOCAL_CLUSTER_NAME).yaml
	@kubectx $(LOCAL_CLUSTER_NAME)
	@helm upgrade --install cert-manager -n cert-manager --create-namespace --set installCRDs=true https://charts.jetstack.io/charts/cert-manager-v$(CERT_MANAGER_VERSION).tgz
	@helm upgrade --install rancher -n cattle-system --create-namespace --set hostname=$(RANCHER_URL) --set replicas=$(RKE2_WORKER_COUNT) --set bootstrapPassword=admin https://releases.rancher.com/server-charts/latest/rancher-$(RANCHER_VERSION)).tgz
rancher-delete: rancher-destroy
rancher-destroy: check-tools
	@printf "\n====> Destroying RKE2 + Rancher\n";
	@$(MAKE) _terraform-destroy COMPONENT=rancher VARS='TF_VAR_azure_client_secret="$(AZURE_CLIENT_SECRET)" TF_VAR_azure_subscription_id="$(AZURE_SUBSCRIPTION_ID)" TF_VAR_azure_tenant_id="$(AZURE_TENANT_ID)" TF_VAR_azure_location="$(AZURE_LOCATION)"'
	@kubecm delete $(LOCAL_CLUSTER_NAME) || true




# terraform sub-targets (don't use directly)
_terraform: check-tools
	@$(VARS) terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) init
	@$(VARS) terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) apply
_terraform-init: check-tools
	@$(VARS) terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) init
_terraform-apply: check-tools
	@$(VARS) terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) apply
_terraform-value: check-tools
	@terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) output -json | jq -r '$(FIELD)'
_terraform-destroy: check-tools
	@$(VARS) terraform -chdir=${TERRAFORM_DIR}/$(COMPONENT) destroy