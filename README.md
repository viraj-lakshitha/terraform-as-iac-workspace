# Getting started with terraform

> I've configure local cli to work with alias `tf` for `terraform` command.
> Also, configured aws profile as `personal-tf` for terraform to use.

1. Initialize the script with `terraform init`: It will download the provider plugin and initialize the working directory.
2. Plan the script with `terraform plan`: It will show the changes that will be applied.
3. Apply the script with `terraform apply`: It will apply the changes to the infrastructure.
4. Destroy the script with `terraform destroy`: It will destroy the infrastructure.

---

Documentations

- [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform](https://developer.hashicorp.com/terraform/docs)