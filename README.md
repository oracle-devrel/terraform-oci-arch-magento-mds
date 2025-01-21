# terraform-oci-arch-magento-mds

## Reference Architecture

Deploy Magento e-commerce on Oracle Cloud Intrastructure (OCI) and MySQL Database Service (MDS) using these Terraform modules.

This Terraform code spins up one or more Oracle Cloud Infrastructure (OCI) instances after creating the required OCI networking components, deploys Magento on the instance(s) and creates a MySQL Database System (with High Availability if desired).

For more details on the architecture, see [_Deploy Magento eCommerce on Oracle Linux with MySQL Database Service_](https://docs.oracle.com/en/solutions/magento-with-mds/index.html)

## Architecture Diagram 

### Single-node Architecture (1 Magento VM, single node MDS)

![](./images/magento-mds-single.png)

### Multi-node Architecture (2+ Magento VMs, shared FSS, Load Balancer and MDS HA)

![](./images/magento-mds-multi.png)

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets`, `mysql-family`, and `instances`.

- Quota to create the following resources: 1 VCN, 2 subnets, 1 Internet Gateway, 1 NAT Gateway, 2 route rules, 1 MySQL Database System (MDS) instance, and 1 (or more) compute instance(s) for Magento.

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-magento-mds/releases/latest/download/terraform-oci-arch-magento-mds-stack-latest.zip)


    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

```
    git clone https://github.com/oracle-devrel/terraform-oci-arch-magento-mds.git
    cd terraform-oci-arch-magento-mds
    ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid        = "<tenancy_ocid>"
user_ocid           = "<user_ocid>"
fingerprint         = "<finger_print>"
private_key_path    = "<pem_private_key_path>"

region              = "<oci_region>"
compartment_ocid    = "<compartment_ocid>"

# MySQL and Magento variables
admin_password         = "<admin_password>"
magento_password       = "<magento_password>"
magento_admin_password = "<magento_admin_password>"
magento_admin_email    = "user.name@example.com"
numberOfNodes          = 1 # value 2+ for multinode scenario will be deployed inluding LB & FSS.
````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Deploy as a Module
It's possible to utilize this repository as remote module, providing the necessary inputs:

```
module "oci-arch-magento-mds" {
  source                        = "github.com/oracle-devrel/terraform-oci-arch-magento-mds"
  tenancy_ocid                  = "<tenancy_ocid>"
  user_ocid                     = "<user_ocid>"
  fingerprint                   = "<finger_print>"
  private_key_path              = "<private_key_path>"
  region                        = "<oci_region>"
  compartment_ocid              = "<compartment_ocid>"
  admin_password                = "<admin_password>"
  magento_password              = "<magento_password>"
  magento_admin_password        = "<magento_admin_password>"
  magento_admin_email           = "user.name@example.com"
  numberOfNodes                 = 1
}
```

### Testing your Deployment
After the deployment is finished, you can access Magento home page by picking magento_home_URL from the output and pasting it into web browser window.

````
magento_home_URL = "http://193.122.198.20/"
`````

If you wan to access Magento backend then you need to pickup magento_backend_URL from the output and paste it into web browser window. Then use magento_backend_username and magento_backend_password to authorize the access to Magento backend pages.

````
magento_backed_URL       = "http://193.122.198.20/index.php/magento_admin/"
magento_backend_password = "BEstrO0ng_#11"
magento_backend_username = "admin"
`````

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## Attribution & Credits
This repository was initially inspired on the materials found in [lefred's blog](https://lefred.be/content/deploy-magento-on-mds-heatwave/). One of the enhancements done to the materials in question was the adoption of the [OCI Cloudbricks MySQL module](https://github.com/oracle-devrel/terraform-oci-cloudbricks-mysql-database).
That being the case, we would sincerely like to thank:
- Frédéric Descamps (https://github.com/lefred)
- Denny Alquinta (https://github.com/dralquinta)

## License
Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE.txt) for more details.
