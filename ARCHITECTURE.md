# Event Stream Infrastructure Architecture

## Overview

This repository provisions AWS infrastructure for the Event Stream Engine.

The Event Stream Engine is a Go-based WebRTC signaling and media routing service running on an EC2 instance.

Infrastructure is managed entirely through Terraform.

---

## Architecture Diagram

```text
                    ┌─────────────────┐
                    │     Vercel      │
                    │ Frontend (Next) │
                    └────────┬────────┘
                             │
                             │ WSS (Future)
                             │
                    ┌────────▼────────┐
                    │      Nginx      │
                    │ Reverse Proxy   │
                    │ TLS Termination │
                    └────────┬────────┘
                             │
                             │ localhost:8080
                             │
                    ┌────────▼────────┐
                    │ Go WebRTC Engine│
                    │ Event Stream    │
                    └────────┬────────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  ▼                     ▼
         STUN/TURN Servers        Viewers/Broadcasters

```

---

## AWS Components

### VPC

Custom VPC

```text
10.0.0.0/16
```

Provides isolation for the streaming infrastructure.

---

### Public Subnet

```text
10.0.1.0/24
```

Hosts:

- EC2 WebRTC Instance

---

### Internet Gateway

Provides internet connectivity.

---

### Route Table

Routes outbound traffic:

```text
0.0.0.0/0 → Internet Gateway
```

---

### Security Group

Allowed:

| Port | Protocol | Purpose |
|--------|----------|----------|
| 22 | TCP | SSH |
| 8080 | TCP | WebSocket Signaling |
| 10000-50000 | UDP | WebRTC RTP/RTCP |
| 443 | TCP | HTTPS (Future Nginx) |

---

### EC2

Instance Type:

```text
t3.micro
```

Region:

```text
af-south-1
```

Purpose:

- Run Event Stream Engine
- Handle signaling
- Relay media packets

---

### IAM Bootstrap

Separate Terraform state.

Creates:

- Deployment IAM User
- IAM Group
- IAM Policies
- Access Keys

Used by Terraform production deployments.

---

## Repository Layout

```text
event-stream-infra/

├── bootstrap/
│   └── iam/
│
├── production/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── user_data.sh
│
├── ARCHITECTURE.md
├── README.md
└── DEPLOYMENT_GUIDE.md
```

---

## Future Enhancements

- Route53
- Custom Domain
- Nginx Reverse Proxy
- Let's Encrypt TLS
- WSS Support
- CloudWatch Logs
- CloudWatch Metrics
- SSM Session Manager
- Auto Scaling
- CI/CD Pipeline