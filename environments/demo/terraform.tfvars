project_id   = "cnx-migration-demo-26"
billing_type = "EVALUATION"

ax_region = "us-east1"
retention = "MINIMUM"

apigee_instances = {
  cnx-migr-demo-use1 = {
    region       = "us-east1"
    environments = ["env-dev-1", "env-qa-1"]
  }
}

addons_config = {
  api_security = true
}

apigee_environments = {
  env-dev-1 = {
    display_name = "dev"
    description  = "dev"
    node_config  = null
    iam          = null
    envgroups    = ["envgrp-dev"]
    # type         = "COMPREHENSIVE"
  }
  env-qa-1 = {
    display_name = "qa"
    description  = "qa"
    node_config  = null
    iam          = null
    envgroups    = ["envgrp-qa"]
    # type         = "COMPREHENSIVE"
  }
}

apigee_envgroups = {
  envgrp-dev = {
    environments = ["env-dev-1"]
    hostnames    = ["dev.migrationdemo.com"]
  }
  envgrp-qa = {
    environments = ["env-qa-1"]
    hostnames    = ["qa.migrationdemo.com"]
  }
}

apigee_org_kms_keyring_name         = "cnx-migr-demo1-apigee-org-analytics-db"
apigee_inst_kms_keyring_name_prefix = "cnx-migr-demo1-apigee-inst"

network = "cnx-migr-demo-apigee-network"

psc_ingress_network = "cnx-migr-demo-psc-ingress"

psc_ingress_subnets = [
  {
    name               = "cnx-migr-demo-apigee-psc-use1"
    ip_cidr_range      = "10.253.0.0/24"
    region             = "us-east1"
    secondary_ip_range = null
  }
]

peering_range = "10.253.4.0/22"
support_range = "10.253.1.0/28"
# Adding export routes for service network peering.
psa_config_export_routes = true

loadbalancer_name     = "cnx-migr-demo-apigee-xlb"
lb_hostnames          = ["dev", "qa"]
lb_certificate_prefix = "cnx-migr-demo-apigee-"