# Azure with Terraform

This lab introduces **Microsoft Azure infrastructure provisioning with Terraform**.

The goal is to move from Terraform fundamentals into practical Azure infrastructure while learning how Terraform manages Azure resources, networking, compute, identity, authentication, and private database connectivity.

The lab gradually builds from a simple Azure Resource Group to a complete private three-tier application foundation.

---

## Lab Structure

```text
09-azure/
│
├── README.md
│
├── 01-provider-resource-group/
│
├── 02-storage/
│
├── 03-networking/
│
├── 04-compute/
│
├── 05-identity/
│
└── 06-final-exercise/
```

Each folder is an independent Terraform root configuration.

This allows each exercise to have its own Terraform state while progressively introducing new Azure concepts.

---

# 1. Provider and Resource Group

Directory:

```text
01-provider-resource-group/
```

The first exercise introduces the AzureRM provider and basic Azure resource provisioning.

Example:

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
```

The exercise creates an Azure Resource Group and demonstrates:

- AzureRM provider configuration
- Resource creation
- Azure locations
- Resource Group naming
- Resource tags
- Terraform outputs
- Terraform state

Example tags used throughout the lab:

```hcl
tags = {
  AutoDelete = "yes"
  Owner      = "tarun"
}
```

---

# 2. Storage

Directory:

```text
02-storage/
```

This exercise introduces Azure Storage Accounts and demonstrates how a Terraform configuration can reference an existing Azure resource using a data source.

The Resource Group is discovered using:

```hcl
data "azurerm_resource_group" "lab" {
  name = "terraform-azure-lab-rg"
}
```

The Storage Account then uses information from the data source:

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "tfazlabstorage01"
  resource_group_name      = data.azurerm_resource_group.lab.name
  location                 = data.azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

Key concepts:

- Azure Storage Account
- Data sources
- Existing infrastructure
- Resource attributes
- Terraform state containing data-source information

---

# 3. Networking

Directory:

```text
03-networking/
```

This exercise introduces the fundamental Azure networking components required by a typical application architecture.

The network contains:

```text
VNet
10.0.0.0/16
│
├── Frontend subnet
│   10.0.1.0/24
│
├── Backend subnet
│   10.0.2.0/24
│
└── Database subnet
    10.0.3.0/24
```

Network Security Groups were created for each application tier.

### Frontend

Allows:

```text
TCP 80
TCP 443
```

### Backend

Allows:

```text
TCP 8080
Source: 10.0.1.0/24
```

### Database

Allows:

```text
TCP 1433
Source: 10.0.2.0/24
```

The NSGs are associated with their respective subnets.

The exercise demonstrates:

- Virtual Networks
- Subnets
- Network Security Groups
- Security rules
- Rule priorities
- Source address prefixes
- Subnet/NSG associations
- Terraform dependency inference
- Nested `security_rule` blocks

---

# 4. Compute

Directory:

```text
04-compute/
```

This exercise introduces Azure virtual machines and their networking components.

The lab creates:

```text
Frontend VM
    │
    └── Frontend NIC
        └── Frontend subnet

Backend VM
    │
    └── Backend NIC
        └── Backend subnet
```

Both VMs use:

```text
Standard_D2s_v5
Ubuntu 24.04 LTS
```

SSH authentication uses an existing public key:

```hcl
admin_ssh_key {
  username   = "azureuser"
  public_key = file("~/.ssh/id_rsa.pub")
}
```

No public IP addresses are required for the VMs.

Key concepts:

- Azure Network Interfaces
- Private IP addressing
- Linux Virtual Machines
- SSH public keys
- OS disks
- Image references
- VM-to-subnet relationships
- Resource dependencies

---

# 5. Identity and Authentication

Directory:

```text
05-identity/
```

This exercise focuses on Azure identity concepts and how Terraform authenticates with Azure.

## Managed Identity

The lab demonstrates:

- System-assigned managed identities
- User-assigned managed identities
- Attaching a user-assigned identity to an Azure resource
- Principal IDs
- Client IDs
- Tenant IDs
- Azure resource IDs

A useful distinction is:

```text
System-assigned identity
    → lifecycle tied to the Azure resource

User-assigned identity
    → independent identity that can be reused
```

---

## Service Principal

The lab also introduces the relationship between:

```text
Application Registration
        ↓
Service Principal
        ↓
Microsoft Entra ID
        ↓
RBAC
        ↓
Azure resources
```

Authentication and authorization were treated as separate concepts:

```text
Authentication
    → Who are you?

