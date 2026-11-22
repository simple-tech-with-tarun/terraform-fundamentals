# Advanced Terraform Expressions and Functions

## Overview

This chapter explores Terraform's built-in functions and advanced expressions for working with strings, numbers, lists, maps, sets, and nested collections.

The examples use environment and application configurations to demonstrate how Terraform can transform, filter, combine, and format data without requiring additional resources.

The focus is on understanding how functions work individually and how they can be combined with `for` expressions to create dynamic and reusable configurations.

## Learning Objectives

By completing this chapter, you will understand how to:

- Work with Terraform local values.
- Use built-in functions to inspect and transform collections.
- Transform and filter lists and maps using `for` expressions.
- Work with nested collections and flatten their structures.
- Format and combine strings.
- Sort, reverse, and remove duplicate collection elements.
- Convert between collection types.
- Perform set operations.
- Combine multiple functions and expressions to produce meaningful outputs.

---

## 1. Working with Local Values

Terraform local values allow you to assign names to expressions and reuse them throughout a configuration.

They help reduce repetition and make configurations easier to read and maintain.

Local values are declared using the `locals` block.

Example:

```hcl
locals {
  environments = ["dev", "stage", "prod"]

  environment_regions = {
    dev   = "centralindia"
    stage = "westindia"
    prod  = "eastus"
  }
}
```

Local values can be referenced using the `local` object.

For example:

```hcl
local.environments
local.environment_regions
```

Local values are useful when the same expression or configuration data needs to be referenced in multiple places.

## 2. Working with Collection Functions

Terraform provides several built-in functions for working with lists, maps, and other collection types.

Some commonly used functions include:

| Function | Description |
|---|---|
| `keys()` | Returns the keys of a map as a list. |
| `values()` | Returns the values of a map as a list. |
| `lookup()` | Retrieves a value from a map using a key, with an optional default. |
| `merge()` | Combines multiple maps into a single map. |
| `concat()` | Combines multiple lists into one list. |
| `distinct()` | Removes duplicate elements from a list. |
| `contains()` | Checks whether a collection contains a specified value. |
| `length()` | Returns the number of elements in a collection or characters in a string. |

These functions can be used independently or combined with other expressions.

For example, `keys()` and `values()` can help inspect map data, while `merge()` can combine configuration maps.

## 3. Transforming Collections with `for` Expressions

Terraform `for` expressions allow you to iterate over collections and create new lists or maps.

### Transforming a list

A `for` expression can create a new list by applying an operation to each element.

Example:

```hcl
[for environment in local.environments : upper(environment)]
```

This transforms each environment name to uppercase.

Expected result:

```hcl
[
  "DEV",
  "STAGE",
  "PROD"
]
```

### Transforming a map

A `for` expression can also create a new map.

Example:

```hcl
{
  for key, value in local.environment_regions :
  key => upper(value)
}
```

This preserves the map keys while transforming the values.

The `key => value` structure defines the key and value of each resulting map element.

## 4. Filtering Collections with `for` Expressions

A `for` expression can include an `if` condition to filter elements.

### Filtering a list

Example:

```hcl
[
  for environment in local.environments :
  environment
  if environment != "prod"
]
```

This excludes the production environment from the resulting list.

### Filtering a map

Example:

```hcl
{
  for key, value in local.environment_regions :
  key => value
  if key == "prod"
}
```

Expected result:

```hcl
{
  prod = "eastus"
}
```

The `if` condition determines which elements are included in the resulting collection.

## 5. Combining Collection Functions and Expressions

Terraform functions can be combined with `for` expressions to perform more complex transformations.

For example:

```hcl
distinct([
  for environment in local.environments :
  upper(environment)
])
```

This transforms the environment names to uppercase and removes duplicate values.

Functions can also be combined to inspect and transform collection data in a single expression.

This approach is useful when working with dynamic configuration values rather than manually maintaining separate collections.

## 6. Transforming and Filtering Maps

Map `for` expressions can transform both keys and values, as well as filter entries based on conditions.

### Filtering a map by key

```hcl
production_environment_regions = {
  for key, value in local.environment_regions :
  key => value
  if key == "prod"
}
```

Expected result:

```hcl
{
  prod = "eastus"
}
```

### Transforming map keys and values

```hcl
environment_regions_uppercase = {
  for key, value in local.environment_regions :
  upper(key) => upper(value)
}
```

