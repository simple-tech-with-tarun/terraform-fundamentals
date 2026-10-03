# Terraform Final Project

This project brings together the Terraform concepts covered throughout this repository into a complete Azure infrastructure deployment.

The goal is to build a small but realistic **three-tier-style Azure environment** using reusable Terraform modules, variables, locals, expressions, networking controls, private database connectivity, and Terraform outputs.

The infrastructure is deployed into a **single Azure subscription** and is designed as a learning project rather than a production-ready enterprise platform.

---

## Architecture

The environment consists of three logical tiers:

```text
                         Azure Resource Group
                    terraform-final-project-rg
                               │
                               │
                        Virtual Network
                         10.0.0.0/16
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
       Frontend Subnet    Backend Subnet    Database Subnet
        10.0.1.0/24       10.0.2.0/24       10.0.3.0/24
             │                 │                 │
             │                 │                 │
          NSG :80/443       NSG :8080          NSG :5432
             │                 │                 │
             ▼                 ▼                 ▼
        Frontend VM        Backend VM       PostgreSQL
                                               Flexible
                                                Server
                                                  │
                                                  │
                                           Private DNS Zone
                                                  │
                                                  ▼
                                      PostgreSQL private DNS
```

### Network design

| Tier | Subnet | Purpose |
|---|---|---|
| Frontend | `10.0.1.0/24` | Frontend virtual machine |
| Backend | `10.0.2.0/24` | Backend virtual machine |
| Database | `10.0.3.0/24` | Azure Database for PostgreSQL Flexible Server |

The virtual network uses:

```text
10.0.0.0/16
```

---

## Azure Resources

The final deployment contains **19 Terraform-managed resources**.

### Resource Group

```text
terraform-final-project-rg
```

### Networking

- 1 Virtual Network
- 3 Subnets
- 3 Network Security Groups
- 3 Subnet/NSG associations

### Compute

- 2 Network Interfaces
- 2 Linux Virtual Machines

### Database

- 1 PostgreSQL Flexible Server
- 1 PostgreSQL database
- 1 Private DNS Zone
- 1 Private DNS Zone → VNet link

---

## Terraform Module Structure

The project uses reusable child modules:

```text
10-final-project/
│
├── main.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── README.md
│
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── compute/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── database/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Network module

The network module is responsible for:

- Virtual Network creation
- Frontend, backend, and database subnets
- Network Security Groups
- NSG rules
- Subnet/NSG associations
- PostgreSQL subnet delegation

### Compute module

The compute module creates the frontend and backend Linux virtual machines and their network interfaces.

The VMs are connected directly to the appropriate subnets and do not use public IP resources.

### Database module

The database module creates:

- Azure Database for PostgreSQL Flexible Server
- PostgreSQL application database
- Private DNS Zone
- Private DNS Zone/VNet link

The PostgreSQL server is deployed using private networking.

---

## Network Security

The three NSGs provide basic tier-to-tier traffic restrictions.

### Frontend NSG

Allows:

```text
TCP 80
TCP 443
```

from:

```text
*
```

### Backend NSG

Allows:

```text
TCP 8080
```

from:

```text
10.0.1.0/24
```

This limits backend application traffic to the frontend subnet.

### Database NSG

Allows:

```text
TCP 5432
```

from:

```text
10.0.2.0/24
```

This limits PostgreSQL traffic to the backend subnet.

---

## PostgreSQL Private Networking

The PostgreSQL Flexible Server does not use public network access.

The database subnet is delegated to:

```text
Microsoft.DBforPostgreSQL/flexibleServers
```

with the required subnet action:

```text
Microsoft.Network/virtualNetworks/subnets/join/action
```

The database subnet is:

```text
10.0.3.0/24
```

A private DNS zone is also created:

```text
terraform-final-project.postgres.database.azure.com
```

and linked to the virtual network.

This allows PostgreSQL name resolution through the private network rather than relying on public database access.

---

## Compute Configuration

Two Ubuntu Linux virtual machines are deployed:

```text
Frontend VM
Backend VM
```

Both VMs use:

```text
Ubuntu 24.04 LTS
```

and:

```text
Standard_D2s_v5
```

The VMs use private IP addresses only.

The final private IPs are exposed through Terraform outputs.

---

## Terraform Concepts Demonstrated

This final project combines the main Terraform concepts practiced throughout the repository.

### Providers

The AzureRM provider is configured for Azure resource management.

### Variables

Input variables are used to make the configuration reusable and configurable.

### Locals

Local values are used for:

- Naming
- Common configuration
- Derived values
- Resource maps

### Expressions

The configuration uses Terraform expressions including:

- Maps
- Objects
- `for` expressions
- Conditional expressions
- Derived values

### Modules

The root module composes three reusable modules:

```text
network
compute
database
```

### Module dependencies

The modules are connected through their outputs and inputs.

For example:

```text
network
   │
   ├── VNet
   ├── subnets
   │
   └──────────────┐
                  ▼
               compute
                  │
                  └── VM private IPs

