output "service_account_id" {
  value = yandex_iam_service_account.miracle.id
}

# output "access_key" {
#   value = yandex_iam_service_account_api_key.tf_key.id
# }

# # output "private_key" {
# #   value     = yandex_iam_service_account_api_key.tf_key.secret
# #   sensitive = true
# # }

output "bucket_name" {
  value = yandex_storage_bucket.tfstate.bucket
}

# # output "api_key_id" {
# #   value = yandex_iam_service_account_api_key.tf_key.id
# # }

output "access_key" {
  value = yandex_iam_service_account_static_access_key.tf_key.access_key
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.tf_key.secret_key
  sensitive = true
}





# output "service_account_id" {
#   description = "ID of the created service account"
#   value       = yandex_iam_service_account.tf.id
# }

# output "service_account_name" {
#   description = "Service account name"
#   value       = yandex_iam_service_account.tf.name
# }

# output "sa_static_access_key_id" {
#   description = "Static Access Key ID для S3 backend"
#   value       = yandex_iam_service_account_static_access_key.tf_key.access_key
#   sensitive   = true
# }

# output "sa_static_secret_key" {
#   description = "Static Secret Key для S3 backend"
#   value       = yandex_iam_service_account_static_access_key.tf_key.secret_key
#   sensitive   = true
# }

# output "kms_key_id" {
#   description = "The ID of the KMS key used to encrypt the bucket"
#   value       = yandex_kms_symmetric_key.tfstate_key.id
# }

# output "kms_key_name" {
#   description = "KMS key name"
#   value       = yandex_kms_symmetric_key.tfstate_key.name
# }

# output "bucket_name" {
#   description = "The name of the bucket for storing Terraform state"
#   value       = yandex_storage_bucket.tfstate.bucket
# }

# output "bucket_domain_name" {
#   description = "Bucket domain name"
#   value       = yandex_storage_bucket.tfstate.bucket_domain_name
# }




# Outputs
# output "bucket_domain_name" {
#   value = yandex_storage_bucket.tfstate.bucket_domain_name
# }

# output "kms_key_id" {
#   value = yandex_kms_symmetric_key.tfstate_key.id
# }

# output "static_access_key" {
#   value     = yandex_iam_service_account_static_access_key.tf_key.access_key
#   sensitive = true
# }

# output "static_secret_key" {
#   value     = yandex_iam_service_account_static_access_key.tf_key.secret_key
#   sensitive = true
# }
