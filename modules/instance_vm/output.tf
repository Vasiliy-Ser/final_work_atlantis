output "vm_ips_for_each" {
  value = {
    for k, v in yandex_compute_instance.vm : k => {
      public_ip  = coalesce(v.network_interface.0.nat_ip_address, "no-public-ip")
      private_ip = v.network_interface.0.ip_address
    }
  }
}

output "bastion_second_subnet" {
  value = {
    for k, vm in yandex_compute_instance.vm : k => 
      length(vm.network_interface) > 1 ? vm.network_interface[1].ip_address : null
    if length(vm.network_interface) > 1
  }
}
