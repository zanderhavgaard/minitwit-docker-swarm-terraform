# create cloud vm
# resource "digitalocean_droplet" "minitwit-mysql" {
  # image = "docker-18-04"
  # name = "minitwit-mysql"
  # region = var.region
  # size = "1gb"
  # # add public ssh key so we can access the machine
  # ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]

  # # specify a ssh connection
  # connection {
    # user = "root"
    # host = self.ipv4_address
    # type = "ssh"
    # private_key = file(var.pvt_key)
    # timeout = "2m"
  # }

  # # scp file to server
  # provisioner "file" {
    # source = "docker-compose/minitwit-mysql-docker-compose.yml"
    # destination = "/root/docker-compose.yml"
  # }

  # # start docker-compose on the new server
  # provisioner "remote-exec" {
    # inline = [
      # "ufw allow 3306",
      # "docker-compose up -d --quiet-pull"
    # ]
  # }

# }

# # output ip address
# output "minitwit-mysql-ip-address" {
  # value = digitalocean_droplet.minitwit-mysql.ipv4_address
# }
