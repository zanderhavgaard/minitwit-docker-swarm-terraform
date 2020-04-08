# api token
# here it is exported in the environment like
# export TF_VAR_do_token=xxx
variable "do_token" {}

# do region
variable "region" {}

# make sure to generate a pair of ssh keys
variable "pub_key" {}
variable "pvt_key" {}

# setup the provider
provider "digitalocean" {
  token = var.do_token
  version = "1.14"
}

# add the ssh key
resource "digitalocean_ssh_key" "minitwit" {
  name = "minitwit"
  public_key = file(var.pub_key)
}
