terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"  ### some test
}

#If use_for_each = false → we create identical VMs using count
resource "yandex_compute_instance" "vm_count" {
  #count              = var.use_for_each ? 0 : var.instance_count
  count              = var.instance_count

  name               = "${var.vm_name}-${count.index + 1}"
  platform_id        = var.platform_id
  zone               = var.zone
  service_account_id = var.service_account_id

  resources {
    core_fraction = var.core_fraction
    cores         = var.cores
    memory        = var.memory
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id           = var.subnet_id
    nat                 = var.nat
    security_group_ids  = var.security_group_ids
  }

  metadata = var.metadata

  labels = merge(
    var.labels,
    { name = "${var.vm_name}-${count.index + 1}" }
  )
}