Expected result:

```hcl
{
  DEV   = "CENTRALINDIA"
  PROD  = "EASTUS"
  STAGE = "WESTINDIA"
}
```

### Creating a map from a list

```hcl
environment_index = {
  for index, value in local.environments :
  upper(value) => index
}
```

Expected result:

```hcl
{
  DEV   = 0
  STAGE = 1
  PROD  = 2
}
```

The index and value are available when iterating over a list using a `for` expression.

### Filtering a map based on its values

Terraform's `strcontains()` function checks whether a string contains a specified substring.

```hcl
indian_environment_regions = {
  for key, value in local.environment_regions :
  key => value
  if strcontains(value, "india")
}
```

Expected result:

```hcl
{
  dev   = "centralindia"
  stage = "westindia"
}
```

This example filters the map based on its region values rather than its keys.

## 7. Working with Nested Collections

Terraform collections can contain other collections.

For example, an environment can have multiple applications:

```hcl
environment_applications = {
  dev   = ["frontend", "backend"]
  stage = ["frontend", "backend", "database"]
  prod  = ["frontend", "backend", "database", "monitoring"]
}
```

### Flattening nested lists

The `flatten()` function converts a nested list structure into a single-level list.

```hcl
flat_applications = flatten([
  for key, value in local.environment_applications :
  value
])
```

Expected result:

```hcl
[
  "frontend",
  "backend",
  "frontend",
  "backend",
  "database",
  "monitoring",
  "frontend",
  "backend",
  "database"
]
```

The original application groupings are removed, while the elements and their repetitions are retained.

### Removing duplicate values

The `distinct()` function removes duplicate elements from a list while preserving the first occurrence of each element.

```hcl
unique_applications = distinct(flatten([
  for key, value in local.environment_applications : value
]))
```

Expected result:

```hcl
[
  "frontend",
  "backend",
  "database",
  "monitoring"
]
```

### Counting elements in nested collections

The `length()` function can be combined with a map `for` expression to count the number of applications in each environment.

```hcl
application_count_by_environment = {
  for key, value in local.environment_applications :
  key => length(value)
}
```

Expected result:

```hcl
{
  dev   = 2
  stage = 3
  prod  = 4
}
```

### Filtering based on collection length

The same approach can be used to filter environments based on the number of applications.

```hcl
large_environments = {
  for key, value in local.environment_applications :
  key => value
  if length(value) > 2
}
```

This returns only environments with more than two applications.

## 8. Working with Strings and Formatting

Terraform provides functions for transforming strings and generating formatted text.

### Converting strings to uppercase

The `upper()` function converts a string to uppercase.

```hcl
upper("dev")
```

Result:

```text
DEV
```

### Checking whether a string contains a substring

The `strcontains()` function returns a Boolean value indicating whether a string contains the specified substring.

```hcl
strcontains("centralindia", "india")
```

Result:

```hcl
true
```

### Formatting strings with interpolation

Terraform supports string interpolation using `${}`.

```hcl
environment_summary_map = {
  for key, value in local.environment_applications :
  key => "${key} has ${length(value)} applications"
}
```

### Formatting strings with `format()`

The `format()` function provides another way to construct strings using format specifiers.

```hcl
environment_summary_map2 = {
  for key, value in local.environment_applications :
  key => format("%s has %d applications", key, length(value))
}
```

Common format specifiers include:

| Specifier | Purpose |
|---|---|
| `%s` | String |
| `%d` | Integer |
| `%f` | Floating-point number |

The arguments supplied to `format()` are substituted into the format string from left to right.

### Joining list elements into a string

The `join()` function combines list elements into a single string using a specified separator.

```hcl
join(", ", ["frontend", "backend", "database"])
```

Result:

```text
frontend, backend, database
```

### Combining formatting and joining

The following expression creates a readable application summary for each environment and combines the results into one string.

```hcl
environment_application_map = {
  for key, value in local.environment_applications :
  key => format("%s: %s", key, join(", ", value))
}
```

The resulting map contains one formatted summary per environment.

The summaries can then be combined:

```hcl
environment_application_summary = join("| ", [
  for key, value in {
    for key, value in local.environment_applications :
    key => format("%s: %s", key, join(", ", value))
  } : value
])
```

Expected result:

```text
dev: frontend, backend| prod: frontend, backend, database, monitoring| stage: frontend, backend, database
```

