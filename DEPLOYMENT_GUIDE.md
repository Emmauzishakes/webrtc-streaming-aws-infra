# Deployment Guide

## Verify Terraform Deployment

```bash
terraform state list
```

Verify:

- VPC
- Subnet
- Route Table
- Internet Gateway
- Security Group
- EC2 Instance

---

## Verify EC2

```bash
aws ec2 describe-instances
```

or AWS Console.

---

## Verify SSH

```bash
ssh -i webrtc-stream-key ubuntu@PUBLIC_IP
```

---

## Verify Go

```bash
go version
```

Expected:

```text
go version go1.26.5 linux/amd64
```

---

## Clone Repository

```bash
git clone https://github.com/Emmauzishakes/Event-stream-engine.git
```

---

## Download Dependencies

```bash
go mod download
```

---

## Build

```bash
go build -buildvcs=false -o stream-server .
```

---

## Verify Binary

```bash
ls -la stream-server
```

---

## Run Server

```bash
./stream-server
```

Expected:

```text
Live Go Streaming Engine running on :8080
```

---

## Verify Port

```bash
sudo ss -tulpn | grep 8080
```

Expected:

```text
LISTEN 0 4096 *:8080
```

---

## Verify Security Group

Check:

```text
22 TCP
8080 TCP
10000-50000 UDP
```

---

## Browser Test

Open:

```text
http://EC2_PUBLIC_IP:8080
```

Expected:

```text
404 page not found
```

This confirms the service is reachable.

---

## Frontend Configuration

Development:

```env
NEXT_PUBLIC_WEBSOCKET_URL=ws://EC2_IP:8080/ws
```

Production (future):

```env
NEXT_PUBLIC_WEBSOCKET_URL=wss://stream.yourdomain.com/ws
```

---

## Troubleshooting

### Connection Refused

Verify:

```bash
sudo ss -tulpn | grep 8080
```

---

### SSH Fails

Verify:

- Security Group Port 22
- Correct Key Pair
- Correct Public IP

---

### WebRTC Fails

Verify:

```text
UDP 10000-50000
```

is open.

---

## Cleanup

Destroy infrastructure when not actively testing.

```bash
terraform destroy
```

This project is intentionally optimized for learning, demos, MVP testing, and startup pitches while minimizing AWS costs.