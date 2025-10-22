# # Creating a variable file for Kubespray
# resource "local_file" "kubespray_extra_vars" {
#   filename = "../kubespray/extra-vars.yaml"
#   content = yamlencode({
#     cloud_provider          = "external"
#     external_cloud_provider = "manual"
#     kubeadm_enabled         = true
#   })
# }

# # Creating a ccm_secret file for Kubespray
# resource "local_file" "ccm_secret" {
# #  filename = "${path.module}/ccm-secret.yaml"
#   filename = "../kubespray/ccm-secret.yaml"
#   content = <<-EOT
# apiVersion: v1
# kind: Secret
# metadata:
#   name: yandex-cloud-credentials
#   namespace: kube-system
# type: Opaque
# data:
#   sa-key.json: ${base64encode(yandex_iam_service_account_key.ccm_key.private_key)}
# EOT
# }

# # Create service account for loadbalancer

# resource "yandex_iam_service_account" "k8s_ccm" {
#   name        = "k8s-ccm"
#   description = "Service account for Kubernetes Cloud Controller Manager"
# }

# resource "yandex_resourcemanager_folder_iam_member" "ccm_roles" {
#   for_each = toset([
#     "load-balancer.privateAdmin",
#     "vpc.publicAdmin",
#     "compute.images.user",
#     "iam.serviceAccounts.user",
#     "container-registry.images.pusher",
#     "container-registry.images.puller"
#   ])
  
#   folder_id = var.folder_id
#   role      = each.key
#   member    = "serviceAccount:${yandex_iam_service_account.k8s_ccm.id}"
# }

# # Create static access key for service account
# resource "yandex_iam_service_account_key" "ccm_key" {
#   service_account_id = yandex_iam_service_account.k8s_ccm.id
#   description        = "Key for K8s CCM"
# }

# resource "local_file" "ccm_private_key" {
# #  filename = "${path.module}/ccm-private-key.json"
#   filename = "../kubespray/ccm-private-key.json"
#   content  = yandex_iam_service_account_key.ccm_key.private_key
#   file_permission = "0600"
# }