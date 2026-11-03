# Overview
This project deploys a production-style Python Flask app on a hardened AWS Linux EC2 instance via Terraform. The instance is hardened with OS patching, secure package installation, and SSM role access without SSH. User-data bootstraps the Flask app, configures a systemd service, sets up Nginx reverse proxy for stable routing. A CloudWatch agent is used to collect logs for monitoring
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
<img width="1151" height="706" alt="P4Flask" src="https://github.com/user-attachments/assets/76d42e91-32a5-452d-b46c-af4c502c2ce1" />
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