network
   │
   └── database subnet
              │
              ▼
           database
              │
              ├── PostgreSQL
              └── Private DNS
```

This allows Terraform to build the dependency graph automatically.

### Outputs

The root module exposes useful deployment information without exposing credentials.

---

## Terraform Outputs

After deployment:

```text
backend_private_ip   = "10.0.2.4"
database_name        = "appdb"
frontend_private_ip  = "10.0.1.4"
postgresql_fqdn      = "terraform-final-project-postgres.postgres.database.azure.com"
resource_group_name  = "terraform-final-project-rg"
virtual_network_name = "terraform-final-project-vnet"
```

Sensitive database credentials are intentionally not exposed through outputs.

---

## Deployment

Initialize the Terraform working directory:

```powershell
terraform init
```

Format the configuration:

```powershell
terraform fmt
```

Validate the configuration:

```powershell
terraform validate
```

Review the execution plan:

```powershell
terraform plan
```

Deploy the infrastructure:

```powershell
terraform apply
```

For an automated lab deployment:

```powershell
terraform apply --auto-approve
```

---

## Validation

The final configuration was validated using:

```powershell
terraform validate
```

The configuration successfully validated.

After deployment, the infrastructure was checked using:

```powershell
terraform plan
```

The final result was:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms that the deployed Azure infrastructure matches the Terraform configuration.

The Terraform state was also inspected:

```powershell
terraform state list
```

The final state contains **19 managed resources**.

Outputs were verified using:

```powershell
terraform output
```

---

## Final Deployment Result

The final deployment completed successfully.

Terraform reported:

```text
Apply complete! Resources: 0 added, 2 changed, 0 destroyed.
```

The two changes were the removal of:

- An Azure-side `CreatedOn` resource-group tag that was not part of the Terraform configuration.
- An unnecessary `Microsoft.Storage` service endpoint from the PostgreSQL database subnet.

The PostgreSQL subnet delegation remained intact.

A subsequent `terraform plan` confirmed:

```text
No changes. Your infrastructure matches the configuration.
```

---

## Cleanup

Because this is a learning environment, the infrastructure can be destroyed when it is no longer required.

Run:

```powershell
terraform destroy
```

Or:

```powershell
terraform destroy --auto-approve
```

This removes the Terraform-managed Azure resources.

> **Warning:** `terraform destroy` is destructive. Do not run it against infrastructure that contains data or resources you need to keep.

---

## Important Notes

### Credentials

Database credentials are provided through Terraform variables and are not exposed through Terraform outputs.

Sensitive values should not be committed to source control.

If using a local `terraform.tfvars` file containing secrets, ensure that it is included in `.gitignore` where appropriate.

### Learning environment

This project intentionally keeps the architecture relatively simple.

It does not attempt to implement every production Azure capability such as:

- Azure Application Gateway
- Azure Firewall
- Azure Bastion
- Availability Zones across multiple tiers
- VM Scale Sets
- Azure Monitor
- Log Analytics
- Key Vault integration
- Managed identities
- Hub-and-spoke networking

Those capabilities can be explored in dedicated Azure labs.

---

## Lessons Learned

This project demonstrates how individual Terraform concepts combine into a complete infrastructure deployment.

Key takeaways include:

1. **Modules provide reusable infrastructure building blocks.**

2. **The root module should compose modules rather than contain every resource directly.**

3. **Module outputs and inputs create clear dependencies between infrastructure components.**

4. **Terraform automatically builds a dependency graph from resource and module references.**

5. **Network segmentation is important even in a small three-tier environment.**

6. **NSGs can restrict communication between application tiers.**

7. **Azure managed services may require specific subnet delegation.**

8. **Private DNS is an important part of private connectivity for managed services.**

9. **Terraform outputs provide a clean way to expose useful infrastructure information.**

10. **`terraform plan` is essential for detecting configuration drift before making changes.**

11. **A successful `terraform apply` does not by itself prove that the configuration is clean. A subsequent `terraform plan` should be used to verify that the deployed infrastructure matches the configuration.**

12. **Terraform state provides the mapping between Terraform configuration and real Azure resources.**

---

## Final Status

The final project has been successfully deployed and validated.

```text
Terraform configuration
        │
        ▼
Terraform modules
        │
        ▼
Azure infrastructure
        │
        ▼
terraform plan
        │
        ▼
No changes
```

The project demonstrates a complete Terraform workflow from modular configuration through deployment, validation, outputs, state inspection, and cleanup.