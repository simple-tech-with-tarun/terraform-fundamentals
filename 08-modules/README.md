# Terraform Modules

This lab explores Terraform modules and how they are used to organize, reuse, compose, version, and dynamically instantiate Terraform configurations.

The lab progresses from basic local modules through module inputs, outputs, composition, external Git sources, module version constraints, and finally a practical multi-module configuration.

---

## Lab Structure

```text
08-modules/
├── README.md
├── 01-module-basics/
├── 02-input-variables/
├── 03-outputs/
├── 04-module-composition/
├── 05-module-source/
├── 06-module-versions/
└── 07-final-exercise/
```

---

# 1. Module Basics

Directory:

```text
01-module-basics/
```

This section introduces the basic structure and purpose of a Terraform module.

The module consists of a child module containing Terraform configuration and a root module that calls it.

Basic structure:

```text
root module
    │
    └── module block
            │
            ▼
       child module
            │
            ▼
        resources
```

Example:

```hcl
module "file" {
  source = "./modules/file"

  m_filename = var.environment_file
}
```

The child module receives the input through its variable:

```hcl
variable "m_filename" {
  type = string
}
```

and uses it in a resource:

```hcl
resource "local_file" "example" {
  filename = var.m_filename
}
```

## Module State Addresses

Resources created by modules are represented in Terraform state using module-qualified addresses:

```text
module.file.local_file.example
```

When multiple instances are created using `for_each`, the key becomes part of the address:

```text
module.file["dev"].local_file.example
module.file["prod"].local_file.example
```

A module is therefore a configuration boundary, while its resources still belong to the overall Terraform state.

---

# 2. Module Input Variables

Directory:

```text
02-input-variables/
```

This section explores how values flow from the root module into child modules.

The basic flow is:

```text
root variable
      ↓
module argument
      ↓
child variable
      ↓
resource argument
```

Example:

```hcl
module "file" {
  source = "./modules/file"

  m_filename = var.environment_file
}
```

Child module:

```hcl
variable "m_filename" {
  type = string
}
```

Resource:

```hcl
resource "local_file" "example" {
  filename = var.m_filename
}
```

The lab covered:

- root variable defaults
- CLI variable values
- `.tfvars`
- variable precedence
- primitive type conversion
- lists
- maps
- objects
- sets
- nested collections
- object validation
- optional object attributes
- `nullable`
- child-module variables
- module `for_each`
- nested `map(object(...))`
- `flatten()`
- `for` expressions
- module outputs and private child locals

## Important Concept

A child module's variables are not automatically populated from the root module's variables.

The root must explicitly pass values:

```hcl
module "example" {
  source = "./modules/example"

  m_environment = var.environment
}
```

Child module configuration is therefore controlled through its module interface.

---

# 3. Module Outputs

Directory:

```text
03-outputs/
```

This section demonstrates how information flows out of child modules.

The basic flow is:

```text
child resource
      ↓
child output
      ↓
root module
      ↓
root output / expression
```

Child module:

```hcl
output "filename" {
  value = local_file.example.filename
}
```

Root module:

```hcl
output "environment_file" {
  value = module.example.filename
}
```

## Multiple Module Instances

When a module uses `for_each`:

```hcl
module "environment" {
  source   = "./modules/environment"
  for_each = var.environments
}
```

the module becomes a collection of instances.

An individual output can be accessed with its key:

```hcl
module.environment["dev"].filename
```

A `for` expression can aggregate the outputs:

```hcl
{
  for name, environment in module.environment :
  name => environment.filename
}
```

This produces a map of module outputs.

## Important Concept

Child module locals and internal implementation details are private.

The root module accesses child-module information through declared outputs:

```text
child local/resource
        ↓
child output
        ↓
module.<name>.<output>
```

---

# 4. Module Composition

Directory:

```text
04-module-composition/
```

This section demonstrates modules consuming outputs from other modules.

Example:

```text
source module
      │
      │ filename output
      ▼
consumer module
      │
      │ filename output
      ▼
final module
```

Root configuration:

```hcl
module "source" {
  source = "./modules/source"
}

module "consumer" {
  source = "./modules/consumer"

  m_source_filename = module.source.filename
}
```

The reference:

```hcl
module.source.filename
```

creates an implicit dependency.

Terraform understands that the consumer module requires the source module's output.

## Module `for_each` Composition

The lab also demonstrated matching `for_each` keys across modules:

```hcl
module "source" {
  source   = "./modules/source"
  for_each = var.environments

  m_environment = each.key
}

module "consumer" {
  source   = "./modules/consumer"
  for_each = var.environments

  m_environment     = each.key
  m_source_filename = module.source[each.key].filename
}
```

This creates independent relationships:

