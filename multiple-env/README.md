# Multiple Environment with Terraform

### Option 01 - Using Terraform Workspaces

1. Create a new workspace for each environment

```terraform
terraform workspace new dev
terraform workspace new prod
```

#### Pros 

- Easy to manage
- No need to create multiple directories
- No need to create multiple state files
- Code duplication is minimal

#### Cons

- No clear separation between environments
- No clear separation between state files
- No clear separation between resources
- Code doesn't ambiguously show deployment target
- Access to the state file is not restricted

### Option 02 - Using Terraform Modules

1. Create a new directory for each environment

```bash
mkdir dev
mkdir prod
```

2. Create a new module for each environment

```bash
mkdir modules/dev
mkdir modules/prod
```

#### Pros

- Clear separation between environments
- Clear separation between state files
- Clear separation between resources
- Code ambiguously shows deployment target

#### Cons

- Code duplication is high
- Need to create multiple directories
- Need to create multiple state files

#### Terragrunt

Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules. It is a wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.