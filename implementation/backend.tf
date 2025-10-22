terraform {

  backend "s3" {
    bucket        = "study.v3"       
    key           = "terraform.tfstate"   
    key           = "instance"
    region        = "ru-central1"
    #access_key    = ""
    #secret_key    = ""
    # kms_master_key_id = ""
    # sse_algorithm     = "aws:kms"

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
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