Authorization
    → What are you allowed to do?
```

---

## Terraform Authentication

Terraform communicates with Azure through the AzureRM provider:

```text
Terraform
    ↓
AzureRM provider
    ↓
Authentication
    ↓
Microsoft Entra ID
    ↓
Access token
    ↓
Azure Resource Manager
    ↓
RBAC
    ↓
Azure resources
```

Authentication methods discussed and tested include:

- Azure CLI authentication
- Service principal authentication through environment variables
- Managed identity
- OIDC / workload identity federation

OIDC is intentionally covered conceptually here and reserved for hands-on implementation in the Terraform CI/CD lab.

---

# 6. Final Exercise

Directory:

```text
06-final-exercise/
```

The final exercise combines the concepts from the previous exercises into a small private three-tier Azure architecture.

The architecture contains:

```text
                         Internet
                            │
                         80 / 443
                            │
                            ▼
                    ┌───────────────┐
                    │ Frontend VM   │
                    │ 10.0.1.0/24   │
                    └───────┬───────┘
                            │
                         TCP 8080
                            │
                            ▼
                    ┌───────────────┐
                    │ Backend VM    │
                    │ 10.0.2.0/24   │
                    └───────┬───────┘
                            │
                         TCP 5432
                            │
                            ▼
                  ┌───────────────────┐
                  │ PostgreSQL        │
                  │ Flexible Server   │
                  │ 10.0.3.0/24       │
                  │                   │
                  │ └── appdb         │
                  └─────────┬─────────┘
                            │
                     Private DNS
                            │
                            ▼
       terraform-azure-final-postgres.postgres.database.azure.com
```

---

## Resource Group

The final exercise creates:

```text
terraform-azure-final-rg
```

Terraform manages the Resource Group and applies the required tags.

Azure automation may add additional tags such as `CreatedOn`.

The lab demonstrates how Terraform lifecycle rules can be used when Azure-managed metadata should not be treated as configuration drift.

Example:

```hcl
lifecycle {
  ignore_changes = [
    tags["CreatedOn"]
  ]
}
```

---

# Virtual Network

The final VNet uses:

```text
10.0.0.0/16
```

with three tiers:

```text
Frontend
10.0.1.0/24

Backend
10.0.2.0/24

Database
10.0.3.0/24
```

The database subnet is delegated to:

```text
Microsoft.DBforPostgreSQL/flexibleServers
```

This allows Azure Database for PostgreSQL Flexible Server to use the subnet.

---

# Network Security

Three NSGs protect the application tiers.

## Frontend NSG

Allows:

```text
TCP 80
TCP 443
```

## Backend NSG

Allows:

```text
TCP 8080
Source: 10.0.1.0/24
```

## Database NSG

Allows:

```text
TCP 5432
Source: 10.0.2.0/24
```

The security model therefore follows the application flow:

```text
Frontend
   ↓
Backend
   ↓
Database
```

Each tier only receives the traffic required by the next layer.

---

# Compute

Two Linux VMs are created:

```text
Frontend VM
Backend VM
```

Both use:

```text
Standard_D2s_v5
Ubuntu 24.04 LTS
```

The VMs use private networking and do not require public IP addresses.

Each VM has its own Network Interface connected to its appropriate subnet.

---

# PostgreSQL Flexible Server

The final exercise creates a private Azure Database for PostgreSQL Flexible Server.

Configuration includes:

```text
PostgreSQL 16
B_Standard_B1ms
32 GiB storage
7-day backup retention
Public network access disabled
```

The server is deployed into the delegated database subnet.

```text
Backend subnet
       │
       │ TCP 5432
       ▼
Database subnet
       │
       ▼
PostgreSQL Flexible Server
```

The PostgreSQL administrator password is supplied through a sensitive Terraform variable and local `terraform.tfvars`.

Secrets are intentionally excluded from Git.

---

# PostgreSQL Database

A logical PostgreSQL database is created inside the server:

```text
appdb
```

Terraform manages it using:

```hcl
resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.example.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
```

This demonstrates the distinction between:

```text
PostgreSQL Flexible Server
    → infrastructure / managed database server

PostgreSQL database
    → logical database hosted by that server
```

---

# Private DNS

The final exercise uses an Azure Private DNS Zone:

```text
terraform-azure-final.postgres.database.azure.com
```

The zone is linked to the application VNet.

The PostgreSQL server exposes the hostname:

```text
terraform-azure-final-postgres.postgres.database.azure.com
```

The intended application flow is:

```text
Backend VM
    │
    │ DNS query
    ▼
