
( All files from this session is available here: https://github.com/itu-devops/itu-minitwit-terraform )

# Terraform

Terraform is an Infrastructure-as-Code tool from Hashicortp (who also makes vagrant). Terraform allows us to provision our entire cloud infrastructure, across multiple cloud providers, and keep the configuration as code!

Terraform main page
https://www.terraform.io/

Terraform documentation
https://www.terraform.io/docs/index.html

Terraform is open source!
https://github.com/hashicorp/terraform

## Terraform vs vagrant

```
"The primary usage of Terraform is for managing remote resources in cloud providers such as AWS. Terraform is
designed to be able to manage extremely large infrastructures that span multiple cloud providers. Vagrant is
designed primarily for local development environments that use only a handful of virtual machines at most."

Vagrant is for development environments. Terraform is for more general infrastructure management.
```
(Hashicorp: https://www.vagrantup.com/intro/vs/terraform.html)

## Declarative Cloud Environment

A terraform project consists of a number of `.tf` files, these contain the declarations of the infrastructure, as well some optional `.tfvars` files that contain key/value pairs.

Terraform uses the 'Hashicorp configuration language' to declare cloud environments, this means that we actually just telling terraform the end-result we want, and then it is up to terraform to provision the components that will create that end state.

Possible declarations include `resource`, `data`, `variable`, `module` and few more: https://www.terraform.io/docs/configuration/syntax.html

## Updating Environments

Since we provide terraform with a declaration of the state we want, we can modify the configuration for a running environment, and tell terraform to adapt our existing infrastructure to the new state!

## Using Terraform

All the following commands are contextual to the directory that contains the terraform files.

Initialize terraform for the current project
```bash
terraform init
```

Verify that the terraform files follow correct syntax
```bash
terraform validate
```

Preview the changes to made at next apply
```bash
terraform plan
```

Apply changes --> actually create the cloud environment
```bash
terraform apply
```

Destroy all of the infrastructure
```bash
terraform destroy
```
