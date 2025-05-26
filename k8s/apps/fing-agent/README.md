# Fing Agent on Kubernetes (Orange Pi)

This directory deploys [Fing Agent](https://www.fing.com/products/fing-agent) on a K3s cluster (e.g. an Orange Pi). Fing Agent provides continuous network monitoring, device discovery, and remote alerts via the Fing mobile app.

---

## ✅ Features

- Network presence monitoring (24/7).
- Detects and alerts when new devices connect to your home LAN.
- Integrates with Fing mobile app for remote monitoring.
- Lightweight container with persistent volume for historical data.
- Uses `hostNetwork` for low-level access to the LAN.

---

## 📦 Manifests

- `app.yaml`: Deploys the Fing Agent container.
- `pv.yaml`: Creates a local-path `PersistentVolume` on the Orange Pi.
- `pvc.yaml`: Claims the volume for the Fing Agent.

---

## 📂 Requirements

- A K3s or Kubernetes cluster.
- A mobile Fing account.
- The `local-path` storage class enabled (default in K3s).
- Fing Agent will only function if run on a **host with full LAN access** (hence the use of `hostNetwork: true`).

---

## 🚀 Deployment Steps

### 1. Create the PersistentVolume

```bash
kubectl apply -f pv.yaml
```

### 2. Create the PersistentVolumeClaim

```bash
kubectl apply -f pvc.yaml
```

### 3. Deploy the Fing Agent

```bash
kubectl apply -f app.yaml
```

---

## 📱 Activate Fing Agent

After deploying:

1. Open the **Fing mobile app**.
2. Go to **Account > Network Monitoring Units**.
3. Choose **Add monitoring unit**.
4. The app should detect the agent automatically if your Fing account is connected to the same LAN.

---

## 🔐 Notes

- `hostNetwork: true` allows Fing Agent to interact with your LAN, which is essential for device discovery.
- The container stores data in `/app/fingdata`, which is mounted from a persistent volume for data durability.
- Be sure only one instance of Fing Agent runs per network to avoid conflicts.

---

## 📎 References

- [Fing Agent Docker Guide](https://help.fing.com/hc/en-us/articles/16874649602588-How-to-install-the-Fing-Agent-on-Linux-Docker)
- [Docker Hub: fing/fing-agent](https://hub.docker.com/r/fing/fing-agent)
