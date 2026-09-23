project_id   = "apigee-sandbox-509411"
billing_type = "EVALUATION"

ax_region = "europe-west1"
retention = "MINIMUM"

apigee_instances = {
  portaldemo-apigee-sandbox-509411 = {
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
  }
  prod = {
    display_name = "prod"
    description  = "prod"
    node_config  = null
    iam          = null
    envgroups    = ["envgrp-prod"]
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

apigee_org_kms_keyring_name         = "apigee-sandbox-509411-org-analytics-db"
apigee_inst_kms_keyring_name_prefix = "apigee-sandbox-509411-inst"

network = "apigee-sandbox-509411-network"

psc_ingress_network = "apigee-sandbox-509411-psc-ingress"

psc_ingress_subnets = [
  {
    name               = "apigee-sandbox-509411-psc"
    ip_cidr_range      = "10.253.0.0/24"
    region             = "europe-west1"
    secondary_ip_range = {}
  }
]

peering_range = "10.253.4.0/22"
support_range = "10.253.1.0/28"
psa_config_export_routes = true
project_parent = null
project_create = false

loadbalancer_name     = "apigee-sandbox-509411-xlb"
lb_hostnames          = ["sandbox", "prod"]
lb_certificate_prefix = "apigee-sandbox-509411-"
lb_log_enable         = true
lb_log_samplerate     = 1.0
