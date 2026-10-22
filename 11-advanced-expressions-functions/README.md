# Advanced Terraform Expressions and Functions

## Overview

This chapter explores advanced Terraform expressions and built-in functions used to manipulate collections, retrieve values from maps, combine data, remove duplicates, and filter elements based on conditions.

Terraform expressions allow configurations to perform data transformations without requiring additional resources or external scripts. They are useful when working with environment configurations, resource tags, network settings, and other structured data.

This chapter builds on the concepts introduced in the earlier chapters and demonstrates how Terraform can process existing values using local values and output values.

### Objectives

By completing this chapter, you will learn how to:

- Retrieve map keys and values using `keys()` and `values()`.
- Retrieve map values safely using `lookup()`.
- Combine maps using `merge()`.
- Combine lists using `concat()`.
- Remove duplicate elements using `distinct()`.
- Check whether a collection contains a value using `contains()`.
- Count collection elements using `length()`.
- Transform collection elements using `for` expressions.
- Filter collection elements using an `if` condition.
- Expose and verify computed values using Terraform outputs.

---

## 1. Working with Local Values

Local values allow you to assign names to expressions and reuse their results throughout a Terraform configuration.

They are particularly useful when a configuration needs to derive new values from existing inputs or collections.

For example, a configuration may define a list of environments:

```hcl
environments = ["dev", "stage", "prod"]
```

The same list can then be reused to demonstrate transformations and filtering without defining separate lists for every operation.

Local values are referenced using the `local` object, followed by the local value's name. For example:

```hcl
local.environments
```

This approach keeps related configuration data together and makes expressions easier to understand and maintain.

---

## 2. Working with Collection Functions

Terraform provides built-in functions for working with lists, maps, and other collection types. These functions help derive values from existing data rather than requiring the same information to be maintained manually.

### 2.1 `keys()`

The `keys()` function returns a list containing the keys of a map.

**Syntax:**

```hcl
keys(map)
```

For example, when working with a map that associates environments with Azure regions, `keys()` can be used to retrieve the environment names.

```hcl
keys(local.environment_regions)
```

This expression returns the map's keys as a list. The returned keys are ordered lexically.

**Use case:** Retrieve the available environment names from a map without maintaining a separate list of the same keys.

### 2.2 `values()`

The `values()` function returns a list containing the values associated with the keys of a map.

**Syntax:**

```hcl
values(map)
```

For example:

```hcl
values(local.environment_regions)
```

This expression returns the map's values in the order corresponding to the lexically ordered map keys.

**Use case:** Extract configured values from a map when the keys are not required.

### 2.3 `lookup()`

The `lookup()` function retrieves the value associated with a key in a map. It can also return a fallback value when the requested key does not exist.

**Syntax:**

```hcl
lookup(map, key, default)
```

The arguments are:

- `map`: The map to search.
- `key`: The key whose value should be retrieved.
- `default`: The fallback value to return when the key is absent.

For example:

```hcl
lookup(local.environment_regions, "prod", "eastus")
```

If the map contains the `prod` key, Terraform returns its associated region. The fallback is used only when that key is absent.

**Use case:** Provide a fallback for optional map entries and avoid a failed lookup when a key is not present.

### 2.4 `merge()`

The `merge()` function combines two or more maps into a single map.

**Syntax:**

```hcl
merge(map1, map2, ...)
```

For example:

```hcl
merge(local.development_tags, local.default_tags)
```

When the same key appears in multiple maps, the value from the map appearing later in the argument list takes precedence.

This behavior is important when combining environment-specific tags with default tags. The order of the arguments determines which values override others.

**Use case:** Combine common tags with environment-specific tags while maintaining a consistent tag structure.

### 2.5 `concat()`

The `concat()` function combines two or more lists into a single list.

**Syntax:**

```hcl
concat(list1, list2, ...)
```

For example:

```hcl
concat(local.default_ports, local.production_ports)
```

