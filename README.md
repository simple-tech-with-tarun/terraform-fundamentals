# Terraform Fundamentals

A practical reference for learning **Terraform and Infrastructure as Code** through concepts, examples, and hands-on exercises.

This repository focuses on the fundamentals of Terraform, including configuration, providers, resources, variables, state management, modules, dependencies, and common Infrastructure as Code practices.

The goal is to understand **how Terraform works and why its different components are used**, rather than simply memorizing Terraform commands.

---

## 📚 What You'll Find Here

This repository covers the core Terraform concepts required to build and manage infrastructure using Infrastructure as Code.

### Terraform Fundamentals

- Infrastructure as Code concepts
- Terraform configuration
- Providers
- Resources
- Data sources
- Variables
- Local values
- Outputs
- Expressions
- Functions
- Meta-arguments
- Dependencies
- Terraform state
- Backend configuration
- Workspaces
- Modules
- Terraform lifecycle
- Plan and apply workflows
- Validation and troubleshooting
- Terraform best practices

### Hands-on Practice

The concepts are reinforced through practical Terraform configurations and Azure infrastructure.

The exercises progressively introduce:

- Basic Terraform configuration
- Azure provider configuration
- Resource creation
- Variables and outputs
- Resource dependencies
- State management
- Data sources
- Expressions and functions
- Meta-arguments
- Lifecycle configuration
- Modules
- Reusable infrastructure
- Network infrastructure
- Compute resources
- Database infrastructure

---

## 🏗️ Infrastructure as Code

Infrastructure as Code allows infrastructure to be defined and managed using declarative configuration.

Instead of manually creating infrastructure through a cloud portal, Terraform describes the desired state of the infrastructure in configuration files.

A typical Terraform workflow looks like this:

```text
Terraform Configuration
        │
        ▼
terraform init
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
Review Changes
        │
        ▼
terraform apply
        │
        ▼
Infrastructure
        │
        ▼
terraform output
        │
        ▼
Verify Infrastructure
```

When infrastructure is no longer required:

```text
terraform destroy
```

---

## 🔄 Terraform Workflow

A common Terraform workflow used throughout this repository is:

### Initialize

```bash
terraform init
```

Initializes the working directory and downloads the required providers and modules.

### Validate

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

### Plan

```bash
terraform plan
```

Creates an execution plan showing what Terraform intends to change.

### Apply

```bash
terraform apply
```

Applies the planned changes to the target infrastructure.

### Output

```bash
terraform output
```

Displays values exposed through Terraform outputs.

### Inspect State

```bash
terraform state list
```

Lists resources currently tracked by Terraform state.

### Destroy

```bash
terraform destroy
```

Removes infrastructure managed by the Terraform configuration.

---

## 🧩 Repository Structure

The repository is organized as a progressive learning path.

Each section introduces a Terraform concept and builds on concepts introduced earlier.

```text
terraform-fundamentals/
│
├── 01-...
├── 02-...
├── 03-...
├── ...
├── 10-final-project/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── README.md
│   │
│   └── modules/
│       ├── network/
│       ├── compute/
│       └── database/
│
└── README.md
```

The exact contents of the individual sections may evolve as additional Terraform concepts and exercises are added.

---

## 🧠 Core Terraform Concepts

### Providers

Providers allow Terraform to interact with external platforms and APIs.

For example, this repository uses the **AzureRM provider** for Azure infrastructure.

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
```

---

### Resources

Resources represent infrastructure objects managed by Terraform.

Examples include:

- Resource groups
- Virtual networks
- Subnets
- Network Security Groups
- Virtual machines
- Databases

---

### Variables

Variables make Terraform configurations reusable and configurable.

Instead of hardcoding values throughout a configuration, variables can be used to provide inputs.

```hcl
variable "location" {
  type    = string
  default = "centralindia"
}
```

---

### Local Values

Local values allow commonly used expressions or values to be defined once and referenced throughout the configuration.

```hcl
locals {
  environment = "lab"
}
```

---

### Outputs

Outputs expose useful information from Terraform configurations.

Examples include:

- Resource IDs
- Private IP addresses
- Resource names
- DNS names
- Endpoint information

Outputs are especially useful when one module needs to expose information to another module or when users need important information after deployment.

---

### Expressions and Functions

Terraform expressions and functions allow configurations to become dynamic and reusable.

Examples include:

- Conditional expressions
- String functions
- Collection functions
- Numeric functions
- Lookup operations
- `for` expressions

---

### Dependencies

Terraform builds a dependency graph to determine the order in which resources should be created, updated, or destroyed.

Dependencies can be:

- Implicit
- Explicit

Understanding dependencies is important when designing reliable Terraform configurations.

---

## 📦 Modules

Modules allow Terraform configurations to be organized into reusable components.

The final project demonstrates a modular architecture containing separate modules for:

```text
Root Module
   │
   ├── Network Module
   │
   ├── Compute Module
   │
   └── Database Module
