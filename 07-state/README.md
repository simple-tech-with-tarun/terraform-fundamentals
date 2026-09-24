# Terraform State

This lab explores how Terraform manages state, how state is inspected and manipulated, how remote backends work, how state locking protects shared state, and how one Terraform configuration can consume outputs from another Terraform state.

The goal is to understand Terraform state as a core part of Terraform's operation rather than treating it as a file that Terraform happens to create.

---

## Topics Covered

- Terraform state fundamentals
- State inspection
- State addresses
- `terraform state list`
- `terraform state show`
- `terraform show`
- `terraform show -json`
- State metadata
- State serial and lineage
- State manipulation
- `terraform state mv`
- `terraform state rm`
- Provider installation vs provider identity
- `terraform state replace-provider`
- Importing existing Azure resources
- State refresh
- State backup and recovery
- Local vs remote state
- Azure Storage backend
- Remote state locking
- Lock contention
- Stale locks
- `terraform force-unlock`
- `-lock=false`
- `terraform_remote_state`
- Cross-state outputs
- State boundaries and dependencies

---

# 1. State Basics

Terraform state records the relationship between Terraform configuration and the real resources Terraform manages.

A simplified mental model is:

```text
Terraform configuration
        ↓
      State
        ↓
Real infrastructure
```

The state allows Terraform to determine what resources already exist, what has changed, and what actions are required to make reality match the configuration.

With the local backend, Terraform stores state in:

```text
terraform.tfstate
```

Terraform may also maintain:

```text
terraform.tfstate.backup
```

as a previous state snapshot.

---

# 2. State Addresses

Every managed resource has a Terraform state address.

For example:

```text
local_file.example
```

When `for_each` is used:

```text
local_file.environment["dev"]
local_file.environment["test"]
local_file.environment["prod"]
```

When `count` is used:

```text
local_file.environment[0]
local_file.environment[1]
local_file.environment[2]
```

These addresses identify individual instances inside Terraform state.

This becomes especially important when resources are renamed or their instance structure changes.

---

# 3. Inspecting State

The following commands were used to inspect state:

```bash
terraform state list
terraform state show <address>
terraform show
terraform show -json
terraform state pull
```

### `terraform state list`

Lists resources currently tracked in state.

Example:

```text
local_file.example
```

### `terraform state show`

Displays the state information for a specific resource.

Example:

```bash
terraform state show local_file.example
```

### `terraform show`

Displays the current Terraform state in a human-readable format.

### `terraform show -json`

Produces machine-readable state information.

This exposed details such as:

- Resource addresses
- Provider addresses
- Resource attributes
- IDs
- Sensitive attributes
- State metadata

---

# 4. State Metadata

The state file contains metadata such as:

```text
version
terraform_version
serial
lineage
```

### Serial

The serial number represents the revision of a state lineage.

For example:

```text
serial = 1
```

followed by:

```text
serial = 2
```

indicates that the state has advanced to a newer revision.

### Lineage

The lineage identifies the state history.

A state backup can therefore have:

```text
same lineage
different serial
```

This means it belongs to the same state history but represents an older revision.

---

# 5. State Manipulation

Terraform provides commands for manipulating state without directly changing infrastructure.

These commands operate on Terraform's understanding of resources.

Important examples:

```bash
terraform state mv
terraform state rm
terraform state replace-provider
```

---

# 6. `terraform state mv`

The `state mv` experiment demonstrated how Terraform state addresses can be changed.

A resource was changed from:

```text
local_file.original
```

to:

```text
local_file.renamed
```

Without moving the state, Terraform interpreted the change as:

```text
destroy old resource
create new resource
```

After:

```bash
terraform state mv local_file.original local_file.renamed
```

Terraform reported:

```text
No changes
```

The important point is:

```text
state mv
    ↓
changes the Terraform state address

It does not recreate the real resource.
```

The underlying resource identity remained unchanged.

This is useful when reorganizing or renaming Terraform configuration without unnecessarily recreating infrastructure.

---

# 7. `terraform state rm`

The `state rm` experiment demonstrated that removing a resource from state is different from destroying the resource.