This demonstrates how nested expressions and multiple functions can be composed to generate a single output.

## 9. Sorting and Reversing Collections

Terraform provides functions for changing the order of list elements.

### Sorting a list

The `sort()` function returns a new list with string elements sorted in lexicographical order.

```hcl
sorted_environments = sort(local.environments)
```

For the original list:

```hcl
["dev", "stage", "prod"]
```

Expected result:

```hcl
["dev", "prod", "stage"]
```

### Reversing a list

The `reverse()` function returns a list with its elements in reverse order.

```hcl
reversed_environments = reverse(local.environments)
```

Expected result:

```hcl
["prod", "stage", "dev"]
```

### Combining sorting and reversing

Functions can be nested to perform multiple operations.

```hcl
reversed_sorted_environments = reverse(sort(local.environments))
```

Expected result:

```hcl
["stage", "prod", "dev"]
```

The `sort()` function sorts the original values first, and `reverse()` then reverses the resulting list.

## 10. Working with Sets

Terraform supports sets as a collection type.

Unlike lists, sets:

- Do not contain duplicate elements.
- Do not guarantee element ordering.
- Cannot be accessed using numeric indexes.

### Removing duplicates with `distinct()`

The `distinct()` function removes duplicates from a list while retaining the first occurrence order.

```hcl
unique_applications_sorted = distinct(sort(local.applications))
```

This first sorts the list and then removes duplicate elements.

### Converting a list into a set

The `toset()` function converts a collection into a set.

```hcl
applications_set = toset(local.applications)
```

The resulting set contains only unique application names.

For example, given:

```hcl
applications = [
  "frontend",
  "backend",
  "frontend",
  "database",
  "backend"
]
```

The resulting set contains:

```text
frontend
backend
database
```

The order displayed for a set should not be treated as guaranteed.

## 11. Converting Lists into Maps with `zipmap()`

The `zipmap()` function creates a map by combining two lists.

- The first list supplies the map keys.
- The second list supplies the corresponding values.

Example:

```hcl
environment_names = ["dev", "stage", "prod"]

environment_region = [
  "centralindia",
  "westindia",
  "eastus"
]

names_regions = zipmap(
  local.environment_names,
  local.environment_region
)
```

Expected result:

```hcl
{
  dev   = "centralindia"
  stage = "westindia"
  prod  = "eastus"
}
```

The elements are paired by their positions in the two lists.

The lists should have matching lengths, and the keys should be unique to avoid unexpected map results.

## 12. Function Composition

Function composition means combining multiple functions and expressions to perform a more complex operation.

Instead of using separate steps for every transformation, Terraform allows functions to be nested within one another.

Examples from this chapter include:

### Sorting and removing duplicates

```hcl
distinct(sort(local.applications))
```

### Flattening nested lists and removing duplicates

```hcl
distinct(flatten([
  for key, value in local.environment_applications : value
]))
```

### Formatting and joining application names

```hcl
join(", ", local.environment_applications["dev"])
```

### Sorting and reversing

```hcl
reverse(sort(local.environments))
```

Function composition helps keep configurations concise while allowing complex data transformations.

It is important to understand the order in which nested functions are evaluated because the output of one function becomes the input of the next.

## 13. Outputs and Expected Results

Terraform output values expose information calculated by the configuration.

For this chapter, outputs are used to inspect the results of local values, collection functions, and expressions.

The following table summarizes the concepts demonstrated.

| Output / Local | Function or Expression | Purpose |
|---|---|---|
| `production_environment_regions` | Map `for` expression with `if` | Filters the production environment. |
| `environment_regions_uppercase` | `upper()` | Transforms map keys and values to uppercase. |
| `environment_index` | List `for` expression | Creates a map containing environment indexes. |
| `indian_environment_regions` | `strcontains()` | Filters regions containing `india`. |
| `flat_applications` | `flatten()` | Converts nested application lists into a single list. |
| `unique_applications` | `distinct()`, `flatten()` | Removes duplicate application names. |
| `application_count_by_environment` | `length()` | Counts applications per environment. |
| `large_environments` | `length()` and `if` | Filters environments with more than two applications. |
| `environment_summary_map` | String interpolation | Creates environment summary strings. |
| `environment_summary_map2` | `format()` | Creates equivalent formatted summary strings. |
| `environment_application_map` | `format()`, `join()` | Formats application names per environment. |
| `environment_application_summary` | `join()`, `format()` and `for` expressions | Combines environment summaries into one string. |
| `sorted_environments` | `sort()` | Sorts environment names. |
| `reversed_environments` | `reverse()` | Reverses the original environment list. |
| `reversed_sorted_environments` | `sort()`, `reverse()` | Sorts and then reverses environment names. |
| `unique_applications_sorted` | `sort()`, `distinct()` | Sorts application names and removes duplicates. |
| `applications_set` | `toset()` | Converts a list into a set. |
| `names_regions` | `zipmap()` | Converts two lists into a map. |
| `all_services` | `setunion()` | Combines unique elements from multiple sets. |
| `intersection` | `setintersection()` | Returns elements common to all supplied sets. |
| `subtract` | `setsubtract()` | Returns elements present in the first set but not the second. |

