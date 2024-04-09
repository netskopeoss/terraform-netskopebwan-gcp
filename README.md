# Netskope SD-WAN GW GCP Module

This Infrastructure as Code (IaC) will help you deploy Netskope SD-WAN Gateway in your GCP environment in following scenarios:
- Deploy and activate Netskope SD-WAN Gateway in a new VPC and connect to a new Cloud Router
- Deploy and activate Netskope SD-WAN Gateway in an existing VPC with a new Cloud Router
- Deploy Gateway with multiple WAN links / interfaces
- Optional client deployment for end to end solution validation

This module creates / configures the following objects in GCP and Netskop SD-WAN Portal:

## GCP Cloud
   - VPC per interface (Re-use existing or create new one) 
   - Subnets (always creates new one)
   - Network Connectivity Hub
   - Cloud Router
   - Firewall Rules (For both WAN network and Private network)
   - BGP Peering in Cloud Router to Netskope SD-WAN (This module will provide the actual command to manually execute)
   - Host VPC / VM and required peerings (if chosen)

## Netskope SD-WAN Portal
   - Create new policy
   - Create new gateway (HA deployment is optional)
   - Configure required static routes and BGP peers

## Key Points

- The default username for the gateway is "infiot". Password authentication is disabled and you must use SSH keys to authenticate.
- This module has an option to set the password for the default username "infiot". This will be used only for console access.

## Known Limitations

1) Since terraform provider APIs for Cloud Router has issues when trying to add redundant interfaces, following configurations should be done through CLIs
      * Cloud router interface configuration
      * BGP Peering configuration in GCP

   This terraform module will help you the actual command to be executed when you apply this module.

## Architecture Diagram

This IaC will create the GCP resources as shown below.

![](.//images/gcp.png)

*Fig 1. Netskope SD-WAN GW deployment in GCP*

## Deployment

To deploy this template in GCP:

- Make sure that the account you're connected with the BWAN web console is `System Admin`. By default, admin accounts are just "Admin", which is not sufficient. If you're not `System Admin`, please ask your admin (or your Netskope Team) to raise permissions.  
  
- Identify the "Base URL" for your Netskope SD-WAN Tenant. This is a URL that you use to access your Netskope tenant, for example: `https://example.infiot.net`
  This will be set in "netskope_tenant" variable blob

- Get the ID of your Tenant from Netskope Team. Otherwise, if you've got CLI access to one of your gateways, you can get the ID using the command:
  ```
  docker exec -it infiot_spoke cat inf_config.json | grep -A 2 iss_tenant
  ```

- Create a REST API Token as follows:

![API Token](images/api-token.png)

If you'd like to copy/paste token's permissions, please use these parameters:

**Please note:** Token's expiration is set to 1 hour by default, so change it to the value you need!
```
[
  {
	"rap_resource": "",
	"rap_privs": [
		"privSiteCreate",
		"privSiteRead",
		"privSiteWrite",
		"privSiteDelete",
		"privSiteToken",
		"privSiteRestart",
		"privSiteOpsRead",
		"privSiteOpsWrite",
		"privTokenRead",
		"privPolicyCreate",
		"privPolicyRead",
		"privPolicyWrite",
		"privPolicyDelete",
		"privAppRead",
		"privAuditRecordCreate"
	]
  }
]
```

*Fig 2. Netskope SD-WAN Portal API Token*

- Clone the GitHub repository for this deployment.

- Configure provider block or set variables in the "provider.tf" file.

- Customize variables in the `example.tfvars` and `variables.tf` file as needed.
- Change to the repository directory and then initialize the providers and modules.

   ```sh
   $ cd <Code Directory>
   $ terraform init
    ```
- Submit the Terraform plan to preview the changes Terraform will make to match your configuration.

   ```sh
   $ terraform plan -var-file=example.tfvars
   ```
- Apply the plan. The apply will make no changes to your resources, you can either respond to the confirmation prompt with a 'Yes' or cancel the apply if changes are needed.

   ```sh
   $ terraform apply -var-file=example.tfvars
   ```

## Destruction

- To destroy this deployment, use the command:

   ```sh
   $ terraform destroy -var-file=example.tfvars
   ```

## Support

Netskope-provided scripts in this and other GitHub projects do not fall under the regular Netskope technical support scope and are not supported by Netskope support services.
