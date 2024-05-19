# Remote backend

1. Default to local
2. Terraform Cloud

> If you want to run in local and only keep the state in terraform cloud then, select `local` in workspace settings

```terraform
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "your-organization"

    workspaces {
      name = "your-workspace"
    }
  }
}
```

3. AWS S3 and DynamoDB

```terraform
terraform {
  backend "s3" {
    bucket         = "vitiya99-poc-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "vitiya99-poc-tf-lock"
    encrypt        = true
  }
}
```
