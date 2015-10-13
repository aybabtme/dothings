provider "digitalocean" {}

resource "template_file" "cloud-config" {
    filename = "cloud-config.tpl"
    vars {
        discovery_url = "${var.discovery_url}"
    }
}

resource "digitalocean_droplet" "core_leader" {
    count = "${var.leader_count}"

    image              = "coreos-stable"
    name               = "leader${count.index}.core"
    region             = "${var.region}"
    size               = "${var.leader_size}"
    ssh_keys           = ["${split(",", var.ssh_keys)}"]
    user_data          = "${template_file.cloud-config.rendered}"
    private_networking = true

    connection { user = "core" }
    provisioner "remote-exec" {
        script = "wait_etcd_healthy.sh"
    }
}

resource "digitalocean_droplet" "core_follower" {
    count = "${var.follower_count}"

    depends_on = ["digitalocean_droplet.core_leader"]

    image              = "coreos-stable"
    name               = "follower${count.index}.core"
    region             = "${var.region}"
    size               = "${var.follower_size}"
    ssh_keys           = ["${split(",", var.ssh_keys)}"]
    user_data          = "${template_file.cloud-config.rendered}"
    private_networking = true

    connection { user = "core" }
    provisioner "remote-exec" {
        script = "wait_etcd_healthy.sh"
    }
}
