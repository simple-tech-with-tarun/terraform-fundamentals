# Terraform Expressions

This lab explores Terraform expressions and how they are used to transform data, make decisions, iterate over collections, and dynamically configure resources.

The goal is to understand how Terraform evaluates expressions and how different expression types work together in practical configurations.

---

## Repository Layout

```text
05-expressions/
│
├── dynamic-block/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── .terraform.lock.hcl
│   └── README.md
│
└── final-expressions/
    ├── main.tf
    ├── terraform.tfvars
    └── .terraform.lock.hcl
```

### `dynamic-block/`

A focused AzureRM lab demonstrating:

- `for_each` for multiple resource instances
- Dynamic nested blocks
- Custom dynamic-block iterators
- Multiple NSGs with different security-rule collections
- Nested iteration

The lab creates Azure Resource Groups and Network Security Groups with dynamically generated `security_rule` blocks.

### `final-expressions/`

A clean practical exercise combining multiple Terraform expression concepts:

- Typed variables
- Map/object structures
- `for` expressions
- Filtering
- `locals`
- `for_each`
- Conditional configuration
- Heredoc / multiline strings
- String functions

The exercise uses the `local` provider so the focus remains on Terraform expressions rather than Azure infrastructure.

---

## Topics Covered

- Comparison operators
- Logical operators
- Conditional expressions
- `for` expressions
- Filtering collections
- Map/object transformations
- `flatten()`
- `toset()`
- `for_each`
- `count`
- `locals`
- `file()`
- `try()`
- `can()`
- Heredoc / multiline strings
- Dynamic blocks
- Nested iteration
- Combining expressions in practical configurations

---

## 1. Comparison Operators

Terraform supports comparison operators such as:

```hcl
==
!=
>
<
>=
<=
```

Example:

```hcl
var.environment == "prod"
```

This evaluates to a boolean value.

`=` is used for assignment, while `==` is used for comparison.

---

## 2. Logical Operators

Multiple conditions can be combined using:

```hcl
&&
||
!
```

Examples:

```hcl
var.environment == "prod" && var.region == "Central India"
```

```hcl
var.environment == "dev" || var.environment == "test"
```

```hcl
!(var.environment == "dev")
```

---

## 3. Conditional Expressions

Terraform supports the conditional expression:

```hcl
condition ? true_value : false_value
```

Example:

```hcl
var.environment == "prod" ? "Production" : "Non-Production"
```

This allows resource configuration and values to change based on conditions.

---

## 4. `for` Expressions

A `for` expression transforms or filters collections.

### List transformation

```hcl
[for env in ["dev", "test", "prod"] : upper(env)]
```

Result:

```text
[
  "DEV",
  "TEST",
  "PROD",
]
```

### Filtering

```hcl
[for env in ["dev", "test", "prod"] : upper(env) if env != "prod"]
```

Result:

```text
[
  "DEV",
  "TEST",
]
```

### Map transformation

```hcl
{
  for env in ["dev", "test", "prod"] :
  env => upper(env)
}
```

Result:

```text
{
  dev  = "DEV"
  prod = "PROD"
  test = "TEST"
}
```

---

## 5. `flatten()`

`flatten()` removes one level of nested lists.

Example:

```hcl
flatten([
  ["dev", "test"],
  ["prod"]
])
```

Result:

```text
[
  "dev",
  "test",
  "prod",
]
```

---

## 6. `toset()`

`toset()` converts a collection into a set.

Example:

```hcl
toset(["dev", "test", "dev", "prod"])
```

The duplicate `dev` is removed.

Sets do not provide meaningful ordering and cannot be accessed by numeric index like lists.

---

## 7. `for_each`

`for_each` creates multiple resource instances from a collection.

Example:

```hcl
resource "local_file" "environment" {
  for_each = toset(["dev", "test", "prod"])

  filename = "${each.key}.txt"
  content  = "This is the ${each.key} environment."
}
```

Terraform creates separate resource instances:

```text
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

The collection element becomes part of the resource instance identity.

---

## 8. `count`

`count` also creates multiple resource instances, but instances are identified by numeric indexes.

Example:

```hcl
resource "local_file" "environment" {
  count = 3

  filename = "environment-${count.index}.txt"
}
```

Instances are addressed as:

```text
local_file.environment[0]
local_file.environment[1]
local_file.environment[2]
```

### `count` vs `for_each`

Use `count` when instances are primarily positional or interchangeable.

Use `for_each` when instances have meaningful identities or keys.

---

## 9. Locals

`locals` provide named intermediate values.

Example:

```hcl
locals {
  environment_name = upper(var.environment)

  environment_type = var.environment == "prod" ? "Production" : "Non-Production"

  environment_label = "${local.environment_name} - ${local.environment_type}"
}
```

Locals are useful for avoiding repeated expressions and creating readable configuration.

They do not create infrastructure.

---

## 10. Reading Files with `file()`

Terraform's `file()` function reads the contents of a file.

Example:

```hcl
locals {
  config_content = file("${path.module}/config/config.txt")
}
```

`path.module` refers to the directory of the current Terraform module.

The resulting value can then be transformed using other expressions and functions.

For example:

```hcl
locals {
  config_lines = split("\n", local.config_content)
}
```

The lab also demonstrated parsing simple `key=value` configuration files using `split()`, `trimspace()`, and `for` expressions.

---

## 11. `try()` and `can()`

### `try()`

`try()` returns the first expression that can be successfully evaluated.

Example:

```hcl
try(
  var.application.settings.timeout,
  "not-configured"
)
```

If the value exists, it is returned. Otherwise, the fallback is returned.

### `can()`

`can()` checks whether an expression can be evaluated.

Example:

```hcl
can(var.application.settings.timeout)
```

Result:

```text
true
```

or:

```text
false
```

A useful distinction:

```text
try() → give me a usable value, otherwise use a fallback

