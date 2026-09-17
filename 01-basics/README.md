# 01 - Terraform Basics

This section covers the fundamental Terraform workflow using the `local` provider.

## Concepts Covered

- Terraform configuration
- Providers
- Resources
- Terraform initialization
- Configuration validation
- Execution plans
- Applying configuration
- Terraform state
- Resource addresses
- Resource replacement
- Destroying resources

## Terraform Workflow

```text
terraform init
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
terraform state
      ↓
terraform destroy
```

## Resource

This exercise uses the `local_file` resource:

```hcl
resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Hello from Terraform Fundamentals!"
}
```

Terraform creates `hello.txt` based on the desired configuration.

## State

Terraform maintains the current known state of managed resources in `terraform.tfstate`.

The state file is intentionally excluded from version control for this local exercise.

## Key Learning

Terraform compares the desired configuration with the current state and determines what actions are required to reconcile them.

A configuration change can result in:

- Create
- Update
- Replacement
- Destroy
