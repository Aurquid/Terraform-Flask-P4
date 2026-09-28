# Overview
This project deploys a production-style Python Flask app on a hardened AWS Linux EC2 instance via Terraform. The instance is hardened with OS patching, secure package installation, and SSM role access without SSH. User-data bootstraps the Flask app, configures a systemd service, sets up Nginx reverse proxy for stable routing. A CloudWatch agent is used to collect logs and metrics for monitoring
# Table of Contents
- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [Services Used](#services-used)
- [Deployment Flow](#deployment-flow)
- [User-Data Automation](#user-data-automation)
- [Nginx Reverse Proxy](#nginx-reverse-proxy)
- [systemd Service](#systemd-service)
- [CloudWatch Agent](#cloudwatch-agent)
- [IAM Role & Security](#iam-role--security)
- [Cost Breakdown](#cost-breakdown)
- [Failure Scenarios](#failure-scenarios)
- [Lessons Learned](#lessons-learned)
- [Screenshots](#screenshots)
# Architecture Diagram
# Services Used
# Deployment Flow
# User-Data Automation
# Nginx Reverse Proxy
# systemd Service
# CloudWatch Agent
# IAM Role & Security
# Cost Breakdown
# Failure Scenarios
# Lessons Learned
# Screenshots
