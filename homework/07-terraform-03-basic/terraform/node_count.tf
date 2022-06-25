resource "yandex_compute_instance" "node_count" {
  count                     = "${terraform.workspace == "prod" ? 2 : 1}"
  name                      = "nodec0${count.index+1}-${terraform.workspace}"
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = "${terraform.workspace == "prod" ? 4 : 2}"
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.centos-7-base}"
      type     = "${terraform.workspace == "prod" ? "network-nvme" : "network-hdd"}"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}