# Multiple environment with multiple folders

1. Create folders for each environment - `mkdir dev` or `mkdir prod`
2. Create a `main.tf` file in each folder
3. Initialize the folder with `terraform init`

So, In this method, you don't need to have conditional operators or any other logic to manage multiple environments. You can simply create a folder for each environment and manage the resources separately.