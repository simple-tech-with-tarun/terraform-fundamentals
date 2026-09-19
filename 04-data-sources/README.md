# Terraform Data Sources

This lab introduces **Terraform data sources** and demonstrates how Terraform can read information from existing objects and use that information elsewhere in the configuration.

## What is a Data Source?

A Terraform **resource** creates and manages an object.

A Terraform **data source** reads information about an existing object.

A useful mental model is:

```text
resource → create/manage something
data     → bring information into Terraform
output   → expose information from Terraform
```

Data sources are particularly useful when infrastructure already exists and Terraform needs information about it.

For example, in Azure:

```hcl
data "azurerm_virtual_network" "existing" {
  name                = "production-vnet"
  resource_group_name = "production-rg"
}
```

Terraform can then use attributes from that existing VNet:

```hcl
data.azurerm_virtual_network.existing.id
data.azurerm_virtual_network.existing.address_space
```

A data source does not automatically mean that Terraform manages the object.

---

## Resource vs Data Source

| Resource | Data Source |
|---|---|
| Creates or manages an object | Reads an existing object |
| Terraform manages its lifecycle | Terraform does not manage its lifecycle |
| Uses `resource` block | Uses `data` block |
| Example: create a file | Example: read an existing file |

---

## Lab Setup

This lab uses the `local` provider so that the concepts can be learned without requiring Azure authentication.

### Terraform-managed file

The lab creates:

```text
source.txt
```

using:

```hcl
resource "local_file" "source" {
  filename = "source.txt"
  content  = "This file was created by Terraform."
}
```

### Reading a Terraform-managed file

A data source can also read the file created by Terraform:

```hcl
data "local_file" "existing" {
  filename = local_file.source.filename
}
```

This demonstrates the syntax and relationship between resources and data sources.

Although the file is Terraform-managed, the data source itself is only **reading** it.

---

## Reading an External File

The more important example is a file created outside Terraform:

```text
data-source.txt
```

Its contents were created manually:

```text
File created outside terraform.
Now I am creating the copy.
```

Terraform reads it using:

```hcl
data "local_file" "existing-2" {
  filename = "./data-source.txt"
}
```

Terraform can then access values exposed by the data source:

```hcl
data.local_file.existing-2.content
data.local_file.existing-2.filename
data.local_file.existing-2.content_md5
data.local_file.existing-2.content_sha1
```

---

## Using Data Source Information in a Resource

The data source becomes particularly useful when another Terraform resource consumes its information.

```hcl
resource "local_file" "copy" {
  filename = "copy.txt"
  content  = data.local_file.existing-2.content
}
```

The flow is:

```text
data-source.txt
       │
       ▼
data.local_file.existing-2
       │
       │ content
       ▼
local_file.copy
       │
       ▼
copy.txt
```

Terraform is therefore using information from an existing external object to create a new managed object.

---

## Outputs

The lab exposes several values:

```hcl
output "source" {
  value = local_file.source.content
}

output "s2" {
  value = data.local_file.existing-2.content
}

output "existing" {
  value = local_file.copy.content
}

output "external_file_name" {
  value = data.local_file.existing-2.filename
}

output "external_file_md5" {
  value = data.local_file.existing-2.content_md5
}

output "external_file_sha1" {
  value = data.local_file.existing-2.content_sha1
}
```

This demonstrates the distinction between:

```text
data source → reads information
output      → exposes information
```

---

## Important Observation

When the external file was changed, Terraform detected the changed data source value and updated the dependent resource.

The data source itself was not created by Terraform.

Terraform simply read the external file and used its current information.

---

## Data Source vs Import

A data source and an import serve different purposes.

### Data source

Use a data source when Terraform needs to **read information** about something that already exists.

```text
Existing infrastructure
        │
        ▼
    data source
        │
        ▼
Terraform configuration
```

### Import

Use import when an existing object should become **managed by Terraform**.

```text
Existing infrastructure
        │
        ▼
      import
        │
        ▼
Terraform-managed resource
```

A data source does not make an object Terraform-managed.

---

## Commands Practiced

```powershell
terraform init
terraform validate
terraform plan
terraform apply
terraform apply --auto-approve
terraform show
terraform state list
terraform output
```

---

## Key Takeaways

1. `resource` creates or manages infrastructure.
2. `data` reads information about an existing object.
3. Data sources can read objects created outside the current Terraform configuration.
4. Data source values can be consumed by resources.
5. Outputs expose values from resources, data sources, variables, and expressions.
6. A data source does not make an object Terraform-managed.
7. Data sources are commonly used in real Azure environments to consume existing infrastructure.
8. Data sources can participate in Terraform's dependency graph when their values are referenced elsewhere.

### Mental Model

```text
              ┌─────────────────┐
              │ Existing object │
              └────────┬────────┘
                       │
                       ▼
                 ┌───────────┐
                 │    data   │
                 │  source   │
                 └─────┬─────┘
                       │
                       │ information
                       ▼
              ┌─────────────────┐
              │ Terraform code │
              └────────┬────────┘
                       │
                       ▼
                 ┌───────────┐
                 │ resource  │
                 └───────────┘
```

**Data = bring information into Terraform.**

**Output = expose information out of Terraform.**