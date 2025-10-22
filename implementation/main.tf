module "network" {
  source     = "../modules/vpc"
  name       = var.project_name
  enable_nat = var.enable_nat
  subnets    = var.subnets
}

# -------------------------
# Master VM (alone in a public area)
# -------------------------

module "vm-public" {
  source       = "../modules/instance_vm"
  use_for_each = true
  
  instances = {
    master = {
      platform_id        = var.master_config.platform_id
      zone               = var.master_config.zone
      cores              = var.master_config.cores
      memory             = var.master_config.memory
      disk_size          = var.master_config.disk_size
      image_id           = var.master_config.image_id
      nat                = var.master_config.nat
      preemptible        = var.master_config.preemptible
      core_fraction      = var.master_config.core_fraction
      service_account_id = try(var.master_config.service_account_id, null)
      metadata           = try(var.master_config.metadata, {})
      subnet_id          = module.network.subnet_ids[var.master_subnet]
      static_ip          = "10.10.1.50"
      security_groups    = [module.network.security_group_id]
      metadata = {
        user-data          = data.template_file.cloudinit-m.rendered 
        serial-port-enable = 1
      }

      labels = {
        role    = "master"
        project = var.project_name
      }
    }

  bastion = {
      platform_id        = var.bastion_config.platform_id
      zone               = var.bastion_config.zone
      cores              = var.bastion_config.cores
      memory             = var.bastion_config.memory
      disk_size          = var.bastion_config.disk_size
      image_id           = var.bastion_config.image_id
      nat                = var.bastion_config.nat
      preemptible        = var.bastion_config.preemptible
      core_fraction      = var.bastion_config.core_fraction
      service_account_id = try(var.bastion_config.service_account_id, null)
      metadata           = try(var.bastion_config.metadata, {})
      subnet_id          = module.network.subnet_ids[var.bastion_subnet]
      security_groups    = [module.network.security_group_id]
        # Добавляем второй сетевой интерфейс
      additional_network_interfaces = [
        {
          subnet_id          = module.network.subnet_ids[var.bastion_second_subnet]
          security_group_ids = [module.network.security_group_id]
        }
      ]
      metadata = {
        user-data          = data.template_file.cloudinit-b.rendered 
        serial-port-enable = 1
      }

      labels = {
        role    = "bastion"
        project = var.project_name
      }
    }
  }
}

# -------------------------
# Workers (count + zones from the list)
# -------------------------
module "workers" {
  source       = "../modules/instance_count"
  #use_for_each = false

  count = length(var.worker_zones)  # count.index is now available

  #instance_count     = length(var.worker_zones)
  instance_count     = 1
  #vm_name            = "worker"
  vm_name = format("worker-%02d", count.index + 1)
  platform_id        = var.worker_config.platform_id
  zone               = var.worker_zones[count.index]
  cores              = var.worker_config.cores
  memory             = var.worker_config.memory
  disk_size          = var.worker_config.disk_size
  image_id           = var.worker_config.image_id
  nat                = var.worker_config.nat
  preemptible        = var.worker_config.preemptible
  core_fraction      = var.worker_config.core_fraction
  subnet_id          = module.network.subnet_ids[var.worker_subnets[count.index]]
  security_group_ids = [module.network.security_group_id]
  
  metadata = {
    user-data          = data.template_file.cloudinit-w.rendered 
    serial-port-enable = 1
  }

  labels = {
    role    = "worker"
    project = var.project_name
  }
}

data "template_file" "cloudinit-m" {
  template = file("${path.module}/cloud-init-m.yml")

  vars = {
    vms_ssh_root_key = join("\n", var.vms_ssh_root_key)
  }
}

data "template_file" "cloudinit-w" {
  template = file("${path.module}/cloud-init-w.yml")

  vars = {
    vms_ssh_root_key = join("\n", var.vms_ssh_root_key)
  }
}

data "template_file" "cloudinit-b" {
  template = file("${path.module}/cloud-init-b.yml")

  vars = {
    vms_ssh_root_key = join("\n", var.vms_ssh_root_key)
    master_ip        = "10.10.1.50"
  }
}