Example:

```bash
terraform state rm local_file.example
```

After the command:

```text
Terraform state
    ↓
resource no longer tracked
```

but:

```text
Physical file
    ↓
still exists
```

The next plan treated the resource as something Terraform needed to create/manage again.

Therefore:

```text
terraform state rm
    → removes Terraform's state record

terraform destroy
    → destroys managed infrastructure
```

They are fundamentally different operations.

---

# 8. Provider Installation vs Provider Identity

The provider replacement experiment demonstrated an important distinction.

Terraform has a provider source address such as:

```text
registry.terraform.io/hashicorp/local
```

A local filesystem mirror can change **where Terraform obtains the provider binary**.

For example:

```text
provider installation
        ↓
local filesystem mirror
```

But this does not automatically change the provider's identity in state.

The state can still contain:

```text
registry.terraform.io/hashicorp/local
```

Therefore:

```text
Provider installation source
    ≠
Provider source address
```

The `terraform state replace-provider` command exists for changing provider addresses stored in state when performing a genuine provider migration.

The experiment demonstrated why simply creating a provider mirror does not constitute a provider identity migration.

---

# 9. Importing Existing Resources

The state import experiment used Azure Resource Groups.

An Azure Resource Group was created outside Terraform:

```bash
az group create
```

Terraform configuration was then created to describe that existing resource.

The resource was imported using:

```bash
terraform import azurerm_resource_group.imported "<resource-id>"
```

The workflow was:

```text
Existing Azure resource
        ↓
Terraform configuration
        ↓
terraform import
        ↓
Terraform state
        ↓
terraform plan
        ↓
Reconcile configuration with reality
```

Import does not create the resource.

It establishes Terraform's state relationship with an existing resource.

The experiment also demonstrated that provider-specific import IDs are required.

A Terraform expression such as:

```hcl
data.azurerm_resource_group.existing.id
```

cannot be directly passed to:

```bash
terraform import
```

because the import command receives its ID from the CLI rather than evaluating Terraform configuration expressions.

External discovery can be used instead:

```powershell
$id = az group show --name terraform-state-import-rg --query id --output tsv
terraform import azurerm_resource_group.imported $id
```

---

# 10. State Refresh

The refresh experiment demonstrated the difference between Terraform configuration, state, and real infrastructure.

An Azure Resource Group was initially configured with:

```text
environment = lab
```

The Azure resource was then modified outside Terraform:

```text
environment = external
```

Running:

```bash
terraform plan
```

detected the difference.

Terraform refreshed its view of the remote resource while calculating the plan, then proposed restoring the configuration value.

The experiment also used:

```bash
terraform refresh
```

which updated persisted state to reflect the remote infrastructure.

Modern Terraform considers `terraform refresh` deprecated; normal workflows should use:

```bash
terraform plan
terraform apply
```

The important distinction is:

```text
terraform plan
    → refreshes information and calculates a proposal

terraform refresh
    → refreshes persisted state without applying configuration changes

terraform apply
    → refreshes, plans, changes infrastructure, and persists resulting state
```

---

# 11. State Backup and Recovery

The state backup experiment demonstrated Terraform's local state backup behavior.

After multiple state revisions, the working directory contained:

```text
terraform.tfstate
terraform.tfstate.backup
```

The files represented different revisions of the same state lineage.

For example:

```text
terraform.tfstate
    serial = 3

terraform.tfstate.backup
    serial = 1
```

while both shared the same lineage.

The important distinction is:

```text
serial
    → state revision

lineage
    → state history identity
```

The `.tfstate.backup` file should not be treated as a complete revision history. It represents an older state snapshot.

A state backup can be restored by replacing the current state file with the desired backup.

Example:

```powershell
Copy-Item terraform.tfstate terraform.tfstate.before-recovery
Copy-Item terraform.tfstate.backup terraform.tfstate -Force
```

However:

```text
Restoring state
    ≠
Restoring infrastructure
```

The state file only changes Terraform's recorded knowledge.

Terraform still compares the restored state against actual infrastructure during subsequent operations.

---

