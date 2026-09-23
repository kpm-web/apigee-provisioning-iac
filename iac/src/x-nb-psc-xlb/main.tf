/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  psc_subnet_region_name = { for subnet in var.psc_ingress_subnets :
    subnet.region => "${subnet.region}/${subnet.name}"
  }
}

module "project" {
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v58.0.0"
  name            = var.project_id
  parent          = var.project_parent
  billing_account = var.billing_account
  project_reuse   = var.project_create ? null : { use_data_source = true }
  services = [
    "apigee.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
  service_config = {
    disable_on_destroy         = false
    disable_dependent_services = false
  }
}

module "vpc" {
  source     = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v58.0.0"
  project_id = module.project.project_id
  name       = var.network
  psa_configs = [{
    ranges = {
      apigee-range         = var.peering_range
      apigee-support-range = var.support_range
    }
    export_routes = var.psa_config_export_routes
    import_routes = false
  }]
  depends_on = [
    module.project
  ]
}

module "apigee-x-core" {
  source              = "../../provider-modules/apigee-x-core"
  billing_type        = var.billing_type
  project_id          = module.project.project_id
  ax_region           = var.ax_region
  apigee_instances    = var.apigee_instances
  apigee_environments = var.apigee_environments
  apigee_envgroups = {
    for name, env_group in var.apigee_envgroups : name => {
      environments = env_group.environments
      hostnames    = env_group.hostnames
    }
  }
  network                      = module.vpc.network.id
  org_kms_keyring_name         = var.apigee_org_kms_keyring_name
  inst_kms_keyring_name_prefix = var.apigee_inst_kms_keyring_name_prefix
  org_retention                = var.retention
  addons_config                = var.addons_config
  depends_on = [
    module.vpc
  ]
}


/* module "psc-ingress-vpc" {
  source                  = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v58.0.0"
  project_id              = module.project.project_id
  name                    = var.psc_ingress_network
  auto_create_subnetworks = false
  subnets                 = var.psc_ingress_subnets
} */


/* resource "google_compute_region_network_endpoint_group" "psc_neg" {
  project               = var.project_id
  for_each              = var.apigee_instances
  name                  = "psc-neg-${each.value.region}"
  region                = each.value.region
  network               = module.psc-ingress-vpc.network.id
  subnetwork            = module.psc-ingress-vpc.subnet_self_links[local.psc_subnet_region_name[each.value.region]]
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = module.apigee-x-core.instance_service_attachments[each.value.region]
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    module.psc-ingress-vpc,
    module.apigee-x-core
  ]
} */

/* module "nb-psc-l7xlb" {
  source             = "../../provider-modules/nb-psc-l7xlb"
  project_id         = module.project.project_id
  psc_negs           = [for _, psc_neg in google_compute_region_network_endpoint_group.psc_neg : psc_neg.id]
  name               = var.loadbalancer_name
  log_enable         = var.lb_log_enable
  log_samplerate     = var.lb_log_samplerate
  hostnames          = var.lb_hostnames
  certificate_prefix = var.lb_certificate_prefix
  depends_on = [
    google_compute_region_network_endpoint_group.psc_neg
  ]
} */