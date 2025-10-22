resource "data.yandex_vpc_security_group" "default" {
  name        = "${var.name}-default-sg"
  description = "Default security group for project"
  network_id  = data.yandex_vpc_network.project.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "etcd"
    protocol       = "TCP"
    port           = 2379
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "etcd"
    protocol       = "TCP"
    port           = 2380
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Grafana"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Atlantis"
    protocol       = "TCP"
    port           = 4141
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Grafana_ext"
    protocol       = "TCP"
    port           = 8300
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Prometheus_ext"
    protocol       = "TCP"
    port           = 8909
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Alertmanager"
    protocol       = "TCP"
    port           = 9093
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Alertmanager_ext"
    protocol       = "TCP"
    port           = 8903
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Kubelet API"
    protocol       = "TCP"
    port           = 10250
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }

    ingress {
    description    = "Kubelet API"
    protocol       = "TCP"
    port           = 10255
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }

    ingress {
    description    = "kube-scheduler"
    protocol       = "TCP"
    port           = 10259
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }

    ingress {
    description    = "kube-controller-manager"
    protocol       = "TCP"
    port           = 10257
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "Kubernetes Dashboard"
    protocol       = "TCP"
    port           = 8443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description    = "NodePort "
    protocol       = "TCP"
    from_port   = 30000
    to_port     = 32767
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "UDP"
    description    = "Flannel VXLAN"
    port           = 8472
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Calico BGP"
    port           = 179
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.10.0/24"]
  }

    ingress {
    protocol       = "ANY"
    description    = "Internal cluster communication"
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }

    ingress {
    protocol       = "ANY"
    description    = "metallb"
    v4_cidr_blocks = ["10.10.10.0/24"]
  }

  egress {
    description    = "Allow all outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  description     = "NodePort range"
  protocol        = "TCP"
  from_port       = 30000
  to_port         = 32767
  v4_cidr_blocks  = ["0.0.0.0/0"]
}

# Grafana
ingress {
  description     = "Grafana access"
  protocol        = "TCP"
  from_port       = 3000
  to_port         = 3000
  v4_cidr_blocks  = ["10.10.4.0/24"]  # bastion subnet
}

# Grafana external (если используем порт 8300)
ingress {
  description     = "Grafana external"
  protocol        = "TCP"
  from_port       = 8300
  to_port         = 8300
  v4_cidr_blocks  = ["10.10.4.0/24"]
}

# Prometheus
ingress {
  description     = "Prometheus external"
  protocol        = "TCP"
  from_port       = 9090
  to_port         = 9090
  v4_cidr_blocks  = ["10.10.4.0/24"]
}

ingress {
  description     = "Prometheus external port 8909"
  protocol        = "TCP"
  from_port       = 8909
  to_port         = 8909
  v4_cidr_blocks  = ["10.10.4.0/24"]
}

# Alertmanager
ingress {
  description     = "Alertmanager"
  protocol        = "TCP"
  from_port       = 9093
  to_port         = 9093
  v4_cidr_blocks  = ["10.10.4.0/24"]
}

ingress {
  description     = "Alertmanager external port 8903"
  protocol        = "TCP"
  from_port       = 8903
  to_port         = 8903
  v4_cidr_blocks  = ["10.10.4.0/24"]
}

}