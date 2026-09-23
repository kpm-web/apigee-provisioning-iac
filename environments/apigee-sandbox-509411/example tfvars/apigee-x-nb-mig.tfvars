project_id   = "apigee-sandbox-509411"
billing_type = "EVALUATION"

project_parent = null
project_create = false
services       = []

network = "apigee-sandbox-509411-network"
vpc_host_project_id = "apigee-sandbox-509411"
vpc_create          = false

peering_range = "10.253.4.0/22"
support_range = "10.253.1.0/28"
apigee_subnet = "apigee"

ax_region = "europe-west1"
retention = "MINIMUM"

apigee_instances = {
  cnx-portaldemo-apigee-sandbox-509411 = {
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

mig_name           = "apigee-mig"
mig_network_tags   = ["apigee-bridge"]
mig_machine_type   = "e2-small"
boot_disk_image    = "debian-cloud/debian-12"
image_type         = "pd-standard"
disk_size          = 20
mig_target_size    = 2
autoscaler_config  = null
mig_startup_script = "gs://apigee-5g-saas/apigee-envoy-proxy-release/latest/conf/startup-script-envoy.sh"
mig_create_service_account = true
mig_ssh_source_range       = ["0.0.0.0/0"]

loadbalancer_name = "apigee-sandbox-509411-xlb"
lb_external_ip    = null
lb_cert_cn        = "temp-cert"
lb_cert_org       = "DummyOrg"
lb_cert_domain    = ["dummyorg.com"]
lb_cert_validity  = 24
lb_log_enable     = true
lb_log_samplerate = 1.0
lb_outbound_range = ["130.211.0.0/22", "35.191.0.0/16"]
