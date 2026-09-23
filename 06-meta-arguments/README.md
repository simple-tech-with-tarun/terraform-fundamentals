# Terraform Meta-Arguments

This lab explores Terraform **meta-arguments** and how they control resource creation, resource identity, dependency ordering, lifecycle behavior, and resource replacement.

Meta-arguments are special Terraform arguments that affect **how Terraform manages resources**, rather than describing the infrastructure itself.

---

## Topics Covered

- `count`
- `for_each`
- Resource instance identity
- `depends_on`
- Implicit dependencies
- Explicit dependencies
- Terraform dependency graph
- `lifecycle`
- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- `replace_triggered_by`
- Resource addressing
- Combining meta-arguments in practical configurations

---

# 1. What Are Meta-Arguments?

Meta-arguments are Terraform arguments that control how resources are managed.

Common examples include:

```hcl
count
for_each
depends_on
lifecycle
```

They are different from normal resource arguments.

For example:

```hcl
resource "local_file" "example" {
  filename = "example.txt"
  content  = "Hello"
}
```

`filename` and `content` describe the resource.

A meta-argument such as:

```hcl
for_each = var.environments
```

controls **how many resource instances Terraform creates and how those instances are identified**.

---

# 2. `count`

`count` creates multiple instances of the same resource using numeric indexes.

Example:

```hcl
resource "local_file" "environment" {
  count = 3

  filename = "environment-${count.index}.txt"
  content  = "Environment ${count.index}"
}
```

Terraform creates:

```text
local_file.environment[0]
local_file.environment[1]
local_file.environment[2]
```

Each instance is identified by its numeric index.

The index is available through:

```hcl
count.index
```

### Mental model

```text
count
  ↓
multiple instances
  ↓
numeric identity
```

---

# 3. `for_each`

`for_each` creates multiple resource instances from a map or set.

Example:

```hcl
variable "environments" {
  type = map(string)

  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}

resource "local_file" "environment" {
  for_each = var.environments

  filename = "${each.key}.txt"
  content  = "Environment: ${each.value}"
}
```

Terraform creates:

```text
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

The collection element becomes part of the resource instance identity.

The available values are:

```hcl
each.key
each.value
```

### Mental model

```text
for_each
  ↓
multiple instances
  ↓
key-based identity
```

---

# 4. Resource Identity

One of the most important concepts demonstrated in this lab is that `count` and `for_each` create different resource identities.

With `count`:

```text
local_file.environment[0]
local_file.environment[1]
local_file.environment[2]
```

With `for_each`:

```text
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

Terraform uses these addresses to track individual instances in state.

This becomes important when the collection changes.

For example, with `for_each`, the key identifies the instance:

```text
environment["dev"]
environment["test"]
environment["prod"]
```

If `test` is removed from the collection, Terraform can identify the specific instance associated with the `test` key.

With `count`, instances are identified by position:

```text
environment[0]
environment[1]
environment[2]
```

Changing the ordering of a positional collection can therefore change which value corresponds to an index.

### Mental model

```text
count
    → positional identity

for_each
    → key-based identity
```

Use `count` when instances are primarily positional or interchangeable.

Use `for_each` when instances have meaningful identities.

---

# 5. `depends_on`

`depends_on` creates an explicit dependency between resources.

Example:

```hcl
resource "local_file" "resource_group" {
  filename = "resource-group.txt"
  content  = "Resource Group: terraform-meta-arguments"
}

resource "local_file" "environment" {
  for_each = var.environments

  depends_on = [local_file.resource_group]

  filename = "${each.key}.txt"
  content  = "Environment: ${each.value}"
}
```

The important relationship is:

```text
local_file.environment
        │
        │ depends on
        ▼
local_file.resource_group
```

Therefore, the execution order must be:

```text
local_file.resource_group
        ↓
local_file.environment
```

The resource group must be created before the environment resources.

### Important distinction

The **dependency relationship** points from the dependent resource toward what it depends on:

```text
environment
    ↓
depends on
    ↓
resource_group
```

The **execution order** is the opposite:

```text
resource_group
    ↓
created first
    ↓
environment
```

This distinction is important when reading Terraform's dependency graph.

---

# 6. Implicit Dependencies

Terraform can usually determine dependencies automatically when one resource references another.

Example:

```hcl
resource "local_file" "source" {
  filename = "source.txt"
  content  = "Source"
}

resource "local_file" "copy" {
  filename = "copy.txt"
  content  = local_file.source.content
}
```

The reference:

```hcl
local_file.source.content
```

creates an implicit dependency.

Terraform understands:

```text
local_file.copy
      │
      │ depends on
      ▼
local_file.source
```

Therefore, `source` must be available before `copy` can use its value.

No explicit `depends_on` is required.

### Implicit vs explicit dependency

```text
Implicit dependency
    → Terraform discovers it from a resource reference

Explicit dependency
    → depends_on tells Terraform about the dependency
```

Use implicit dependencies whenever the relationship can naturally be expressed through a reference.

Use `depends_on` when there is a dependency that Terraform cannot determine from the configuration itself.

---

# 7. Terraform Dependency Graph

Terraform builds a dependency graph to determine relationships between resources and the order in which operations can be performed.

The graph can be inspected using:

```bash
terraform graph
```

For the final exercise, the relationship was:

```text
local_file.environment
        │
        │ depends on
        ▼
local_file.resource_group
```

This means Terraform must execute the resources in this order:

```text
local_file.resource_group
        ↓
local_file.environment
```

The important distinction is:

```text
Dependency relationship:

environment
    ↓
depends on
    ↓
resource_group


Execution order:

resource_group
    ↓
environment
```

The graph represents the dependency relationship. Terraform uses that relationship to determine a valid execution order.