```text
source["dev"]  → consumer["dev"]

source["prod"] → consumer["prod"]
```

The key establishes the pairing between the module instances.

---

# 5. Module Source

Directory:

```text
05-module-source/
```

This section explores different ways Terraform can obtain modules.

## Local Module

```hcl
module "file_generator" {
  source = "./modules/file_generator"
}
```

Terraform loads the module from a directory within the current configuration.

---

## Git Repository

Terraform can load a module directly from a Git repository:

```hcl
module "GitHub_module" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git"
}
```

Terraform downloads the repository into its module cache.

---

## Git Subdirectory

A specific directory inside the repository can be selected:

```hcl
module "GitHub_secondary_module" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git//modules/secondary"
}
```

The important distinction is:

```text
repository
    ↓
source URL
    ↓
directory
    ↓
all .tf files in that directory
```

Terraform does not select an individual `.tf` file as a module source.

---

## Git `ref`

A Git source can be pinned to a branch, tag, or commit:

```hcl
module "GitHub_module" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git?ref=v1.0.0"
}
```

A specific commit can also be selected:

```hcl
module "GitHub_module_commit" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git?ref=48a0d48cd7a7d5c2bbddaab8c8457e2cd51c00ca"
}
```

This demonstrates the difference between:

```text
source
  → where the module comes from

ref
  → which Git revision is used
```

---

# 6. Module Versions

Directory:

```text
06-module-versions/
```

This section demonstrates Terraform Registry module version constraints.

The lab used the Azure Verified Module:

```text
Azure/avm-res-resources-resourcegroup/azurerm
```

Example:

```hcl
module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.4.0"

  name     = "terraform-module-version-lab-rg"
  location = "Central India"
}
```

## Exact Version

```hcl
version = "0.4.0"
```

Selects exactly version `0.4.0`.

## Compatible Minor Versions

```hcl
version = "~> 0.4"
```

Allows compatible releases within the `0.4` series.

## Version Range

```hcl
version = ">= 0.4, < 1.0"
```

Allows versions matching the specified range.

Terraform selects the newest available version satisfying the constraint when dependency selection is evaluated.

## Downgrading Through a Constraint

For example:

```hcl
version = "< 0.4"
```

caused Terraform to select an older compatible release.

Running:

```bash
terraform init -upgrade
```

re-evaluates dependency selections against the configured constraints.

It does **not** override the version constraint.

## Module Version vs Provider Version

These are separate concepts.

```text
Module version
    ↓
controls which module release is used

Provider version
    ↓
controls which provider release is used
```

The `.terraform.lock.hcl` file records provider selections and checksums; module version selection is controlled through the module configuration and Terraform's module dependency information.

---

# 7. Final Exercise

Directory:

```text
07-final-exercise/
```

The final exercise combines the major concepts from the modules lab.

Structure:

```text
07-final-exercise/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── environment/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── summary/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Input Structure

The root module accepts a map of objects:

```hcl
variable "environments" {
  type = map(object({
    region  = string
    enabled = bool
  }))
}
```

Example:

```hcl
environments = {
  dev = {
    region  = "Central India"
    enabled = true
  }

  test = {
    region  = "Central India"
    enabled = true
  }

  prod = {
    region  = "East US"
    enabled = false
  }

  stage = {
    region  = "Central India"
    enabled = true
  }
}
```

---

## Filtering with a Local

The root module creates a filtered collection:

```hcl
locals {
  enabled_environments = {
    for name, config in var.environments :
    name => config
    if config.enabled
  }
}
```

This produces only the enabled environments.

For example:

```text
Input:

dev    → enabled
test   → enabled
prod   → disabled
stage  → enabled

                ↓

enabled_environments:

dev
test
stage
```

---

## Environment Module

The environment module receives:

```hcl
m_environment_name
m_region
```

and creates a file:

```text
dev-environment.txt
test-environment.txt
stage-environment.txt
```

The module exposes the filename:

```hcl
output "filename" {
  value = local_file.environment.filename
}
```

---

## Module `for_each`

The root creates environment module instances using:

```hcl
module "environment" {
  source   = "./modules/environment"
  for_each = local.enabled_environments

  m_environment_name = each.key
  m_region           = each.value.region
}
```

Each key becomes a module instance:

```text
module.environment["dev"]
module.environment["test"]
module.environment["stage"]
```

---

## Summary Module

The summary module receives both:

```hcl
m_environment_name
m_environment_file
```

The environment filename comes directly from the environment module:

```hcl
m_environment_file = module.environment[each.key].filename
```

The summary module therefore depends on the corresponding environment module instance.

The relationship is:

```text
environment["dev"]
        │
        │ filename
        ▼
summary["dev"]

environment["test"]
        │
        │ filename
        ▼
summary["test"]

