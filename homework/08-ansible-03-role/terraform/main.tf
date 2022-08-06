resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
      name     = "root-node01"
      type     = "network-nvme"
      size     = "25"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node02" {
  name                      = "node02"
  zone                      = "ru-central1-a"
  hostname                  = "node02.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "root-node02"
      type     = "network-nvme"
      size     = "25"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node03" {
  name                      = "node03"
  zone                      = "ru-central1-a"
  hostname                  = "node03.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
      name     = "root-node03"
      type     = "network-nvme"
      size     = "25"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

#resource "yandex_compute_instance" "nat" {
#  name                      = "nat"
#  zone                      = "ru-central1-a"
#  hostname                  = "nat.netology.cloud"
#  allow_stopping_for_update = true
#
#  resources {
#    cores  = 2
#    memory = 2
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = "fd8phfma88csn6br814r"
#      name     = "root-nat"
#      type     = "network-nvme"
#      size     = "25"
#    }
#  }
#
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-1.id
#    nat       = true
#  }
#
#  metadata = {
#    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#  }
#}