The dependency graph is about **relationships and ordering**, not about the physical hierarchy of resources.

---

# 8. `lifecycle`

The `lifecycle` meta-argument changes how Terraform handles resource changes.

Example:

```hcl
resource "local_file" "example" {
  filename = "example.txt"
  content  = "Hello"

  lifecycle {
    create_before_destroy = true
  }
}
```

Common lifecycle settings include:

```hcl
create_before_destroy
prevent_destroy
ignore_changes
replace_triggered_by
```

Lifecycle rules affect Terraform's behavior when resources are created, updated, replaced, or destroyed.

---

# 9. `create_before_destroy`

Normally, when a resource must be replaced, Terraform may destroy the existing resource before creating its replacement.

With:

```hcl
lifecycle {
  create_before_destroy = true
}
```

Terraform attempts to create the replacement before destroying the old instance.

Conceptually:

```text
Default:

destroy old
    ↓
create new
```

With `create_before_destroy`:

```text
create new
    ↓
destroy old
```

This can reduce downtime when the underlying platform allows the old and new resources to coexist temporarily.

However, the behavior is dependent on the resource and provider. Some resources cannot have two instances with the same identifying properties at the same time.

---

# 10. `prevent_destroy`

`prevent_destroy` prevents Terraform from destroying a resource through Terraform.

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

If Terraform determines that the resource must be destroyed, Terraform returns an error instead of performing the destruction.

This can be useful for protecting important resources.

It is important to understand that this is a **Terraform configuration safeguard**, not an Azure or cloud-provider security control.

It does not prevent someone from deleting the resource directly through Azure, the Azure CLI, or another management system.

---

# 11. `ignore_changes`

`ignore_changes` tells Terraform to ignore changes to specified resource attributes when calculating changes.

Example:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Suppose an external system modifies the tags on a resource.

Without `ignore_changes`, Terraform may attempt to restore the configured value.

With:

```hcl
ignore_changes = [
  tags
]
```

Terraform ignores changes to that attribute when determining whether an update is required.

This can be useful when an external system is intentionally responsible for managing part of a resource.

It should be used carefully because Terraform is intentionally no longer enforcing the configured value for the ignored attribute.

---

# 12. `replace_triggered_by`

`replace_triggered_by` allows a resource to be replaced when another resource or value changes.

Conceptually:

```hcl
lifecycle {
  replace_triggered_by = [
    some_resource.example
  ]
}
```

A relevant change to the referenced object causes Terraform to replace the resource containing the lifecycle rule.

This is useful when two resources have a relationship where a normal attribute reference does not adequately express the desired replacement behavior.

---

# 13. Meta-Arguments and State

Meta-arguments can affect how Terraform represents resources in state.

For example:

```hcl
for_each = var.environments
```

produces resource addresses such as:

```text
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

These addresses are part of Terraform's resource identity.

This is why changing from `count` to `for_each`, or changing keys in a `for_each` collection, can have significant consequences for the state.

Meta-arguments therefore affect more than just how many resources Terraform creates.

They influence **how Terraform identifies and manages those resources over time**.

---

# 14. Final Practical Exercise

The final exercise combined:

- `for_each`
- `depends_on`
- variables
- resource instance identity
- dependency graph

The configuration used:

```hcl
variable "environments" {
  type = map(string)

  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}
```

A resource representing the resource group was created first:

```hcl
resource "local_file" "resource_group" {
  filename = "resource-group.txt"
  content  = "Resource Group: terraform-meta-arguments"
}
```

Environment resources were created using `for_each`:

```hcl
resource "local_file" "environment" {
  for_each = var.environments

  depends_on = [local_file.resource_group]

  filename = "${each.key}.txt"
  content  = "Environment: ${each.value}"
}
```

Terraform created:

```text
local_file.resource_group

local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

The dependency relationship was:

```text
local_file.environment
        │
        │ depends on
        ▼
local_file.resource_group
```

Therefore, Terraform's execution order was:

```text
local_file.resource_group
        ↓
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

The dependency graph was inspected using:

```bash
terraform graph
```

This demonstrated how `for_each` and `depends_on` can be combined in a practical Terraform configuration.

---

# 15. Key Mental Models

The most important concepts from this lab are:

```text
count
    → creates multiple resource instances using numeric indexes

for_each
    → creates multiple resource instances using meaningful keys

depends_on
    → explicitly declares a dependency

implicit dependency
    → Terraform discovers a dependency from references

terraform graph
    → shows Terraform's dependency relationships

lifecycle
    → controls how Terraform handles resource changes
```

A particularly important distinction is:

```text
for_each
    → creates resource instances

dynamic
    → generates nested blocks
```

For example:

```text
for_each
    └── creates:
        resource["dev"]
        resource["test"]
        resource["prod"]

dynamic
    └── generates:
        nested_block
        nested_block
        nested_block
```

---

# Terraform Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform apply --auto-approve
terraform state list
terraform state show
terraform graph
terraform destroy
```

---

# Final Takeaway

Meta-arguments allow Terraform to control **how infrastructure is managed**, not just what infrastructure should exist.

The key mental model is:

```text
                 Terraform Configuration
                         │
                         ▼
                  Meta-Arguments
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
     Identity        Dependency        Lifecycle
        │                │                │
   count/for_each     depends_on       lifecycle
        │                │                │
        └────────────────┼────────────────┘
                         ▼
                 Terraform Dependency
                      Graph
                         │
                         ▼
                    Resource State
                         │
                         ▼
                  Infrastructure
```

The most important lesson is that Terraform continuously manages relationships between:

```text
Configuration
     ↓
Resource Identity
     ↓
Dependencies
     ↓
State
     ↓
Infrastructure
```

Understanding these relationships makes it easier to predict what Terraform will do before running `terraform apply`.