Private DNS Zone
    │
    │ private resolution
    ▼
PostgreSQL Flexible Server
    │
    └── appdb
```

The backend application can therefore use the PostgreSQL hostname instead of depending on a hard-coded private IP address.

Public network access to the PostgreSQL server remains disabled.

---

# Terraform Lifecycle and Azure Drift

The final exercise also demonstrates an important real-world Terraform issue.

Azure services and policies may modify resources after Terraform creates them.

For example:

```text
Terraform configuration
        ↓
Azure resource
        ↓
Azure automation/policy modifies metadata
        ↓
Terraform detects difference
```

The appropriate response is not always to force Azure back to the Terraform configuration.

When a specific attribute is intentionally managed outside Terraform, `ignore_changes` can be used.

This was demonstrated with the Resource Group's `CreatedOn` tag and the Azure-managed PostgreSQL subnet service endpoint.

---

# Sensitive Values

The PostgreSQL administrator password is stored locally through:

```text
terraform.tfvars
```

The repository ignores Terraform variable files:

```gitignore
*.tfvars
*.tfvars.json
```

Sensitive values should never be committed to Git.

The README intentionally does not contain:

- Passwords
- Client secrets
- Access tokens
- Private keys
- Other credentials

---

# Final Terraform Workflow

The final exercise follows the normal Terraform workflow:

```text
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
terraform output
        ↓
terraform plan
        ↓
No changes
```

The final configuration was verified with:

```text
terraform plan
```

and reached:

```text
No changes.
Your infrastructure matches the configuration.
```

---

# Key Terraform Concepts Practiced

The Azure lab combines several Terraform fundamentals:

```text
Providers
Resources
Data sources
Variables
Outputs
Expressions
Dependencies
for_each
Lifecycle
Sensitive values
State
```

These concepts are applied to actual Azure infrastructure rather than isolated examples.

---

# Key Azure Concepts Practiced

```text
Resource Groups
Storage Accounts
Virtual Networks
Subnets
Network Security Groups
Network Interfaces
Virtual Machines
Managed Identities
Service Principals
Microsoft Entra ID
PostgreSQL Flexible Server
Private DNS
Subnet Delegation
Private Networking
```

---

# Final Architecture

The completed lab represents a simplified enterprise-style three-tier application foundation:

```text
                         Internet
                            │
                     ┌──────┴──────┐
                     │   Frontend  │
                     │     VM      │
                     └──────┬──────┘
                            │
                          8080
                            │
                     ┌──────▼──────┐
                     │   Backend   │
                     │     VM      │
                     └──────┬──────┘
                            │
                          5432
                            │
                  ┌─────────▼─────────┐
                  │    PostgreSQL     │
                  │  Flexible Server  │
                  └─────────┬─────────┘
                            │
                       Private DNS
                            │
                            ▼
                         appdb
```

Network isolation:

```text
VNet: 10.0.0.0/16
│
├── Frontend: 10.0.1.0/24
│
├── Backend: 10.0.2.0/24
│
└── Database: 10.0.3.0/24
```

The important architectural principle is:

```text
Internet
   ↓
Frontend
   ↓
Backend
   ↓
Database
```

with each tier separated by network boundaries and NSG rules.

---

# What This Lab Demonstrates

The progression of this lab is intentional:

```text
Azure Provider
      ↓
Resource Group
      ↓
Storage
      ↓
Networking
      ↓
Compute
      ↓
Identity
      ↓
Authentication
      ↓
Private Database
      ↓
Private DNS
      ↓
Three-tier architecture
```

The final exercise demonstrates how individual Azure resources become a connected infrastructure system managed entirely through Terraform.

---

# Terraform Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform apply --auto-approve
terraform output
terraform destroy
```

---

# Azure Lab Progress

```text
01-provider-resource-group    ✓
02-storage                    ✓
03-networking                 ✓
04-compute                    ✓
05-identity                   ✓
06-final-exercise             ✓
```

The Azure section of the Terraform Fundamentals repository is now complete.

---

# Terraform Fundamentals Progress

```text
01-basics
02-variables
03-outputs
04-data-sources
05-expressions
06-meta-arguments
07-state
08-modules
09-azure                 ← current
10-final-project
```

The next major stage is the **Terraform Final Project**, where the concepts learned throughout the fundamentals series can be combined into a larger infrastructure design.