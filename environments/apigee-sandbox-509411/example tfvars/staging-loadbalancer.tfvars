project_id = "apigee-sandbox-509411"

apigee_instances = {
  cnx-portaldemo-apigee-sandbox-509411 = {
    region       = "europe-west1"
    environments = ["sandbox", "prod"]
  }
}

certificate_prefix = "apigee-sandbox-509411-"
external_ip       = null
name              = "apigee-sandbox-509411-staging"
hostnames         = ["sandbox", "prod"]
security_policy   = null
edge_security_policy = null
labels = {}
log_enable = true
log_samplerate = 1.0
