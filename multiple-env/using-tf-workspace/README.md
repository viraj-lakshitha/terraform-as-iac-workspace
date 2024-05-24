# Multiple Environment with Workspaces

1. Create environment

```bash
terraform workspace new dev
terraform workspace new prod
```

2. List existing workspaces

```bash
terraform workspace list
```

3. Switch between workspaces

```bash
terraform workspace select dev
terraform workspace select prod
```