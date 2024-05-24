# Terraform Modules

#### Types of modules

1. Root modules - Default modules containing  all the .tf files in main working directory
2. Child modules - A separate external modules referred from a .tf file.

#### Module Sources

- Terraform Registry: Terraform Registry is a public repository of modules that are available for use in your Terraform configurations. You can find modules for a wide range of common infrastructure patterns and services, and you can publish your own modules to share your infrastructure code with the community.

```terraform
module "web-app" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.0.0"
}
```

- Git repositories: You can use modules from any public or private Git repository. This is useful if you want to use a module that isn't available in the Terraform Registry, or if you want to use a fork of an existing module.

```terraform
# GENERIC
module "web-app" {
  source = "github.com/viraj-lakshitha/tf-module.git?ref=v1.2.0"
}

# HTTP
module "web-app" {
  source = "git@github.com:viraj-lakshitha/tf-module.git"
}

# SSH
module "web-app" {
  source = "git::ssh://viraj-lakshitha@github.com/tf-module.git"
}
```

- Local filesystem: You can use modules from a local filesystem, which is useful for developing modules or using modules that aren't intended for reuse.

```terraform
module "web-app" {
  source = "./modules/web-app"
}
```

- Storage Buckets (S3/GCS Buckets): You can use modules from a storage bucket in an object storage service like Amazon S3 or Google Cloud Storage. This is useful for sharing modules within an organization or across multiple Terraform configurations.

```terraform
module "web-app" {
  source = "s3::https://s3.amazonaws.com/my-bucket/modules/web-app"
}
```

- HTTP Urls: You can use modules from an HTTP URL, which is useful for using modules that are hosted on a web server or other HTTP service.

```terraform
module "web-app" {
  source = "http://example.com/modules/web-app"
}
```