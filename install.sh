#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  curl git vim

KUBE_DIR="./kubernetes"

# Install k3s
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh - --disable=traefik

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

find "$KUBE_DIR" -type f -name "*.yaml" | while read -r yaml; do
  echo "Applying $yaml"
  kubectl apply -f "$yaml"
done

echo "Orange Pi 5 Kubernetes Cluster Installed!"