environment["stage"]
        │
        │ filename
        ▼
summary["stage"]
```

No explicit `depends_on` is required because the module output reference creates the dependency.

---

## Summary Outputs

The summary module exposes its generated filename:

```hcl
output "filename" {
  value = local_file.summary.filename
}
```

The root then aggregates the outputs:

```hcl
output "summary_files" {
  value = {
    for name, summary in module.summary :
    name => summary.filename
  }
}
```

Example:

```text
summary_files = {
  dev   = "dev-summary.txt"
  stage = "stage-summary.txt"
  test  = "test-summary.txt"
}
```

---

# `for_each` Identity Demonstration

The final exercise also demonstrates what happens when an environment changes from enabled to disabled.

If:

```hcl
prod = {
  region  = "East US"
  enabled = true
}
```

becomes:

```hcl
prod = {
  region  = "East US"
  enabled = false
}
```

then:

```text
module.environment["prod"]
```

is removed from the filtered collection.

Terraform therefore destroys that module instance.

The corresponding:

```text
module.summary["prod"]
```

is also removed.

If another environment becomes enabled at the same time, Terraform creates a new module instance for that key.

For example:

```text
Before:

dev
test
prod

After:

dev
test
stage
```

Terraform performs:

```text
prod   → destroy
stage  → create
dev    → unchanged
test   → unchanged
```

This demonstrates that `for_each` uses meaningful collection keys as instance identity.

```text
"prod" ≠ "stage"
```

Terraform does not treat one as a replacement of the other.

---

# Module Dependency Flow

The final exercise demonstrates the complete dependency chain:

```text
                    variables
                        │
                        ▼
                map(object(...))
                        │
                        ▼
                      locals
                        │
                        │ filtering
                        ▼
              enabled_environments
                        │
                        ▼
                 module.environment
                        │
                        │ output
                        ▼
                  filename
                        │
                        ▼
                  module.summary
                        │
                        │ output
                        ▼
                 summary_files
```

This is the central pattern demonstrated by the modules lab.

---

# Key Terraform Module Concepts

## Module

A reusable Terraform configuration boundary.

```hcl
module "example" {
  source = "./modules/example"
}
```

## Module Input

Values passed from the caller into the module:

```hcl
module "example" {
  source = "./modules/example"

  m_environment = var.environment
}
```

## Module Output

Values exposed by the child module:

```hcl
output "filename" {
  value = local_file.example.filename
}
```

Consumed by:

```hcl
module.example.filename
```

## Module `for_each`

Creates multiple module instances:

```hcl
module "environment" {
  source   = "./modules/environment"
  for_each = var.environments
}
```

Instances are addressed using their keys:

```text
module.environment["dev"]
module.environment["prod"]
```

## Module Composition

One module can consume another module's output:

```hcl
m_source_filename = module.source.filename
```

This creates an implicit dependency.

## Module Source

Defines where Terraform obtains the module:

```text
local directory
Git repository
Git subdirectory
Terraform Registry
```

## Module Version

For Registry modules, controls which published module release satisfies the configured constraint:

```hcl
version = "0.4.0"
```

---

# Terraform Commands Used

```bash
terraform init
terraform init -upgrade
terraform validate
terraform plan
terraform apply
terraform apply --auto-approve
terraform output
terraform state list
terraform destroy
```

---

# Important Mental Models

### Module Inputs

```text
root
  ↓
module argument
  ↓
child variable
  ↓
resource
```

### Module Outputs

```text
resource
  ↓
child output
  ↓
root
```

### Module Composition

```text
module A
   ↓
output
   ↓
module B
```

### Module `for_each`

```text
collection
    ↓
for_each
    ↓
module["key"]
    ↓
resources
```

### Filtered Module Creation

```text
input collection
       ↓
for expression
       ↓
filtered collection
       ↓
module for_each
       ↓
only desired module instances
```

---

# Final Takeaways

The most important lesson from this lab is that Terraform modules are not simply a way to reduce duplicated code.

They provide:

- reusable configuration
- clear interfaces through variables and outputs
- composition between infrastructure components
- independent module instances through `for_each` and `count`
- abstraction of implementation details
- controlled external module sources
- versioned module dependencies
- reusable patterns suitable for larger infrastructure configurations

The most important pattern is:

```text
Input
  ↓
Transform
  ↓
Module
  ↓
Output
  ↓
Another Module
  ↓
Final Output
```

When combined with Terraform expressions and `for_each`, modules can represent complex infrastructure relationships while keeping the root configuration understandable.

---

# Branch Progress

`08-modules` is part of the Terraform Fundamentals learning series:

```text
01-basics
02-variables
03-outputs
04-data-sources
05-expressions
06-meta-arguments
07-state
08-modules          ← current
09-azure
10-final-project
```