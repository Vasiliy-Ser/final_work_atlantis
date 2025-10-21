variable "cloud_id" {
  description = "Cloud ID в Яндекс.Облаке"
  type        = string
}

variable "folder_id" {
  description = "Folder ID в Яндекс.Облаке"
  type        = string
}

variable "project_name" {
  description = "Project name (resource prefix)"
  type        = string
  default     = "project"
}



variable "enable_nat" {
  description = "Create NAT Gateway?"
  type        = bool
  default     = true
}

# variable "subnets" {
#   description = "List subnets (key = subnet name, value = { zone, cidr, public })"
#   type = map(object({
#     zone   = string
#     cidr   = string
#     public = bool
#   }))
# }

variable "subnets" {
  description = "Project subnets"
  type = map(object({
    zone   = string
    cidr   = string
    public = bool
  }))
  default = {
    private-a = {
      zone   = "ru-central1-a"
      cidr   = "10.10.1.0/24"
      public = false
  }
    public-c = {
      zone   = "ru-central1-a"
      cidr   = "10.10.10.0/24"
      public = true
  }
    private-b = {
      zone   = "ru-central1-b"
      cidr   = "10.10.2.0/24"
      public = false
  }
    private-d = {
      zone   = "ru-central1-d"
      cidr   = "10.10.3.0/24"
      public = false
  }
    private-e = {
      zone   = "ru-central1-a"
      cidr   = "10.10.4.0/24"
      public = false
  }
  }
}

# variable "image_id" {
#   type    = string
#   default = "fd80mrhj8fl2oe87o4e1"
# }

# Master config
variable "master_config" {
  type = object({
    platform_id        = string
    zone               = string
    cores              = number
    memory             = number
    disk_size          = number
    image_id           = string
    nat                = bool
    preemptible        = bool
    core_fraction      = number
    service_account_id = optional(string)
    metadata           = optional(map(string))
  })
  default = {
    platform_id   = "standard-v2"
    zone          = "ru-central1-a"
    cores         = 4
    memory        = 4
    disk_size     = 20
    image_id      = "fd84kp940dsrccckilj6"
    nat           = false
    preemptible   = false
    core_fraction = 20
  }
}

variable "master_subnet" {
  type    = string
  default = "private-a"
}

variable "bastion_config" {
  type = object({
    platform_id        = string
    zone               = string
    cores              = number
    memory             = number
    disk_size          = number
    image_id           = string
    nat                = bool
    preemptible        = bool
    core_fraction      = number
    service_account_id = optional(string)
    metadata           = optional(map(string))
  })
  default = {
    platform_id   = "standard-v2"
    zone          = "ru-central1-a"
    cores         = 2
    memory        = 2
    disk_size     = 10
    image_id      = "fd84kp940dsrccckilj6"
    nat           = true
    preemptible   = false
    core_fraction = 20
  }
}

variable "bastion_subnet" {
  type    = string
  default = "public-c"
}

variable "bastion_second_subnet" {
  type    = string
  default = "private-e"
}

# Worker config (basic template)
variable "worker_config" {
  type = object({
    platform_id        = string
    name               = string
    cores              = number
    memory             = number
    disk_size          = number
    image_id           = string
    nat                = bool
    preemptible        = bool
    core_fraction      = number
    service_account_id = optional(string)
    metadata           = optional(map(string))
  })
  default = {
    platform_id   = "standard-v2"
    name          = "worker"
    cores         = 4
    memory        = 4
    disk_size     = 20
    image_id      = "fd84kp940dsrccckilj6"
    nat           = false
    preemptible   = false
    core_fraction = 20
  }
}

#Number of workers = length of zone list
variable "worker_zones" {
  type    = list(string)
  default = ["ru-central1-b", "ru-central1-d"]
}

variable "worker_subnets" {
  type    = list(string)
  default = ["private-b", "private-d"]
}

variable "vms_ssh_root_key" {
  description = "List of SSH keys for VM root users"
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhtxtFIozHeOb0eySiG2+bVeA2sWrLkwJxRyrxgpA1H vm30@vm30"]
}


