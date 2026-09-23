project_id   = "pep-gal-europe-west1-2"
billing_type = "EVALUATION"

ax_region = "europe-west1"
retention = "MINIMUM"

apigee_instances = {
  cnx-portaldemo-europe-west1-2 = {
    region       = "europe-west1"
    environments = ["sandbox", "prod"]
  }
}

apigee_environments = {
  sandbox = {
    display_name = "sandbox"
    description  = "sandbox"
    node_config  = null
    iam          = null
    envgroups    = ["envgrp-sandbox"]
    # type         = "COMPREHENSIVE"
  }
  prod = {
    display_name = "prod"
    description  = "prod"
    node_config  = null
    iam          = null
    envgroups    = ["envgrp-prod"]
    # type         = "COMPREHENSIVE"
  }
}

apigee_envgroups = {
  envgrp-sandbox = {
    environments = ["sandbox"]
    hostnames    = ["sandbox.portaldemo.com"]
  }
  envgrp-prod = {
    environments = ["prod"]
    hostnames    = ["prod.portaldemo.com"]
  }
}

apigee_org_kms_keyring_name         = "pep-gal-europe-west1-2-org-analytics-db"
apigee_inst_kms_keyring_name_prefix = "pep-gal-europe-west1-2-inst"

network = "pep-gal-europe-west1-2-network"

psc_ingress_network = "pep-gal-europe-west1-2-psc-ingress"

psc_ingress_subnets = [
  {
    name               = "pep-gal-europe-west1-2-psc"
    ip_cidr_range      = "10.253.0.0/24"
    region             = "europe-west1"
    secondary_ip_range = null
  }
]

peering_range = "10.253.4.0/22"
support_range = "10.253.1.0/28"
# Adding export routes for service network peering.
psa_config_export_routes = true

loadbalancer_name     = "pep-gal-europe-west1-2-xlb"
lb_hostnames          = ["sandbox", "prod"]
lb_certificate_prefix = "pep-gal-europe-west1-2-"