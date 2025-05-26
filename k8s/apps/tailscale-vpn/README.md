# Tailscale Subnet Router and Exit Node on K3s (Orange Pi)

This guide walks you through deploying [Tailscale](https://tailscale.com) as a Kubernetes Operator on your K3s cluster (e.g. Orange Pi) to access your **entire home network** remotely. It includes automatic OAuth authentication, subnet routing, and optional exit node capabilities.

---

## ✅ Features

- Secure remote access to devices in your home network (`192.168.1.0/24`).
- Optional exit node support to route **all internet traffic** via home.
- Headless OAuth authentication (no browser login needed).
- Uses `network-services` namespace for separation of concerns.
- Declarative deployment using Helm and Kubernetes manifests.

---

## 1. Create Tailscale OAuth Client and ACL Tags

### 1.1 Edit ACL policy to add required tags

Visit: <https://login.tailscale.com/admin/acls> and add:

```json
"tagOwners": {
  "tag:k8s-operator": [],
  "tag:k8s": ["tag:k8s-operator"]
}
```

### 1.2 Create an OAuth client

Go to: <https://login.tailscale.com/admin/settings/oauth-clients> and create a new client with:

- **Scopes**:
  - `devices:core` (write)
  - `auth_keys` (write)
- **Tags**: `tag:k8s-operator`

Save the `clientId` and `clientSecret` for use in the values file.

---

## 2. Install Tailscale Operator using Helm

Apply the existing `tailscale-values.yaml` file in this directory:

```bash
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update

helm install tailscale-operator tailscale/tailscale-operator \
  --namespace network-services \
  --create-namespace \
  -f values.yaml \
  --wait
```

---

## 3. Deploy Connector as Subnet Router and Exit Node

Apply the `connector.yaml` file in this directory:

```bash
kubectl apply -f connector.yaml
```

This connector:

- Advertises the local subnet (`192.168.1.0/24`)
- Acts as an exit node
- Is tagged as `tag:k8s` for ACL control

---

## 4. Approve Subnet Routes and Exit Node

1. Visit: <https://login.tailscale.com/admin/machines>
2. Locate the device `orangepi`
3. Enable:
   - **Subnet routes**
   - _(Optional)_ **Exit Node**

---

## 5. Connect from your devices

Install Tailscale on your other devices:

- <https://tailscale.com/download>

Once connected, you'll be able to:

- SSH: `ssh user@192.168.1.10`
- Access web UIs: `http://192.168.1.50:8123`
- _(If exit node is used)_ Browse the internet through your home.

---

## Notes

- No port forwarding or public IPs required.
- Private mesh network using WireGuard.
- Great for Home Assistant, media servers, SSH, and more.
