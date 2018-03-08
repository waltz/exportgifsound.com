variable "digitalocean_token" {}

output "staging-ip" {
  value = "${digitalocean_droplet.staging.ipv4_address}"
}

output "production-ip" {
  value = "${digitalocean_droplet.production.ipv4_address}"
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "default"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "staging" {
  image = "ubuntu-16-04-x64"
  name = "imploder-staging"
  region = "nyc3"
  size = "1gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yes | apt-get install python"
    ]
  }
}

resource "digitalocean_droplet" "production" {
  image = "ubuntu-16-04-x64"
  name = "imploder-production"
  region = "nyc3"
  size = "1gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yes | apt-get install python"
    ]
  }
}
