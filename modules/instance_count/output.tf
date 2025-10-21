output "vm_ips_count" {
  value = [for inst in yandex_compute_instance.vm_count : inst.network_interface.0.ip_address]
}

