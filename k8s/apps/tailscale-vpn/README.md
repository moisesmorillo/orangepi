# Tailscale Subnet Router on K3s (Orange Pi) with OAuth Auth

<!--toc:start-->

- [Tailscale Subnet Router on K3s (Orange Pi) with OAuth Auth](#tailscale-subnet-router-on-k3s-orange-pi-with-oauth-auth)
  - [✅ Features](#features)
  - [1. Create an OAuth Client on Tailscale](#1-create-an-oauth-client-on-tailscale)
  - [2. Add the Tailscale Helm repository](#3-add-the-tailscale-helm-repository)
  - [3. Install Tailscale into the `network-services` namespace](#4-install-tailscale-into-the-network-services-namespace)
  - [4. Verify deployment](#5-verify-deployment)
  - [5. Approve the Subnet Router in the Tailscale Admin Console](#6-approve-the-subnet-router-in-the-tailscale-admin-console)
  - [6. Connect from your devices](#7-connect-from-your-devices)
  - [Notes](#notes)
  <!--toc:end-->

This guide explains how to install [Tailscale](https://tailscale.com) on a K3s cluster (e.g., running on an Orange Pi) using the Helm operator and configure it as a **subnet router** to access your **entire home network (e.g., 192.168.1.0/24)** from any device connected to Tailscale.

## ✅ Features

- Secure remote access to your home network (SSH, Mosh, dashboards, etc.).
- Zero ports exposed to the internet.
- OAuth-based headless authentication (no manual login).
- Isolated namespace (`network-services`).
- Works great with K3s on ARM devices.

---

## 1. Create an OAuth Client on Tailscale

1. Visit: [Tailscale Console Auth Keys](https://login.tailscale.com/admin/settings/auth-keys)
2. Click **"Create OAuth client"**
3. Copy the generated:
   - `Client ID` (e.g., `tsclient-xxxx`)
   - `Client Secret` (e.g., `tsclient-secret-xxxx`)

---

## 2. Add the Tailscale Helm repository

```bash
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update
```

---

## 3. Install Tailscale into the `network-services` namespace

```bash
helm install tailscale-operator tailscale/tailscale-operator \
  -n network-services \
  --create-namespace \
  -f values.yaml
```

---

## 4. Verify deployment

```bash
kubectl get pods -n network-services
```

You should see a pod named like:

```
tailscale-connector-orangepi-subnet-router-xxxxx
```

---

## 5. Approve the Subnet Router in the Tailscale Admin Console

1. Go to [Tailscale Console Machines](https://login.tailscale.com/admin/machines)
2. Find the node named `orangepi`
3. Click it and:
   - Enable **"Subnet routes"**
   - _(Optional)_ Enable **"Exit Node"** if you want to route **all traffic** through your home network

---

## 6. Connect from your devices

Install Tailscale on your laptop, iPad, or any other device:

- [https://tailscale.com/download](https://tailscale.com/download)

Once connected, you can access devices/services on your home LAN:

- SSH: `ssh user@192.168.1.10`
- Web UI: `http://192.168.1.50:8123`

---

## Notes

- No need to expose ports on your router.
- Low latency thanks to Tailscale’s peer-to-peer WireGuard-based mesh.
- Ideal for homelabs, remote SSH, RDP, web apps, and more.

---
