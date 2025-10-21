# For count
variable "instance_count" {
  description = "Number of identical VMs (if use_for_each = false)"
  type        = number
#  default     = 0
}

variable "vm_name" {
  description = "Base VM name (for count)"
  type        = string
  default     = "vm"
}

variable "platform_id" {
  description = "Platform type (for count)"
  type        = string
#  default     = "standard-v3"
}

variable "zone" {
  description = "Zone (for count)"
  type        = string
#  default     = "ru-central1-a"
}

variable "cores" {
  type    = number
 # default = 2
}

variable "memory" {
  type    = number
#  default = 2
}

variable "core_fraction" {
  type    = number
#  default = 100
}

variable "preemptible" {
  type    = bool
#  default = false
}

variable "disk_size" {
  type    = number
#  default = 20
}

variable "image_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nat" {
  type    = bool
  default = false
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "service_account_id" {
  type    = string
  default = null
}

variable "metadata" {
  type    = map(string)
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}