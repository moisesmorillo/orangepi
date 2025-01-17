#!/bin/bash

KUBE_DIR="./kubernetes"

# Install k3s
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
# Alternatively, you can use the following command to install k3s without flannel CNI in case you want to use another
# CNI like calico
# curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - --flannel-backend none
# To uninstall k3s, run the following command
# sudo /usr/local/bin/k3s-uninstall.sh

find "$KUBE_DIR" -type f -name "*.yaml" | while read -r yaml; do
  echo "Applying $yaml"
  kubectl apply -f "$yaml"
done

echo "All yaml files applied"