can() → tell me whether this expression can be evaluated
```

---

# Dynamic Blocks

Dynamic blocks generate repeated nested blocks inside a resource.

They are different from `for_each`.

```text
for_each → creates resource instances

dynamic  → generates nested blocks inside a resource
```

The lab used Azure Network Security Groups to generate multiple `security_rule` blocks.

Example:

```hcl
dynamic "security_rule" {
  for_each = each.value.rule
  iterator = rule

  content {
    name                       = rule.value.name
    priority                   = rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = rule.value.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

## Default vs Custom Iterator

Without an explicit iterator:

```hcl
dynamic "security_rule" {
  for_each = each.value.rule

  content {
    name = security_rule.value.name
  }
}
```

Terraform uses the dynamic block label as the iterator name.

With an explicit iterator:

```hcl
dynamic "security_rule" {
  for_each = each.value.rule
  iterator = rule

  content {
    name = rule.value.name
  }
}
```

The block label remains `security_rule`, while the iterator is named `rule`.

This becomes especially useful when dynamic blocks are nested or when multiple levels of iteration are involved.

---

# Nested Dynamic Configuration

The dynamic-block lab used a structure where each NSG had its own collection of rules:

```text
var.nsg
│
├── nsg1
│   └── rule
│       ├── http
│       ├── https
│       └── ssh
│
└── nsg2
    └── rule
        ├── http
        └── ssh
```

The outer `for_each` created the NSGs:

```hcl
for_each = var.nsg
```

The inner dynamic block generated the appropriate security rules:

```hcl
for_each = each.value.rule
```

This demonstrated how expressions can be composed across multiple levels.

---

# Final Practical Exercise

The `final-expressions` directory combines several concepts into a small practical configuration.

Input:

```hcl
environments = {
  dev = {
    enabled = true
    region  = "Central India"
  }

  test = {
    enabled = true
    region  = "Central India"
  }

  prod = {
    enabled = true
    region  = "East US"
  }

  stage = {
    enabled = false
    region  = "Central India"
  }
}
```

The configuration filters enabled environments:

```hcl
locals {
  enabled_environments = {
    for name, config in var.environments :
    name => config
    if config.enabled
  }
}
```

The filtered collection is then used by `for_each`:

```hcl
resource "local_file" "environment" {
  for_each = local.enabled_environments

  filename = "${each.key}.txt"

  content = <<-multiline_marker
    Environment: ${upper(each.key)}
    Region: ${each.value.region}
  multiline_marker
}
```

This demonstrates an important Terraform pattern:

```text
Input variables
      ↓
for expression
      ↓
filtered/transformed collection
      ↓
local value
      ↓
for_each
      ↓
resource instances
```

With `stage` disabled, Terraform creates files for:

```text
dev
test
prod
```

but not:

```text
stage
```

---

# Heredoc / Multiline Strings

The final exercise also uses a heredoc:

```hcl
content = <<-multiline_marker
  Environment: ${upper(each.key)}
  Region: ${each.value.region}
multiline_marker
```

The marker name is arbitrary. `EOT`, `EOF`, `TEXT`, or another identifier can be used.

Terraform expressions can still be interpolated inside the heredoc.

For example:

```hcl
${upper(each.key)}
```

is evaluated before the resulting string is assigned to the resource.

---

# Key Takeaways

The main mental models from this lab are:

```text
for expression
    → produces/transforms a value

for_each
    → creates multiple resource instances

dynamic
    → generates nested blocks

locals
    → names intermediate/derived values

try()
    → safely obtain a value with a fallback

can()
    → test whether an expression can be evaluated

conditional
    → choose a value based on a condition
```

The most important lesson is that Terraform expressions become especially powerful when **composed together** rather than used in isolation.

Example:

```text
variables
   ↓
for expression
   ↓
locals
   ↓
for_each
   ↓
resource
   ↓
outputs
```

---

## Terraform Commands Used

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

## Branch Progress

`05-expressions` is part of the Terraform Fundamentals learning series:

```text
01-basics
02-variables
03-outputs
04-data-sources
05-expressions    ← current
06-meta-arguments
07-state
08-modules
09-azure
10-final-project