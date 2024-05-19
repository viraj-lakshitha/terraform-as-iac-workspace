# Variables with Terraform

### Guide on how to use the variables in terraform code

- You need to create `terraform.tfvars` file in the same directory where you have the terraform script

- Then when you want to apply these changes run apply command with additional flag for the vars file. `terraform apply -var-file=terraform.tfvars`

- If you have secret (access key, secret key) then you can use then in runtime when your applying those change `terraform apply -var-file=terraform.tfvars -var="access_key=your_access_key" -var="secret_key=your_secret_key"`

- If you're passing the secret values like password with the apply command, then make sure to add the `sensitive = true` flag in variable definition file (ex: variables.tf) to avoid the values to be printed in the logs

```terraform
variable "rds_db_password" {
  description = "AWS RDS Password"
  type = string
  sensitive = true
}
```

- Also you can define the default values for the variables in the variables.tf file. But its optional to define the default values

```terraform
variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "ap-south-1"
}
```

> You can use github action secrets to pull-in the values and replace in the command or else AWS Secret Manager to pull-in the values