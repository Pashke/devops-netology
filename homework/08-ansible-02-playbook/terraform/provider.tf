# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1grcpn8qi84n3n3a607"
  folder_id                = "b1gbgo924r85q278bg78"
}