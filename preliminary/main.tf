terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.146.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  service_account_key_file = file("~/.authorized_key.json")
}

# --- Service Account ---
resource "yandex_iam_service_account" "miracle" {
  name        = "miracle"
  description = "SA for Terraform (Object Storage + KMS)"
  folder_id   = var.folder_id
}

# --- KMS key ---
resource "yandex_kms_symmetric_key" "tfstate_key" {
  name              = "tfstate-kms-key"
  description       = "KMS key for Terraform state bucket encryption"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год
  folder_id         = var.folder_id
}

# --- Storage Bucket ---
resource "yandex_storage_bucket" "tfstate" {
  bucket = var.bucket_name
  # acl    = "private"

  # enable encryption via KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tfstate_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # enable versioning
  versioning {
    enabled = true
  }
}

# --- Permissions for SA on bucket ---
resource "yandex_storage_bucket_iam_binding" "sa-editor" {
  bucket = yandex_storage_bucket.tfstate.bucket
  role   = "storage.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.miracle.id}"
  ]
  depends_on = [
    yandex_iam_service_account.miracle,
    yandex_storage_bucket.tfstate
  ]
}

# static access key для Object Storage
resource "yandex_iam_service_account_static_access_key" "tf_key" {
  service_account_id = yandex_iam_service_account.miracle.id
  description        = "Static access key for Terraform state backend"
}



