variable "name" {
  description = "Project name"
  type        = string
}

variable "enable_nat" {
  description = "Create NAT Gateway and route table?"
  type        = bool
  default     = true
}

variable "subnets" {
  description = <<EOT
Subnet map:
  key = subnet name
  values = {
    zone   = zona (ru-central1-a/b/d)
    cidr   = CIDR block (e.g. 10.10.1.0/24)
    public = true/false
  }
EOT
  type = map(object({
    zone   = string
    cidr   = string
    public = bool
  }))
}