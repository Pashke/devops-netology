variable "yandex_cloud_id" {
  default = "b1grcpn8qi84n3n3a607"
}

variable "yandex_folder_id" {
  default = "b1gbgo924r85q278bg78"
}

variable "centos-7-base" {
  default = "fd8hqa9gq1d59afqonsf"
}

variable "nodes" {
  default = {
    prod = {
      node01 = {
        cores = 4
        memory = 4
        type_disk = "network-nvme"
      }
      node02 = {
        cores = 4
        memory = 4
        type_disk = "network-nvme"
      }
    }
    stage = {
      node01 = {
        cores = 2
        memory = 4
        type_disk = "network-hdd"
      }
    }
  }
}