To inspect the calculated values, define outputs in `outputs.tf`.

Example:

```hcl
output "sorted_environments" {
  value = local.sorted_environments
}

output "application_count_by_environment" {
  value = local.application_count_by_environment
}
```

Run the following command to inspect the planned output values:

```powershell
terraform plan
```

You can also use:

```powershell
terraform output
```

The `terraform output` command displays values from the latest applied state. For configurations that only calculate local values and outputs, `terraform plan` is useful for reviewing the expected changes without applying them.

## 14. Formatting, Validation, and Planning

Before committing Terraform configuration changes, it is important to format and validate the files and review the execution plan.

### 14.1 Format the Configuration

Run:

```powershell
terraform fmt
```

This formats Terraform files according to Terraform's standard formatting rules.

To check all Terraform files in the current directory and its subdirectories:

```powershell
terraform fmt -recursive
```

### 14.2 Validate the Configuration

Run:

```powershell
terraform validate
```

This checks whether the Terraform configuration is syntactically valid and internally consistent.

Validation does not verify that every planned operation will succeed against a real provider or infrastructure environment.

### 14.3 Review the Plan

Run:

```powershell
terraform plan
```

This previews the changes Terraform intends to make.

For this chapter, the main focus is reviewing calculated output values and confirming that the expressions return the expected results.

No infrastructure deployment is required to practise the local values and expression examples in this chapter.

---

## 15. Key Takeaways

This chapter covered several important Terraform functions and expression techniques.

### Working with collections

- `keys()` and `values()` help extract information from maps.
- `lookup()` retrieves map values using keys.
- `merge()` combines maps.
- `concat()` combines lists.
- `distinct()` removes duplicate list elements.
- `contains()` checks whether a collection contains a value.
- `length()` counts elements in a collection.

### Transforming and filtering data

- `for` expressions can transform lists and maps.
- Adding an `if` condition allows collections to be filtered dynamically.
- Map `for` expressions can transform both keys and values.
- `flatten()` converts nested lists into a single-level list.
- `strcontains()` can be used to filter strings based on their contents.

### Working with strings

- `upper()` transforms strings to uppercase.
- String interpolation allows expressions to be embedded in strings.
- `format()` creates formatted strings using placeholders.
- `join()` combines list elements into a single string.

### Sorting and sets

- `sort()` sorts string elements in a list.
- `reverse()` reverses the order of list elements.
- `toset()` converts a collection into a set and removes duplicates.
- Sets do not guarantee element ordering and cannot be indexed.

### Converting and combining collections

- `zipmap()` combines two lists into a map.
- `setunion()` combines elements from multiple sets.
- `setintersection()` returns elements common to all supplied sets.
- `setsubtract()` returns elements present in one set but not another.
- Function composition allows multiple functions to be combined into a single expression.

### Final Notes

Terraform functions and expressions make configurations more dynamic and reusable.

Understanding how to combine functions with `for` expressions is particularly useful when working with environment-specific settings, application configurations, resource definitions, and other structured data.

The examples in this chapter provide a foundation for writing more expressive Terraform configurations without relying on hardcoded values or unnecessary repetition.

---

## Useful Terraform Commands

| Command | Purpose |
|---|---|
| `terraform init` | Initializes the working directory. |
| `terraform fmt` | Formats Terraform configuration files. |
| `terraform validate` | Validates the configuration. |
| `terraform plan` | Previews the changes Terraform intends to make. |
| `terraform output` | Displays outputs from the latest applied state. |
| `terraform providers` | Displays the providers required by the configuration. |
