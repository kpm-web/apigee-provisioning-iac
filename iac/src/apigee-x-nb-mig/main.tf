module "project" {
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v58.0.0"
  name            = var.project_id
  parent          = var.project_parent
  billing_account = var.billing_account
  project_reuse   = var.project_create ? null : { use_data_source = true }
  services        = var.services
  service_config = {
    disable_on_destroy         = false
    disable_dependent_services = false
  }
}

module "network-data" {
  source        = "../../provider-modules/network-data"
  project_id    = var.vpc_host_project_id
  network       = var.network
  apigee_subnet = var.apigee_subnet
}

module "vpc" {
  source     = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v58.0.0"
  project_id = var.vpc_host_project_id
  vpc_create = var.vpc_create
  name       = var.network
  psa_configs = [{
    ranges = {
      apigee-range         = var.peering_range
      apigee-support-range = var.support_range
    }
    export_routes = true
    import_routes = false
  }]
  depends_on = [
    module.project,
    module.network-data
  ]
}

module "apigee-x-core" {
  source           = "../../provider-modules/apigee-x-core"
  project_id       = module.project.project_id
  ax_region        = var.ax_region
  apigee_instances = var.apigee_instances
  # apigee_environments = var.apigee_environments
  apigee_envgroups = {
    for name, env_group in var.apigee_envgroups : name => {
      environments = env_group.environments
      hostnames    = env_group.hostnames
    }
  }
  network                      = module.network-data.vpc_id
  org_kms_keyring_name         = var.apigee_org_kms_keyring_name
  inst_kms_keyring_name_prefix = var.apigee_inst_kms_keyring_name_prefix
  depends_on = [
    module.vpc
  ]
}


# Uncomment if you need to create the Managed Instance Group and spin the instances
# If not needed, please comment or delete this block
module "apigee-x-bridge-mig" {
  for_each     = var.apigee_instances
  source       = "../../provider-modules/apigee-x-bridge-mig"
  name         = var.mig_name
  project_id   = module.project.project_id
  network      = module.network-data.vpc_id
  subnet       = module.network-data.apigee_subnet_selflink[0]
  region       = each.value.region
  network_tags = var.mig_network_tags
  machine_type = var.mig_machine_type
  # boot_disk_image        = var.boot_disk_image
  # image_type             = var.image_type
  # disk_size              = var.disk_size
  # mig_target_size        = var.mig_target_size
  autoscaler_config = var.autoscaler_config
  # startup_script         = var.mig_startup_script
  # create_service_account = var.mig_create_service_account
  endpoint_ip = module.apigee-x-core.instance_endpoints[each.key]
  depends_on = [
    module.apigee-x-core
  ]
}

# Uncomment if you need to create an External HTTPS load balancer and establish route to MIGs
# If not needed, please comment or delete this block
module "mig-l7xlb" {
  source       = "../../provider-modules/mig-l7xlb"
  project_id   = module.project.project_id
  name         = var.loadbalancer_name
  backend_migs = [for _, mig in module.apigee-x-bridge-mig : mig.instance_group]
  #external_ip  = var.lb_external_ip  #Uncomment if you're providing a Static IP for load balancer, else leave it commented, so an IP address is provisioned during the process
  log_enable     = var.lb_log_enable
  log_samplerate = var.lb_log_samplerate
  cert_cn        = var.lb_cert_cn
  cert_domain    = var.lb_cert_domain
  cert_org       = var.lb_cert_org
  cert_validity  = var.lb_cert_validity
  # ssh_source_range = var.mig_ssh_source_range
  # lb_outbound_range = var.lb_outbound_range
  depends_on = [
    module.apigee-x-core,
    module.apigee-x-bridge-mig
  ]
}

# Uncomment to create a VM instance within same network to access APIGEE endpoints within the network
# If not needed, please comment or delete this block

module "apigee-client-vm" {
  for_each            = var.apigee_instances
  source              = "../../provider-modules/apigee-x-client-vm"
  project_id          = var.project_id
  vpc_host_project_id = var.vpc_host_project_id
  vm_name             = "apigee-client"
  region              = each.value.region
  network             = module.network-data.vpc_id
  subnet              = module.network-data.apigee_subnet_selflink[0]
  machine_type        = var.mig_machine_type
  boot_disk_image     = var.boot_disk_image
  image_type          = var.image_type
  disk_size           = var.disk_size
  ssh_source_range    = var.mig_ssh_source_range
  depends_on = [
    module.apigee-x-core
  ]
}