# 12. Remote State with Azure Storage

The remote backend experiment moved Terraform state from the local filesystem into Azure Storage.

The backend used:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

The architecture became:

```text
Terraform
    │
    ▼
Azure Storage Account
    │
    ▼
Blob container
    │
    ▼
terraform.tfstate
```

After configuring the backend:

```bash
terraform init
```

Terraform state was stored remotely.

There was no local:

```text
terraform.tfstate
```

Instead, the state could be inspected using:

```bash
terraform state pull
```

The remote state had metadata such as:

```text
serial
lineage
terraform_version
```

and these values changed as the state was updated.

---

# 13. Multiple State Files in One Backend

Different Terraform configurations can use different backend keys.

For example:

```text
tfstate/
├── terraform.tfstate
├── locking-test.tfstate
├── source.tfstate
└── consumer.tfstate
```

Each key represents a separate Terraform state object.

Therefore:

```text
same storage account
same container
different key
        ↓
different Terraform state
```

This allows multiple Terraform configurations to share the same backend storage while maintaining independent state.

---

# 14. Remote State Locking

The Azure backend also demonstrated Terraform state locking.

When Terraform performed an operation, the output showed:

```text
Acquiring state lock...
```

and later:

```text
Releasing state lock...
```

The purpose of the lock is to prevent multiple Terraform operations from modifying the same state concurrently.

---

# 15. Lock Contention

Two Terraform processes were deliberately run against the same state.

One process acquired the lock:

```text
OperationTypeApply
```

A second Terraform operation attempted to access the same state and received:

```text
Error acquiring the state lock
```

Terraform displayed lock information including:

```text
ID
Path
Operation
Who
Version
Created
```

This demonstrated that the lock belongs to the specific state object.

For example:

```text
locking-test.tfstate
```

has its own lock.

Another state:

```text
source.tfstate
```

has a separate state and therefore a separate locking context.

---

# 16. Stale Locks and `force-unlock`

A stale lock was deliberately created by terminating a Terraform process while it held the lock.

The next Terraform operation failed with:

```text
Error acquiring the state lock
```

The stale lock was then removed with:

```bash
terraform force-unlock <lock-id>
```

The important point is:

```text
force-unlock
    ↓
removes the state lock

It does NOT:
    ↓
apply configuration
undo infrastructure changes
restore state
```

`force-unlock` should therefore be used carefully and only when the lock is genuinely stale.

---

# 17. Disabling Locking with `-lock=false`

The experiment also used:

```bash
terraform plan -lock=false
```

while another Terraform process was holding the state lock.

The command was able to read the state and produce a plan despite the existing lock.

This demonstrated that:

```text
-lock=false
    ↓
disables state locking for that operation
```

It does not mean:

```text
do not read state
```

and it does not mean:

```text
use a different state
```

The experiment also showed that an operation with locking disabled can observe state while another operation is holding the lock.

The key lesson is:

```text
State locking
    → concurrency coordination

State reading
    → separate operation
```

Disabling locking is generally unsafe for shared state because Terraform loses its normal concurrency protection.

---

# 18. Remote State Data

The final experiment introduced:

```hcl
data "terraform_remote_state" "source" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "source.tfstate"
  }
}
```

A separate source configuration stored its state in:

```text
source.tfstate
```

and exposed root outputs:

```hcl
output "source_filename" {
  value = local_file.source.filename
}

output "source_content" {
  value = local_file.source.content
}

output "source_id" {
  value = local_file.source.id
}
```

The consumer configuration then accessed those outputs:

```hcl
data.terraform_remote_state.source.outputs.source_filename
```

and:

```hcl
data.terraform_remote_state.source.outputs.source_id
```

---

# 19. `terraform_remote_state` Only Exposes Root Outputs

An important experiment was performed by attempting to access the source resource directly:

```hcl
data.terraform_remote_state.source.local_file.source.id
```

Terraform returned:

```text
Error: Unsupported attribute
```

because `terraform_remote_state` does not expose the source state's resource objects directly.

The correct interface is:

```text
data.terraform_remote_state
        ↓
outputs
        ↓
root output name
```