The elements from the supplied lists are combined in argument order. The function does not automatically remove duplicates.

**Use case:** Combine lists of ports, regions, environments, or other configuration values.

### 2.6 `distinct()`

The `distinct()` function removes duplicate elements from a list while preserving the order of the first occurrence of each element.

**Syntax:**

```hcl
distinct(list)
```

For example:

```hcl
distinct(local.all_production_ports)
```

If the combined list contains a port more than once, the resulting list retains only its first occurrence.

When combining the lists `[80, 443]` and `[443, 8080]`, the combined list contains three unique port values after duplicates are removed:

```hcl
[80, 443, 8080]
```

**Use case:** Remove duplicate values from a combined collection before using it elsewhere in the configuration.

### 2.7 `contains()`

The `contains()` function checks whether a list or set contains a specified value.

**Syntax:**

```hcl
contains(collection, value)
```

For example:

```hcl
contains(local.unique_production_ports, 443)
```

The expression returns `true` if port `443` is present in the collection and `false` otherwise.

**Use case:** Check whether a required port, environment, or other value is present in a collection.

### 2.8 `length()`

The `length()` function returns the number of elements in a collection or the number of characters in a string.

**Syntax:**

```hcl
length(value)
```

For example:

```hcl
length(local.unique_production_ports)
```

If the collection contains three unique ports, the expression returns:

```hcl
3
```

**Use case:** Determine the size of a collection or check how many values are configured.

---

## 3. Transforming Collections with `for` Expressions

Terraform `for` expressions allow you to iterate over the elements of a collection and construct a new list or map from them.

They are useful when each element needs to be transformed or when a new collection must be derived from an existing one.

### 3.1 Syntax

A basic list-producing `for` expression follows this structure:

```hcl
[for item in collection : expression]
```

The components are:

- `item`: The temporary iteration variable representing the current element.
- `collection`: The list, map, or other supported collection being processed.
- `expression`: The value produced for each element.

The iteration variable is local to the expression and can be named according to the context.

### 3.2 Transforming Environment Names

Consider the existing environment list:

```hcl
environments = ["dev", "stage", "prod"]
```

A `for` expression can transform every environment name to uppercase using Terraform's `upper()` function.

```hcl
[for item in local.environments : upper(item)]
```

The expression processes each element and returns a new list:

```hcl
["DEV", "STAGE", "PROD"]
```

The original local value remains unchanged. The expression produces a separate result based on its elements.

**Key concept:** The expression after the colon determines the value returned for each element.

---

## 4. Filtering Collections with `for` Expressions

A `for` expression can also filter a collection by using an `if` condition after the result expression.

Filtering is useful when only elements satisfying a particular condition should be included in the resulting collection.

### 4.1 Filtering Production Environments

The existing environment list contains three values:

```hcl
environments = ["dev", "stage", "prod"]
```

Suppose the configuration needs a list containing only the production environment.

The `production_environments` local uses a `for` expression with an `if` condition to retain only matching elements:

```hcl
production_environments = [
  for item in local.environments : item
  if item == "prod"
]
```

The expression works as follows:

1. Terraform iterates over each element in `local.environments`.
2. The condition `item == "prod"` is evaluated for the current element.
3. Elements that satisfy the condition are included in the result.
4. Elements that do not satisfy the condition are excluded.

Given the input:

```hcl
["dev", "stage", "prod"]
```

The resulting value is:

```hcl
["prod"]
```

### 4.2 Understanding the Filtering Condition

The filtering expression has two important parts:

```hcl
item
```

This is the result expression. It determines what value is included for each matching element.

```hcl
if item == "prod"
```

This is the filtering condition. It determines which elements are included in the resulting collection.

The condition uses the equality operator `==` to compare the current element with the string `"prod"`.

Only elements for which the condition evaluates to `true` are retained.

### 4.3 Exposing the Filtered Result

A local value can be exposed through an output so that its computed value can be inspected.

