# Terraform Fundamentals – Learning Roadmap

## 1. Project Overview

This repository provides a practical learning path for understanding **Terraform and Infrastructure as Code (IaC)** through concepts, configuration examples, and hands-on exercises.

The objective is to build a strong understanding of Terraform fundamentals and progressively apply that knowledge to reusable, modular, and cloud-based infrastructure.

The repository emphasizes understanding how Terraform works, why its features are used, and how different components come together to manage infrastructure.

The examples primarily use Microsoft Azure as the hands-on cloud platform, while the Terraform concepts remain applicable across different providers.

## 2. Learning Path

The repository is organized into progressive chapters. Each chapter introduces concepts that build on previously covered topics.

| Chapter | Topic | Status |
|---|---|---|
| 01 | Terraform Basics | Completed |
| 02 | Variables | Completed |
| 03 | Outputs | Completed |
| 04 | Data Sources | Completed |
| 05 | Expressions | Completed |
| 06 | Meta-Arguments | Completed |
| 07 | Terraform State | Completed |
| 08 | Modules | Completed |
| 09 | Terraform with Azure | Completed |
| 10 | Final Project – Modular Azure Infrastructure | Completed |
| 11 | Advanced Expressions and Functions | In Progress |

Explore the individual chapter directories for detailed explanations, configuration examples, exercises, and expected results.

## 3. Advanced Expressions and Functions

Chapter 11 extends the foundational knowledge of Terraform expressions and built-in functions.

The objective is to understand how functions can be combined to manipulate strings, numbers, collections, and other values to create more flexible Terraform configurations.

### Topics Covered

- Collection functions
- List, map, and set operations
- `for` expressions
- Collection filtering and transformation

### Topics Planned

The following topics will extend the chapter:

**Networking and CIDR Functions**
- `cidrsubnet()`
- `cidrhost()`
- `cidrnetmask()`
- `cidrsubnets()`

**Advanced Collection Functions**
- `setproduct()`
- `transpose()`
- Further practical applications of `concat()`

**Files and File System Functions**
- `file()`
- `fileexists()`
- `fileset()`

**Templates and Data Encoding**
- `templatefile()`
- `jsonencode()`
- `jsondecode()`
- `yamlencode()`
- `yamldecode()`

These topics will be introduced through practical examples and exercises.

## 4. Future Learning Extensions

After completing the core Terraform learning path, the repository may be extended with more advanced Infrastructure as Code concepts and real-world automation scenarios.

Potential areas for further exploration include:

### Terraform and CI/CD
- Terraform with GitHub Actions
- Automated Terraform validation
- Plan and apply workflows
- Infrastructure deployment pipelines
- Environment-specific deployment workflows

### Remote State and Backend Management
- Azure Storage backend
- Remote state configuration
- State locking
- State management across environments
- State security and access management

### Infrastructure Testing and Security
- Terraform testing
- Infrastructure validation
- Security scanning
- Static analysis
- Configuration compliance

### Advanced Terraform Architecture
- Reusable infrastructure patterns
- Environment management
- Module design and versioning
- Enterprise Terraform architecture
- Azure Landing Zones

These are potential extensions rather than committed chapters. Their scope may evolve as the repository develops.

## 5. Hands-on Learning Approach

This repository follows a practical, exercise-driven learning approach.

For each topic:

1. Understand the underlying Terraform concept.
2. Review the relevant configuration syntax.
3. Examine practical examples.
4. Write or modify Terraform configurations.
5. Execute `terraform validate`.
6. Review the results using `terraform plan`.
7. Understand the output and how Terraform evaluates the configuration.
8. Experiment with different inputs and expressions.
9. Document the observations and important takeaways.

The emphasis is on understanding Terraform behaviour rather than simply memorizing syntax or commands.

## 6. Documentation and Version Control

Documentation and version control are important parts of the learning process.

The repository follows a structured approach to maintaining its learning material:

- Each chapter contains its own documentation.
- Practical exercises are documented with examples and expected results.
- Important observations and key takeaways are recorded.
- Changes are organized into meaningful Git commits.
- Feature branches are used for incremental development.
- Pull Requests are used to review and merge changes.
- The root README provides an overview of the repository and its learning path.

This approach demonstrates how technical knowledge can be developed, documented, reviewed, and maintained through a version-controlled project.

## 7. Expected Learning Outcomes

By working through this repository, learners should develop the ability to:

- Understand Infrastructure as Code and Terraform fundamentals.
- Write and organize Terraform configurations.
- Work with providers, resources, variables, data sources, and outputs.
- Understand Terraform expressions and built-in functions.
- Transform and manipulate collections.
- Understand Terraform dependency management.
- Manage Terraform state and backend configurations.
- Build reusable infrastructure using modules.
- Deploy and manage Azure infrastructure using Terraform.
- Review and validate infrastructure changes.
- Troubleshoot common Terraform configuration issues.
- Structure and maintain modular Infrastructure as Code projects.
- Apply Git and GitHub workflows to manage Terraform code.

## 8. Roadmap Maintenance

This roadmap represents the current learning direction and planned development of the repository.

Topics may be refined, expanded, or reorganized as additional concepts and practical exercises are introduced.

The roadmap is intended to provide direction rather than impose a fixed sequence or completion schedule.

---

**The overall goal is to build a practical Terraform knowledge base that learners can study, experiment with, and refer to when working with Infrastructure as Code in real-world environments.**
