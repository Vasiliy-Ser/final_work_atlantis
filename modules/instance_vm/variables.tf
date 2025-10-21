variable "use_for_each" {
  description = "Should I use for_each to create a VM?"
  type        = bool
  default     = true
}

variable "instances" {
  description = <<EOT
VM Map, where key = VM name and value = parameters object:
{
  platform_id        = string
  zone               = string
  cores              = number
  memory             = number
  core_fraction      = optional(number, 100)
  preemptible        = optional(bool, false)
  disk_size          = number
  image_id           = string
  subnet_id          = string
  static_ip          = optional(string)
  nat                = optional(bool, false)
  security_groups    = optional(list(string), [])
  service_account_id = optional(string)
  metadata           = optional(map(string), {})
  secondary_nic_subnet_id = optional(string)
}
EOT
  type = map(object({
    platform_id        = string
    zone               = string
    cores              = number
    memory             = number
    core_fraction      = optional(number)
    preemptible        = optional(bool)
    disk_size          = number
    image_id           = string
    subnet_id          = string
    static_ip          = optional(string)
    nat                = optional(bool)
    security_groups    = optional(list(string))
    service_account_id = optional(string)
    metadata           = optional(map(string))
     # New parameters for additional network interfaces
    additional_network_interfaces = optional(list(object({
      subnet_id          = string
      security_group_ids = optional(list(string), [])
      ip_address         = optional(string)
    })), [])
  }))
  default = {}
}

variable "labels" {
  description = "Additional tags for VM"
  type        = map(string)
  default     = {}
}

