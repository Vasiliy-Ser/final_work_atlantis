# Create container registry
resource "yandex_container_registry" "my_registry" {
  name      = "my-app"
  folder_id = var.folder_id

  labels = {
    environment = "production"
    project     = "my-app"
  }
}

# Create service account for registry operations
resource "yandex_iam_service_account" "registry_miracle" {
  name        = "registry-miracle"
  description = "Service account for container registry operations"
  folder_id   = var.folder_id
}

# Create static access key for service account
resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.registry_miracle.id
  description        = "Static access key for container registry"
}

# IAM binding for registry
resource "yandex_container_registry_iam_binding" "pusher" {
  registry_id = yandex_container_registry.my_registry.id
  role        = "container-registry.images.pusher"
  
  members = [
    "serviceAccount:${yandex_iam_service_account.registry_miracle.id}",
  ]
}

resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = yandex_container_registry.my_registry.id
  role        = "container-registry.images.puller"
  
  members = [
    "serviceAccount:${yandex_iam_service_account.registry_miracle.id}",
  ]
}