```hcl
output "production_environments" {
  value = local.production_environments
}
```

The output makes the result available when Terraform evaluates the configuration.

The expected value is:

```hcl
production_environments = [
  "prod"
]
```

**Key concept:** A `for` expression transforms or filters a collection. The optional `if` clause controls which elements are included in the result.

---

## 5. Combining Collection Functions and Expressions

Collection functions and `for` expressions can be used together to derive values from existing configuration data.

For example, a configuration can combine port lists, remove duplicates, and check whether a particular port exists.

The following sequence illustrates the relationship between these operations:

```hcl
all_production_ports = concat(
  local.default_ports,
  local.production_ports
)

unique_production_ports = distinct(
  local.all_production_ports
)
```

If the source lists are:

```hcl
default_ports     = [80, 443]
production_ports  = [443, 8080]
```

The combined list is:

```hcl
[80, 443, 443, 8080]
```

After applying `distinct()`, the result is:

```hcl
[80, 443, 8080]
```

The resulting collection can then be used in other expressions:

```hcl
contains(local.unique_production_ports, 443)
```

This returns `true` because port `443` is present.

Similarly, `length()` can be used to determine the number of unique elements.

These examples demonstrate how Terraform functions can be composed to derive useful values from configuration data.

---

## 6. Outputs and Expected Results

Terraform output values provide a way to inspect the results of expressions and local values.

The outputs defined in this chapter expose selected results so that the behavior of the functions and expressions can be verified.

Depending on the configured examples, the results demonstrate the following behaviors:

| Expression or function | Expected behavior |
|---|---|
| `keys()` | Returns the keys of a map as a list |
| `values()` | Returns the values of a map as a list |
| `lookup()` | Returns a matching map value or the supplied fallback |
| `merge()` | Combines maps, with later arguments taking precedence for duplicate keys |
| `concat()` | Combines lists in argument order |
| `distinct()` | Removes duplicate elements while preserving first-occurrence order |
| `contains()` | Returns a Boolean indicating whether a value is present |
| `length()` | Returns the number of elements in a collection |
| `for` expression with `upper()` | Transforms environment names to uppercase |
| `for` expression with `if` | Filters the environment list to retain matching elements |

For the filtering example, the important result is:

```hcl
production_environments = [
  "prod"
]
```

Review the corresponding output values in the chapter configuration to see how each expression is exposed and evaluated.

---

## 7. Formatting, Validation, and Planning

Terraform configurations should be formatted and validated before their changes are submitted for review.

Run the following commands from the chapter directory.

### 7.1 Format the Configuration

```bash
terraform fmt
```

This formats Terraform configuration files according to Terraform's standard formatting rules.

### 7.2 Validate the Configuration

```bash
terraform validate
```

This checks whether the configuration is syntactically valid and internally consistent.

Validation does not prove that every expression produces the intended result, so inspect the plan output as well.

### 7.3 Review the Plan

```bash
terraform plan
```

Review the planned output values and confirm that they match the expected results.

For the filtering example, verify that `production_environments` contains only `"prod"`.

These checks help identify formatting issues, configuration errors, and unexpected expression results before submitting changes for review.

---

## 8. Key Takeaways

- Local values allow expressions to be named and reused.
- `keys()` and `values()` extract keys and values from maps.
- `lookup()` retrieves a map value with an optional fallback.
- `merge()` combines maps, with later arguments taking precedence for duplicate keys.
- `concat()` combines lists, while `distinct()` removes duplicate elements.
- `contains()` checks for the presence of a value in a collection.
- `length()` returns the size of a collection or the character count of a string.
- `for` expressions create new collections by transforming existing elements.
- An `if` clause in a `for` expression filters elements based on a condition.
- Outputs and Terraform validation commands help verify configuration behavior.

These concepts provide a foundation for writing more reusable Terraform configurations, processing structured data, and preparing for more advanced topics such as reusable modules and infrastructure lifecycle management.