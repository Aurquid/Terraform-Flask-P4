# Overview
This project deploys a Python Flask app on a AWS Linux EC2 instance via Terraform. At boot, a user-data script patches the OS, installs the app, runs it as a systemd service, and has Nginx in front as a reverse proxy on port 80. The system is accessed through SSM using an IAM role, with no SSH access. A CloudWatch agent sends Nginx logs to CloudWatch for monitoring.
# Table of Contents
- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [Services Used](#services-used)
- [How It Works](#how-it-works)
- [Deployment](#deployment)
- [Security](#security)
- [Cost Breakdown](#cost-breakdown)
- [Failure Scenarios](#failure-scenarios)
- [Lessons Learned](#lessons-learned)
- [Screenshots](#screenshots)
# Architecture Diagram
<img width="1151" height="706" alt="P4Flask (1)" src="https://github.com/user-attachments/assets/0dd6f9ca-97d4-4b7b-b2c7-f65609b1b74b" />


# Services Used
* VPC
* EC2
* Security Groups
* IAM
* SSM
* Cloudwatch
# How It Works

# Security

# Cost Breakdown

# Failure Scenarios

# Lessons Learned

# Screenshots
