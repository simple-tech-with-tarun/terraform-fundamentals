# Terraform Fundamentals

A practical reference for learning Terraform and Infrastructure as Code through concepts, examples, and hands-on exercises.

This repository focuses on the fundamentals of Terraform, including configuration, providers, resources, variables, state management, modules, dependencies, and common Infrastructure as Code practices.

The goal is to understand how Terraform works and why its different components are used, rather than simply memorizing Terraform commands.

## 📚 What You'll Find Here

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
- Best practices
- Troubleshooting

## 🏗️ Infrastructure as Code

Infrastructure as Code allows infrastructure to be defined and managed using declarative configuration.

A typical Terraform workflow:

```text
Terraform Configuration
        │
        ▼
terraform init
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