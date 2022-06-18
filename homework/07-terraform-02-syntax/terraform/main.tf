provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1grcpn8qi84n3n3a607"
  folder_id                = "b1gbgo924r85q278bg78"
}

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
      image_id = "fd8hhviq3fc98mb1edt9"
      name     = "root-node01"
      type     = "network-nvme"
      size     = "50"
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

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.node01.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.node01.network_interface.0.nat_ip_address
}