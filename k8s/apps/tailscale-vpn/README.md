# Tailscale Subnet Router and Exit Node on K3s (Orange Pi)

This guide sets up [Tailscale](https://tailscale.com) as a Kubernetes Operator on a K3s cluster (e.g. Orange Pi), providing secure remote access to your **entire home network**. It uses OAuth credentials stored in a Kubernetes Secret and includes subnet routing and optional exit node functionality.

---

## ✅ Features

- Secure remote access to devices on your home LAN (`192.168.1.0/24`).
- Optional exit node support to route all internet traffic through your home.
- Uses Kubernetes Secrets for credential management.
- Isolated namespace (`network-services`) for better organization.
- All configuration managed through declarative YAML files.

---

## 1. Create Tailscale OAuth Client and ACL Tags

### 1.1 Edit ACL policy to add required tags

Visit: <https://login.tailscale.com/admin/acls> and include:

```json
"tagOwners": {
  "tag:k8s-operator": [],
  "tag:k8s": ["tag:k8s-operator"]
}
```

### 1.2 Create an OAuth client

Go to: <https://login.tailscale.com/admin/settings/oauth-clients> and create a client with:

- **Scopes**:
  - `devices:core` (write)
  - `auth_keys` (write)
- **Tags**: `tag:k8s-operator`

Save the `client_id` and `client_secret`.
You will use these values in `operator-oauth-secret.yaml` in the next step.

---

## 2. Apply the Kubernetes Secret for OAuth

Edit `operator-oauth-secret.yaml` and **replace** the placeholders with the values from step 1.2:

```yaml
stringData:
  client_id: tsclient-xxxxxxxxxxxxxxxx
  client_secret: tsclient-secret-xxxxxxxxxxxxxxxx
```

Then apply the secret:

```bash
kubectl apply -f operator-oauth-secret.yaml
```

Ensure the secret has the exact key names `client_id` and `client_secret`.

---

## 3. Install the Tailscale Operator with Helm

Use the existing `values.yaml` to set tags without including sensitive credentials:

```bash
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update

helm upgrade --install tailscale-operator tailscale/tailscale-operator \
  --namespace network-services \
  -f values.yaml \
  --wait
```

This uses the existing Secret (`operator-oauth`) and configures the operator properly.

---

## 4. Deploy the Connector

Apply the connector definition to announce your home subnet and enable exit node functionality:

```bash
kubectl apply -f connector.yaml
```

This allows Tailscale to route traffic to your LAN and optionally use it as an exit node.

---

## 5. Approve Subnet Routes and Exit Node

Go to <https://login.tailscale.com/admin/machines>, find your `orangepi` device, and enable:

- [x] **Subnet routes** (`192.168.1.0/24`)
- [x] **Exit node** (optional)

---

## 6. Connect from Other Devices

Install Tailscale on your iPad, laptop, or any other device:  
<https://tailscale.com/download>

Once connected, you can:

- SSH: `ssh user@192.168.1.X`
- Access Home Assistant, NAS, etc.
- Use your home IP for all internet traffic (if using exit node)

---

## Notes

- `.local` mDNS hostnames will not resolve over VPN; use IPs instead.
- For even easier access, install Tailscale directly on destination devices and use MagicDNS.