For example:

```hcl
data.terraform_remote_state.source.outputs.source_id
```

The source resource attribute therefore follows this chain:

```text
local_file.source.id
        ↓
source output
        ↓
source.tfstate
        ↓
terraform_remote_state
        ↓
outputs.source_id
        ↓
consumer
```

This makes root outputs the interface between independent Terraform states.

---

# 20. `terraform_remote_state` Does Not Read the Entire Backend

The remote state data source does not scan the entire Azure Storage container.

It uses the specified backend configuration and key:

```hcl
key = "source.tfstate"
```

to locate the particular state object.

Conceptually:

```text
Azure Storage container
│
├── terraform.tfstate
├── locking-test.tfstate
├── source.tfstate      ← selected
└── consumer.tfstate
```

The consumer targets:

```text
source.tfstate
```

It does not treat the entire container as one Terraform state.

---

# 21. Remote State and Locking Are Separate Concepts

One important architectural observation from the experiment is that the consumer's state lock and the source state's state lock are separate.

When the consumer runs:

```text
consumer configuration
        ↓
consumer.tfstate
        ↓
consumer state lock
```

The `terraform_remote_state` data source reads:

```text
source.tfstate
```

but the consumer's lock is on:

```text
consumer.tfstate
```

Therefore:

```text
Consumer lock
    ≠
Source state lock
```

`terraform_remote_state` should be understood as a **cross-state data dependency**, not as a cross-state locking mechanism.

This means state boundaries should be designed carefully when multiple Terraform configurations depend on one another.

---

# 22. State vs Infrastructure

One of the most important lessons from this lab is that Terraform state and infrastructure are related but not identical.

Operations such as:

```bash
terraform state mv
terraform state rm
terraform state replace-provider
terraform refresh
terraform force-unlock
```

can affect Terraform's state management without necessarily changing infrastructure.

A useful mental model is:

```text
                    Terraform
                       │
              ┌────────┴────────┐
              │                 │
          Configuration       State
              │                 │
              └────────┬────────┘
                       │
                       ▼
                Real infrastructure
```

Changing one layer does not automatically change the others.

---

# 23. Key Mental Models

The most important concepts from this lab are:

```text
terraform.tfstate
    → Terraform's recorded relationship with infrastructure

state address
    → identifies a resource instance in Terraform state

state mv
    → changes a state address

state rm
    → removes a resource from state without destroying it

import
    → brings an existing resource under Terraform state management

refresh
    → updates Terraform's knowledge from real infrastructure

remote backend
    → stores Terraform state outside the local working directory

state locking
    → coordinates concurrent access to shared state

force-unlock
    → removes a stale lock

-lock=false
    → disables locking for that operation

terraform_remote_state
    → consumes root outputs from another Terraform state
```

---

# 24. Overall State Architecture

The lab progressed from local state:

```text
Terraform
   │
   ▼
terraform.tfstate
```

to remote state:

```text
Terraform
   │
   ▼
Azure Storage
   │
   ▼
State object
```

and finally to multiple independent states:

```text
                 Azure Storage
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
   source.tfstate  consumer.tfstate  locking-test.tfstate
          │
          │ root outputs
          ▼
 terraform_remote_state
          │
          ▼
      Consumer
```

This is the foundation for structuring larger Terraform environments into separate state boundaries.

---

## Terraform Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform apply --auto-approve
terraform show
terraform show -json
terraform state list
terraform state show
terraform state pull
terraform state mv
terraform state rm
terraform state replace-provider
terraform import
terraform refresh
terraform force-unlock
terraform output
```

Additional Azure CLI commands were used for resource creation, discovery, and remote backend setup.

---

## Branch Progress

`07-state` is part of the Terraform Fundamentals learning series:

```text
01-basics
02-variables
03-outputs
04-data-sources
05-expressions
06-meta-arguments
07-state          ← current
08-modules
09-azure
10-final-project
```

The next branch will introduce **Terraform modules**, moving from Terraform state management into configuration reuse, structure, and composition.

This version reflects the experiments you actually ran rather than just listing Terraform state features.