# Apigee X + PSC + External HTTPS Load Balancer Terraform

This repository contains Terraform modules for deploying an Apigee X environment in Google Cloud with Private Service Connect (PSC), networking, and external HTTPS load balancing. The implementation is built on top of Google Cloud Foundation Fabric modules and wraps the required Apigee-specific components into a reusable structure.

## What this repo deploys

This repository contains multiple Terraform configuration patterns for provisioning Apigee X and its supporting networking components. These are not required to run together at the same time; they represent different provisioning use cases depending on the target environment and deployment objective.

Examples include:

- Apigee X organization and runtime instance
- Environment and environment group configuration
- Customer-managed encryption key setup
- VPC and private connectivity for PSC
- External HTTPS load balancer fronting Apigee services
- Staging or auxiliary load balancer deployments

## Repository layout

```text
.
├── README.md
├── LICENSE
├── .gitignore
├── environments/
│   ├── demo/
│   ├── nonprod/
│   ├── prod/
│   ├── trial/
│   └── apigee-sandbox-509411/
│       ├── terraform.tfvars
│       ├── x-nb-psc-xlb.tfvars
│       ├── apigee-x-nb-mig.tfvars
│       ├── external-loadbalancer-psc-backend.tfvars
│       └── staging-loadbalancer.tfvars
├── iac/
│   ├── provider-modules/
│   │   ├── apigee-x-core/
│   │   ├── apigee-x-client-vm/
│   │   ├── apigee-x-bridge-mig/
│   │   ├── mig-l7xlb/
│   │   ├── nb-psc-l7xlb/
│   │   ├── network-data/
│   │   └── ...
│   └── src/
│       ├── x-nb-psc-xlb/
│       │   └── .terraform/
│       ├── apigee-x-nb-mig/
│       │   └── .terraform/
│       ├── external-loadbalancer-psc-backend/
│       │   └── .terraform/
│       ├── staging-loadbalancer/
│       │   └── .terraform/
│       └── ...
└── .terraform/   # only when a root-level execution is used
```

The active deployment modules in the current repo are primarily located under `iac/src/`. Each module directory is executed independently and typically contains its own local `.terraform/` working directory after `terraform init`.

## Prerequisites

Before running Terraform, make sure you have:

- A Google Cloud project created and billing enabled
- Apigee license activation completed for the target project
- Google Cloud SDK installed and authenticated with `gcloud auth application-default login`
- Terraform installed, version 1.3 or newer recommended
- An IAM principal or service account with sufficient permissions, including at least:
  - `roles/resourcemanager.projectIamAdmin`
  - `roles/apigee.admin`
  - `roles/cloudkms.admin`
  - `roles/compute.admin`
  - `roles/iam.serviceAccountAdmin`
  - `roles/iam.serviceAccountUser`
  - `roles/servicenetworking.networksAdmin`

## How to deploy

Each module under `iac/src/` represents a specific provisioning scenario or configuration path. In practice, only one of these modules is initialized and deployed at a given time based on the requirement being implemented.

### Conditional deployment pattern

Choose the target module based on the requirement:

- If you are provisioning the core Apigee environment and related project/networking foundation, use `iac/src/apigee-x-nb-mig`
- If you are provisioning the PSC-based northbound ingress path and egress design, use `iac/src/x-nb-psc-xlb`
- If you are creating the external HTTPS load balancer front end, use `iac/src/external-loadbalancer-psc-backend`
- If you are configuring a staging or secondary load balancer path, use `iac/src/staging-loadbalancer`

### Example workflow for a single required deployment

```bash
cd iac/src/x-nb-psc-xlb
terraform init
terraform plan -var-file="../../environments/apigee-sandbox-509411/x-nb-psc-xlb.tfvars" -out x-nb-psc-xlb.tfplan
terraform apply x-nb-psc-xlb.tfplan
```

### Alternative use-case examples

```bash
cd iac/src/apigee-x-nb-mig
terraform init
terraform plan -var-file="../../environments/apigee-sandbox-509411/apigee-x-nb-mig.tfvars" -out apigee-x-nb-mig.tfplan
terraform apply apigee-x-nb-mig.tfplan
```

```bash
cd iac/src/external-loadbalancer-psc-backend
terraform init
terraform plan -var-file="../../environments/apigee-sandbox-509411/external-loadbalancer-psc-backend.tfvars" -out external-loadbalancer-psc-backend.tfplan
terraform apply external-loadbalancer-psc-backend.tfplan
```

```bash
cd iac/src/staging-loadbalancer
terraform init
terraform plan -var-file="../../environments/apigee-sandbox-509411/staging-loadbalancer.tfvars" -out staging-loadbalancer.tfplan
terraform apply staging-loadbalancer.tfplan
```

### Common commands

```bash
terraform fmt
terraform validate
terraform show
terraform output
terraform destroy
```

### Deployment principle

These module directories are intentionally independent. The repo supports multiple provisioning scenarios, and the correct execution is chosen conditionally based on the environment requirement at that point in time.

## Notes

- For production use, move environment-specific values into secure secret management or a remote backend configuration.
- The repository includes environment-specific tfvars samples for a sandbox-oriented deployment and can be extended for nonprod, prod, or other regional setups.
- If you are using a remote backend or Terraform Cloud, configure the backend before running `terraform init`.

## References

- **[Google Cloud Foundation Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric)**. 

- **[Apigee Terraform Modules](https://github.com/GoogleCloudPlatform/apigee-terraform-modules)**.

- **[Apigee API Management](https://cloud.google.com/apigee)**.
