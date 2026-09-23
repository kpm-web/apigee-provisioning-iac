# Terraform Modules to setup APIGEE X with Private Service Connect (PSC) and External HTTPS Load Balancer

## Description
This Terraform module has been compiled using public modules offered by Google Cloud Foundation Fabric and Terraform Modules for APIGEE.
Execution of these modules will result in creating an APIGEE X Organization within the Google Project selected.
The following actions will be taken care as a part of the execution:

* Provisioning of a paid organization (Pay-as-you-go) of APIGEE X
* Creation of a Single Region APIGEE Runtime Instance
* Creation and configuration of Customer Managed Encryption Keys
* Configuration of Environments, Environment Groups, and their attachments
* Creating PSC Endpoints to establish connection between customer VPC and Apigee X
* Creation of an External Load Balancer and exposing the APIGEE Services to the Internet.

## Prerequisites
* A Google Project has been created in the Organization's Google Cloud
* Required APIGEE License mapping has been done for this project
* An IAM Account (User) / Service Account with preferred privileges has been provisioned. 
* It is recommended that this IAM User / Service Account is given the *Project Owner* role for the current project, if not must have atleast these roles assigned
        <ul>
            <li>roles/resourcemanager.projectIamAdmin</li>
            <li>roles/apigee.admin</li>
            <li>roles/cloudkms.admin</li>
            <li>roles/compute.admin</li>
            <li>roles/iam.serviceAccountAdmin</li>
            <li>roles/iam.serviceAccountUser</li>
            <li>roles/iam.serviceAccountKeyAdmin</li>
            <li>roles/servicenetworking.networksAdmin</li>
        </ul>
* If an External HTTPS Load Balancer has to be provisioned with a self managed SSL certificate, the public and private key files ar to be made available.
* If a predefined Static IP address has to be used for the External HTTPS Load Balancer, the IP address has to be configured.

## Tools and Softwares
On the host machine where the Terraform modules are to be executed, we need to have these below installed and initialized
* gcloud SDK
* Terraform version >= 1.1.0
* Any Text Editor

## Inputs
Please refer to the `variables.tf` file for the definition and details of the required variables.

## Execution Instructions

### Folder Structure
```bash
.
├── environments
│   ├── nonprod
│   │   ├── backend.hcl
│   │   └── gpo-internal-data.tfvars
│   ├── prod
│   │   ├── backend.hcl
│   │   └── gpo-prod.tfvars
│   └── staging
│       ├── backend.hcl
│       └── gpo-staging.tfvars
├── iac
│   ├── apigee-x-xlb-psc
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── provider-modules
│   │   ├── apigee-x-core
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── nb-psc-l7xlb
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   └── staging-loadbalancer
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── versions.tf
└── README.md
```

* While the `environments` directory has the required `.tfvars` independent for `nonprod` and `prod`, the actual scripts are underneath the `src` directory. `provider-modules` are the community modules imported.

* Under the `src`,  There are 2 folders:
    * `apigee-x-xlb-psc`
    * `staging-loadbalancer`
* To provision the entire Apigee X ecosystem, use `apigee-x-xlb-psc` with relevant configuration from `environments`
* To provision an additional loadbalancer, which we did for `staging` using `staging-loadbalancer` module.

| Action | Command |
| ------ | ------- |
| Format the Terraform files | `terraform fmt` |
|Initiate and Download the provider modules. This requires network access to the <a href="https://github.com/GoogleCloudPlatform/cloud-foundation-fabric" title="Google Cloud Foundation Fabric Git Hub repository">Google Cloud Foundation Fabric Git Hub repository</a>. | `terraform init` |
| After initial run, if needed, use flag -upgrade | `terraform init -upgrade` |
| In case there is a backend.hcl in use, use flag -reconfigure | `terraform init -upgrade -reconfigure -backend-config=../../environments/nonprod/backend.hcl` |
| Validate the script | `terraform validate` |
| Generate a terraform plan. | `terraform plan` |
| If you are not using the naming convention as "terraform.tfvars", please provide the variable file name. -out flag is optional, if included, the plan is saved to a .tfplan file which can be used during apply.| `terraform plan -var-file="example.tfvars" -out "name.tfplan"` |
| To create or modify the deployment. | `terraform apply` |
| If using a saved plan file (tfplan) | `terraform apply "name.tfplan"`|
| In this case, we have separate tfvars, apply the specific using | `terraform apply --var-file=../../environments/nonprod/gpo-internal-data.tfvars`|
| Additional commands that could be helpful ||
| To show the details of the deployment | `terraform show` |
| To show the outputs | `terraform output` |
| To destroy all the services created using script. If not using "terraform.tfvars" include the `-var-file` flag for specifying the variable file | `terraform destroy` |

## Additional Notes
* To configure a backend for terraform state storage, please update the details in the `versions.tf`

## Load Balancer Certificate
* Is currently a Google Managed Certificate provisioned for the hostnames provided in the tfvars.
* For Staging, which is serving traffic from PROD instance, we have a separate load balancer.

## Sources and References
* <a href="https://github.com/GoogleCloudPlatform/cloud-foundation-fabric">Google Cloud Foundation Fabric</a>
* <a href="https://github.com/apigee/terraform-modules">APIGEE Terraform Modules</a>