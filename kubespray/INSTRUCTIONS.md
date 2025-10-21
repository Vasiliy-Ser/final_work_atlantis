# 🚀 Instructions for deploying a Kubernetes cluster

## 📦 Created resources
- Service account: k8s-ccm
- Bastion: 84.252.128.120
- Master: 10.10.1.50
- Workers: 10.10.2.29, 10.10.3.28
- MetalLB IP-пул: 10.10.4.7/24

---

## 1️⃣ Connecting to bastion
```bash
ssh -i ~/.ssh/id_ed25519 worker@84.252.128.120
