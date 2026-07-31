# Event Stream Infrastructure

Terraform Infrastructure for deploying a Go-based WebRTC Event Streaming Engine on AWS.

---

## Features

- Terraform Managed Infrastructure
- Dedicated IAM Deployment User
- Custom VPC
- Public Subnet
- Internet Gateway
- Route Tables
- Security Groups
- EC2 Deployment
- SSH Access
- WebRTC UDP Ports
- WebSocket Signaling
- Future Nginx + TLS Support

---

## Infrastructure

| Resource | Purpose |
|-----------|----------|
| IAM User | Terraform Deployment |
| VPC | Network Isolation |
| Public Subnet | EC2 Placement |
| Security Group | Traffic Control |
| EC2 t3.micro | WebRTC Engine |
| SSH Key Pair | Secure Access |

---

## AWS Region

```text
af-south-1
```

Cape Town Region

---

## Estimated Cost

When EC2 is running:

```text
~$0.01 - $0.02/hour
```

Always destroy unused infrastructure.

---

## Deployment Flow

### Step 1

Bootstrap IAM

```bash
cd bootstrap/iam

terraform init
terraform apply
```

---

### Step 2

Configure Credentials

```bash
aws configure
```

Use generated IAM Access Keys.

---

### Step 3

Deploy Infrastructure

```bash
cd production

terraform init
terraform plan
terraform apply
```

---

### Step 4

Get Public IP

```bash
terraform output
```

Example:

```text
15.xx.xx.xx
```

---

### Step 5

SSH

```bash
ssh -i webrtc-stream-key ubuntu@PUBLIC_IP
```

---

### Step 6

Install Go

Follow the latest Go installation guide.

---

### Step 7

Clone Engine

```bash
git clone https://github.com/Emmauzishakes/Event-stream-engine.git
```

---

### Step 8

Build

```bash
go mod download

go build -buildvcs=false -o stream-server .
```

---

### Step 9

Run

```bash
./stream-server
```

---

## Cleanup

Destroy all resources when not needed.

```bash
terraform destroy
```

This helps avoid unnecessary AWS charges.

---

## Security Notes

Current deployment:

- SSH restricted to developer IP
- UDP restricted for WebRTC
- Dedicated IAM User
- Separate IAM Bootstrap State

Future improvements:

- HTTPS
- WSS
- Nginx
- SSM Session Manager
- CloudWatch