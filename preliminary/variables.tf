variable "cloud_id" { type = string }
variable "folder_id" { type = string }
variable "zone" { 
  type = string
  default = "ru-central1-a"
}
variable "bucket_name" { type = string }

variable "sa_key_file" {
  type        = string
  description = "Path to service account JSON key file"
  default     = "~/.authorized_key.json"
}

variable "sa_name" {
  type        = string
  default     = "miracle"
}

variable "sa_description" {
  type        = string
  default     = "SA for Terraform (Object Storage)"
}

variable "sa_static_key_description" {
  type        = string
  default     = "Static access key for Terraform state backend"
}

variable "kms_key_name" {
  type        = string
  default     = "tfstate-kms-key"
}

variable "kms_key_description" {
  type        = string
  default     = "KMS key for Terraform state bucket encryption"
}

variable "kms_algorithm" {
  type        = string
  default     = "AES_256"
}

variable "kms_rotation" {
  type        = string
  default     = "8760h" # 1 год
}

# variable "bucket_name" {
#   type        = string
#   description = "Name of the storage bucket for tfstate"
# }

variable "bucket_acl" {
  type        = string
  default     = "private"
}

variable "bucket_versioning" {
  type        = bool
  default     = true
}

variable "bucket_role" {
  type        = string
  default     = "storage.editor"
}