```

This demonstrates how infrastructure can be separated into logical components while still being composed into a single deployment.

---

## 🗃️ Terraform State

Terraform state is a fundamental part of Terraform.

It allows Terraform to keep track of the infrastructure it manages and compare the current infrastructure with the desired configuration.

Important concepts covered in this repository include:

- `terraform.tfstate`
- State inspection
- Resource tracking
- State drift
- State locking
- Remote state
- Backend configuration

Understanding state is critical when working with Terraform in real environments.

---

## 🔐 Backend and State Management

Terraform state can be stored locally or remotely.

Remote state becomes particularly important when working in:

- Teams
- CI/CD pipelines
- Shared infrastructure
- Production environments

The repository introduces backend configuration and the concepts required to understand remote Terraform state.

---

## 🔄 Terraform Lifecycle

Terraform lifecycle settings allow resource behavior to be customized.

Examples include:

```hcl
lifecycle {
  create_before_destroy = true
}
```

Other lifecycle concepts covered include:

- `prevent_destroy`
- `ignore_changes`
- Replacement behavior
- Resource recreation

These features become especially useful when managing real infrastructure where uncontrolled replacement can have significant consequences.

---

## ☁️ Azure Infrastructure

The hands-on portion of this repository uses **Microsoft Azure** to demonstrate Terraform concepts against real cloud infrastructure.

The exercises and final project work with Azure resources such as:

- Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Network Interfaces
- Linux Virtual Machines
- PostgreSQL Flexible Server
- Private DNS

The Azure resources are used primarily as a practical environment for learning Terraform concepts.

---

# 🚀 Final Project

The repository concludes with a complete Terraform project that combines the concepts covered throughout the learning path.

The final project demonstrates a small **three-tier Azure architecture**:

```text
                    Azure
                      │
                Resource Group
                      │
                  Virtual Network
                      │
          ┌───────────┼───────────┐
          │           │           │
      Frontend     Backend     Database
       Subnet       Subnet       Subnet
          │           │           │
        VM           VM      PostgreSQL
                                  │
                              Private DNS
```

The final project demonstrates:

- Terraform root modules
- Reusable child modules
- Azure networking
- Network Security Groups
- Linux virtual machines
- PostgreSQL Flexible Server
- Private networking
- PostgreSQL subnet delegation
- Private DNS
- Variables
- Locals
- Expressions
- Module dependencies
- Outputs
- Terraform state
- Validation and verification

The complete final project documentation is available here:

[`10-final-project/README.md`](10-final-project/README.md)

---

## 🧪 Validation and Testing

Terraform configurations should not only be deployed; they should also be validated and verified.

The final project uses:

```bash
terraform validate
terraform plan
terraform apply
terraform output
terraform state list
```

The final configuration was successfully deployed and verified.

The final Terraform plan returned:

```text
No changes. Your infrastructure matches the configuration.
```

The final project manages **19 Azure resources** through Terraform state.

---

## 🎯 Learning Objectives

By completing this repository, you should understand:

- What Infrastructure as Code is
- How Terraform works
- How Terraform interacts with cloud providers
- How providers and resources are defined
- How variables and outputs work
- How Terraform evaluates expressions
- How dependencies are created
- How Terraform builds and uses its dependency graph
- How Terraform state works
- Why state management matters
- How modules create reusable infrastructure
- How lifecycle rules affect resource management
- How to validate Terraform configurations
- How to inspect and troubleshoot Terraform state
- How to structure a small Terraform project
- How individual modules can be composed into a larger infrastructure deployment

The objective is not simply to know Terraform commands, but to understand the **Terraform workflow and the reasoning behind Terraform configuration design**.

---

## 🛠️ Prerequisites

To work through the Azure-based exercises, you should have:

- An Azure subscription
- Azure CLI
- Terraform
- An authenticated Azure CLI session
- Basic understanding of Azure resources
- Basic command-line knowledge
- Git

Verify the installations with:

```bash
terraform version
az version
git --version
```

Authenticate with Azure:

```bash
az login
```

---

## 📖 Recommended Learning Approach

Work through the repository sequentially rather than jumping directly to the final project.

For each section:

1. Read the Terraform concept.
2. Inspect the configuration.
3. Understand the resource relationships.
4. Run `terraform init`.
5. Run `terraform validate`.
6. Run `terraform plan`.
7. Review the planned changes.
8. Apply the configuration where appropriate.
9. Inspect the resulting state.
10. Experiment with the configuration.
11. Observe how Terraform responds to changes.

The goal is to understand **why Terraform behaves the way it does**, not just what command to run next.

---

## 🧹 Cleanup

Cloud resources created during the exercises can incur costs.

When a lab is no longer required, destroy the resources:

```bash
terraform destroy
```

Always review the destruction plan before confirming.

The final project is intended as a learning environment rather than a production deployment.

---

## 📌 Important Notes

- Do not commit secrets or credentials to the repository.
- Use `.gitignore` to exclude Terraform-generated files that should not be committed.
- Review `terraform plan` before applying infrastructure changes.
- Treat Terraform state as sensitive when it contains infrastructure details or secrets.
- Use remote state and state locking when working collaboratively.
- Use modules when infrastructure components need to be reused or logically separated.
- Always verify the actual infrastructure after making significant Terraform changes.

---

## 📈 What Comes Next

After completing Terraform Fundamentals, the next step is to apply these concepts to more realistic infrastructure and automation scenarios.

Potential next areas include:

- Terraform with CI/CD
- Terraform remote state
- Azure Storage backend
- Terraform environments
- Infrastructure testing
- Terraform security scanning
- Terraform and GitHub Actions
- Infrastructure deployment workflows
- Azure Landing Zones
- Enterprise Terraform architecture

---

## 👤 About This Repository

This repository is part of a hands-on learning journey focused on **Terraform, Microsoft Azure, Infrastructure as Code, DevOps, and cloud automation**.

The emphasis is on understanding the underlying concepts and applying them through progressively more realistic infrastructure examples.

---

## 📚 References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Language Documentation](https://developer.hashicorp.com/terraform/language)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Microsoft Azure Documentation](https://learn.microsoft.com/azure/)

---

## ✅ Repository Status

**Terraform Fundamentals — Complete**

The repository covers the core Terraform concepts through hands-on exercises and concludes with a modular Azure infrastructure project demonstrating how the individual Terraform concepts come together in a practical Infrastructure as Code workflow.