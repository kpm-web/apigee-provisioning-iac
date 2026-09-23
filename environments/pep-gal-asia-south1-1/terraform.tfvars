project_id   = "pep-gal-asia-south1-1"
billing_type = "EVALUATION"

ax_region = "asia-south1"
retention = "MINIMUM"

apigee_instances = {
  cnx-portaldemo-asia-south1-1 = {
    region       = "asia-south1"
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

apigee_org_kms_keyring_name         = "pep-gal-asia-south1-1-org-analytics-db"
apigee_inst_kms_keyring_name_prefix = "pep-gal-asia-south1-1-inst"

network = "pep-gal-asia-south1-1-network"

psc_ingress_network = "pep-gal-asia-south1-1-psc-ingress"

psc_ingress_subnets = [
  {
    name               = "pep-gal-asia-south1-1-psc"
    ip_cidr_range      = "10.253.0.0/24"
    region             = "asia-south1"
    secondary_ip_range = null
  }
]

peering_range = "10.253.4.0/22"
support_range = "10.253.1.0/28"
# Adding export routes for service network peering.
psa_config_export_routes = true

loadbalancer_name     = "pep-gal-asia-south1-xlb"
lb_hostnames          = ["sandbox", "prod"]
lb_certificate_prefix = "pep-gal-asia-south1-1-"