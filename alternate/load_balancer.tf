# create loadbalancer
# resource "digitalocean_loadbalancer" "minitwit-loadbalancer" {
  # name = "minitwit-loadbalancer"
  # region = var.region

  # forwarding_rule {
    # entry_port = 80
    # entry_protocol = "http"

    # target_port = 5000
    # target_protocol = "http"
  # }

  # healthcheck {
    # port = 22
    # protocol = "tcp"
  # }

  # # concatenate droplet ids to a list
  # droplet_ids = concat(digitalocean_droplet.minitwit-app.*.id)
# }

# # output loadbalancer ip address
# output "loadbalancer_ip" {
  # value = digitalocean_loadbalancer.minitwit-loadbalancer.ip
# }
