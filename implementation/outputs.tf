#####################################
# Master outputs
#####################################
output "master_private_ip" {
  value = module.vm-public.vm_ips_for_each["master"].private_ip
}

#####################################
# Bastion outputs
#####################################
output "bastion_private_ip" {
  value = module.vm-public.bastion_second_subnet["bastion"]
}

output "bastion_second_ip" {
  description = "IP адрес bastion в подсети MetalLB (второй интерфейс)"
  value       = module.vm-public.vm_ips_for_each["bastion"].private_ip
}

output "bastion_public_ip" {
  value = module.vm-public.vm_ips_for_each["bastion"].public_ip
}

#####################################
# Workers outputs
#####################################
output "workers_private_ips" {
  value = flatten([for w in module.workers : w.vm_ips_count])
}

#####################################
# Ansible inventory
#####################################
locals {
  all_workers_ips   = flatten([for w in module.workers : w.vm_ips_count])
  master_public_ip  = module.vm-public.vm_ips_for_each["master"].public_ip
  master_private_ip = module.vm-public.vm_ips_for_each["master"].private_ip
  bastion_public_ip   = module.vm-public.vm_ips_for_each["bastion"].public_ip
  bastion_private_ip  = module.vm-public.bastion_second_subnet["bastion"]
  bastion_second_ip  = module.vm-public.vm_ips_for_each["bastion"].private_ip


  ##################################################
  # inventory для Kubespray + kube-prometheus
  ##################################################
  kubespray_inventory = <<EOT
[all]
master ansible_host=${local.master_private_ip} ip=${local.master_private_ip} ansible_user=master ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q worker@${local.bastion_public_ip} -i ~/.ssh/id_ed25519"'

%{ for idx, ip in local.all_workers_ips ~}
worker-${idx + 1} ansible_host=${ip} ip=${ip} ansible_user=worker ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q worker@${local.bastion_public_ip} -i ~/.ssh/id_ed25519"'
%{ endfor ~}

[bastion]
bastion ansible_host=${local.bastion_public_ip} ansible_user=worker ansible_ssh_private_key_file=~/.ssh/id_ed25519

[metallb-access]
bastion-privat ansible_host=${local.bastion_private_ip} ansible_user=worker ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q worker@${local.bastion_public_ip} -i ~/.ssh/id_ed25519"'

[kube_control_plane]
master

[etcd]
master

[kube_node]
%{ for idx, ip in local.all_workers_ips ~}
worker-${idx + 1}
%{ endfor ~}

[metallb_speaker]
%{ for idx, ip in local.all_workers_ips ~}
worker-${idx + 1}
%{ endfor ~}

[k8s_cluster:children]
kube_control_plane
kube_node
EOT
}

#####################################
# Outputs
#####################################

output "kubespray_inventory" {
  value = local.kubespray_inventory
}

#####################################
# Write inventory file
#####################################
resource "local_file" "kubespray_inventory" {
  content  = local.kubespray_inventory
  filename = "../kubespray/hosts.yaml"
}

#####################################
# Installation instructions
#####################################
resource "local_file" "installation_instructions" {
  filename = "../kubespray/INSTRUCTIONS.md"
  content = <<-EOT
# 🚀 Instructions for deploying a Kubernetes cluster

## 📦 Created resources
- Service account: ${yandex_iam_service_account.k8s_ccm.name}
- Bastion: ${local.bastion_public_ip}
- Master: ${local.master_private_ip}
- Workers: ${join(", ", local.all_workers_ips)}
- MetalLB IP-пул: ${local.bastion_private_ip}/24

---

## 1️⃣ Connecting to bastion
```bash
ssh -i ~/.ssh/id_ed25519 worker@${local.bastion_public_ip}
EOT
}