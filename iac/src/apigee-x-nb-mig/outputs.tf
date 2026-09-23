output "apigee_org_id" {
  description = "APIGEE Org ID"
  value       = module.apigee-x-core.org_id
}

output "apigee_instance_endpoints" {
  description = "Endpoint information for the APIGEE Instances created"
  value       = module.apigee-x-core.instance_endpoints
}

output "apigee_instance_service_attachments" {
  description = "APIGEE Instance Service Attachments"
  value       = module.apigee-x-core.instance_service_attachments
}

#Comment this output if MIG is not chosen to be created

# output "apigee_mig" {
#   description = "Managed Instance Group created for APIGEE"
#   value       = [for _, mig in module.apigee-x-bridge-mig : mig.instance_group]
# }

# #Comment these 2 output if External Load Balancer is not chosen to be created

# output "lb_ip_address" {
#   description = "Load Balancer IP"
#   value       = module.mig-l7xlb.lb_ip
#   depends_on = [
#     module.mig-l7xlb
#   ]
# }

# output "lb_certificate" {
#   description = "Self Link for Load Balancer certificate"
#   value       = module.mig-l7xlb.certificate_self_link
#   depends_on = [
#     module.mig-l7xlb
#   ]
# }


