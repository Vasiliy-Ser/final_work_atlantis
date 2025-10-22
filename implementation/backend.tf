terraform {

  backend "s3" {
    bucket   = var.bucket_name        # имя бакета для state
    key      = "terraform.tfstate"   # путь к state
    region   = var.region_s3
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    access_key        = var.access_key_s3
    secret_key        = var.secret_key_s3
    kms_master_key_id = var.kms_key_id
    sse_algorithm     = "aws:kms"
  }
}

  # backend "s3" {
  #   # shared_credentials_files = ["~/.aws/credentials"]
  #   endpoint   = "https://storage.yandexcloud.net"
  #   profile = "default"
  #   bucket     = "study.v3"      # bucket name from bootstrap.outputs
  #   key        = "instance"
  #   region     = "ru-central1"
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   skip_s3_checksum            = true
  # }
#}