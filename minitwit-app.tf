


                     # _
 # _ __ ___   __ _ ___| |_ ___ _ __
# | '_ ` _ \ / _` / __| __/ _ \ '__|
# | | | | | | (_| \__ \ ||  __/ |
# |_| |_| |_|\__,_|___/\__\___|_|

# create cloud vm
resource "digitalocean_droplet" "minitwit-swarm-master" {
  # wait for mysql db to be created so we can grab the ip address
  # TODO uncomment
  # depends_on = [digitalocean_droplet.minitwit-mysql]

  image = "docker-18-04"
  name = "minitwit-swarm-master"
  region = var.region
  size = "1gb"
  # add public ssh key so we can access the machine
  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]

  # specify a ssh connection
  connection {
    user = "root"
    host = self.ipv4_address
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  # provisioner "file" {
    # source = "docker-compose/minitwit-app-docker-compose.yml"
    # destination = "/root/docker-compose.yml"
  # }

  provisioner "remote-exec" {
    inline = [
      # allow poers for docker swarm
      "ufw allow 2377/tcp",
      "ufw allow 7946",
      "ufw allow 4789/udp",

      # initialize docker swarm cluster
      "docker swarm init --advertise-addr ${self.ipv4_address}"
    ]
  }

  # save the worker join token
  provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' root@${self.ipv4_address} -i ssh_key/terraform_key 'docker swarm join-token worker -q' > worker_token"
  }

  # save the manager join token
  provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' root@${self.ipv4_address} -i ssh_key/terraform_key 'docker swarm join-token manager -q' > manager_token"
  }
}


 # _ __ ___   __ _ _ __   __ _  __ _  ___ _ __
# | '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
# | | | | | | (_| | | | | (_| | (_| |  __/ |
# |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|
                             # |___/

# create cloud vm
resource "digitalocean_droplet" "minitwit-swarm-manager" {
  # wait for mysql db to be created so we can grab the ip address
  # TODO uncomment
  # depends_on = [digitalocean_droplet.minitwit-mysql]
  depends_on = [digitalocean_droplet.minitwit-swarm-master]

  # number of vms to create
  count = 2

  image = "docker-18-04"
  name = "minitwit-swarm-manager-${count.index}"
  region = var.region
  size = "1gb"
  # add public ssh key so we can access the machine
  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]

  # specify a ssh connection
  connection {
    user = "root"
    host = self.ipv4_address
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "file" {
    source = "manager_token"
    destination = "/root/manager_token"
  }

  provisioner "remote-exec" {
    inline = [
      # allow poers for docker swarm
      "ufw allow 2377/tcp",
      "ufw allow 7946",
      "ufw allow 4789/udp",

      # join swarm cluster as managers
      "docker swarm join --token $(cat manager_token) ${digitalocean_droplet.minitwit-swarm-master.ipv4_address}"
    ]
  }
}


                    # _
# __      _____  _ __| | _____ _ __
# \ \ /\ / / _ \| '__| |/ / _ \ '__|
 # \ V  V / (_) | |  |   <  __/ |
  # \_/\_/ \___/|_|  |_|\_\___|_|

# create cloud vm
resource "digitalocean_droplet" "minitwit-swarm-worker" {
  # wait for mysql db to be created so we can grab the ip address
  # TODO uncomment
  # depends_on = [digitalocean_droplet.minitwit-mysql]
  depends_on = [digitalocean_droplet.minitwit-swarm-master]

  # number of vms to create
  count = 5

  image = "docker-18-04"
  name = "minitwit-swarm-worker-${count.index}"
  region = var.region
  size = "1gb"
  # add public ssh key so we can access the machine
  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]

  # specify a ssh connection
  connection {
    user = "root"
    host = self.ipv4_address
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "file" {
    source = "worker_token"
    destination = "/root/worker_token"
  }

  provisioner "remote-exec" {
    inline = [
      # allow poers for docker swarm
      "ufw allow 2377/tcp",
      "ufw allow 7946",
      "ufw allow 4789/udp",

      # join swarm cluster as workers
      "docker swarm join --token $(cat worker_token) ${digitalocean_droplet.minitwit-swarm-master.ipv4_address}"
    ]
  }
}


output "minitwit-swarm-master-ip-address" {
  value = digitalocean_droplet.minitwit-swarm-master.ipv4_address
}

output "minitwit-swarm-manager-ip-address" {
  value = digitalocean_droplet.minitwit-swarm-manager.*.ipv4_address
}

output "minitwit-swarm-worker-ip-address" {
  value = digitalocean_droplet.minitwit-swarm-worker.*.ipv4_address
}
