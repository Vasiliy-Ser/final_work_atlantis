terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"  ### some test
}

# If use_for_each = true → create different VMs using for_each

resource "yandex_compute_instance" "vm" {
  for_each = var.instances

  name        = each.key
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = lookup(each.value, "core_fraction", 100)
  }

  boot_disk {
    initialize_params {
      image_id = each.value.image_id
      size     = each.value.disk_size
    }
  }

  network_interface {
    subnet_id = each.value.subnet_id
    nat       = lookup(each.value, "nat", false)
    security_group_ids = lookup(each.value, "security_groups", [])

    ip_address = lookup(each.value, "static_ip", null)  # null = динамический IP

  }

  # Additional network interfaces (only if specified)
  dynamic "network_interface" {
    for_each = lookup(each.value, "additional_network_interfaces", [])
    
    content {
      subnet_id = network_interface.value.subnet_id
      security_group_ids = lookup(network_interface.value, "security_group_ids", [])
      ip_address = lookup(network_interface.value, "ip_address", null)
      # nat is not available for additional interfaces in Yandex Cloud
    }
  }

  metadata = lookup(each.value, "metadata", {})

labels = merge(
  var.labels,
  { name = each.key }
)

  scheduling_policy {
    preemptible = lookup(each.value, "preemptible", false)
  }

  service_account_id = lookup(each.value, "service_account_id", null)
}
