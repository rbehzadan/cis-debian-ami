# CIS-Hardened Debian 12 AMI

This project uses [Packer](https://www.packer.io/) and [Ansible](https://www.ansible.com/) to build a **CIS-hardened Debian 12 AMI** based on the [ansible-lockdown/DEBIAN12-CIS](https://github.com/ansible-lockdown/DEBIAN12-CIS) role.

> ✅ **Public AMI** available in `us-east-1`:  
> `ami-0ded45c1c47569084`

---

## 🔧 Features

- Debian 12 base image
- CIS Level 1 hardening (with a few rules intentionally disabled for cloud compatibility)
- SSH hardened via `AllowUsers` / `AllowGroups`
- `ufw` configured with limited outbound ports
- Fully automated build using Packer and Ansible

---

## 📁 Project Structure

```

cis-debian-ami/
├── packer.pkr.hcl
├── iam-policy.json
└── ansible/
├── playbook.yml
└── roles/
└── DEBIAN12-CIS/  # Git submodule

````

---

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone --recurse-submodules https://github.com/your-username/cis-debian-ami.git
cd cis-debian-ami
````

### 2. Configure AWS credentials

Ensure you have a user with the necessary EC2 permissions (see [`iam-policy.json`](./iam-policy.json)).

### 3. Build the image

```bash
packer init .
packer build packer.pkr.hcl
```

---

## 🧩 Ansible Variables

In `ansible/playbook.yml`, the following CIS rules are skipped to ensure compatibility with Debian cloud images and key-only SSH:

```yaml
vars:
  deb12cis_rule_5_2_4: false   # Ensure users are not locked (admin is SSH-only)
  deb12cis_rule_5_4_1_1: false # Disable password expiration enforcement
  deb12cis_rule_5_4_2_4: false # Root password check (root is disabled)
```

---

## 🔐 IAM Policy

Use the [`iam-policy.json`](./iam-policy.json) file to create or attach a policy to your IAM user/role. This allows Packer to perform all required EC2 operations.

```bash
aws iam create-policy \
  --policy-name PackerEC2BuildPolicy \
  --policy-document file://iam-policy.json
```

---

## 🖥️ Launch From the Public AMI

```bash
aws ec2 run-instances \
  --image-id ami-0ded45c1c47569084 \
  --instance-type t3.micro \
  --key-name your-keypair-name \
  --region us-east-1
```

Then connect:

```bash
ssh -i your-key.pem admin@<public-ip>
```

---

## ✨ Credits

This project and documentation were created with help from [ChatGPT](https://openai.com/chatgpt).

