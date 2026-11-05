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

<img width="1098" height="496" alt="Screenshot 2026-11-05 152442" src="https://github.com/user-attachments/assets/f8d78525-64eb-4556-8601-9267a74e76c1" />
<img width="1118" height="564" alt="Screenshot 2026-11-05 152620" src="https://github.com/user-attachments/assets/d3464412-7832-4afe-8859-529032674eda" />
<img width="1084" height="503" alt="Screenshot 2026-11-05 152809" src="https://github.com/user-attachments/assets/bf7e975d-a9c6-42b7-9c0a-bbde520795a5" />
<img width="1103" height="506" alt="Screenshot 2026-11-05 153129" src="https://github.com/user-attachments/assets/e84f9241-a6dc-4888-b273-97cbee8181c9" />
<img width="1115" height="529" alt="Screenshot 2026-11-05 154013" src="https://github.com/user-attachments/assets/df46e56d-db68-4aab-a231-c647b1a9ba93" />
<img width="770" height="334" alt="Screenshot 2026-11-05 154250" src="https://github.com/user-attachments/assets/f10e8a19-7cc9-40d9-a7a5-be796e1ab09d" />
<img width="471" height="161" alt="Screenshot 2026-11-05 154627" src="https://github.com/user-attachments/assets/238d3b6d-805d-462b-ba09-47a440d9381b" />
<img width="761" height="395" alt="Screenshot 2026-11-05 154636" src="https://github.com/user-attachments/assets/ec755c19-724f-43e8-b7a3-8c1924bc5478" />
<img width="897" height="329" alt="Screenshot 2026-11-05 155022" src="https://github.com/user-attachments/assets/4db92498-0736-4c5c-b6f0-9d5dc6869341" />
<img width="1091" height="322" alt="Screenshot 2026-11-05 155414" src="https://github.com/user-attachments/assets/bcd137ab-cc47-4a36-8ca0-2745d5d2574e" />
test
<img width="1104" height="461" alt="Screenshot 2026-11-05 155722" src="https://github.com/user-attachments/assets/27f05c1f-bdff-4ce5-8ea8-90aa1fb99bad" />
<img width="1092" height="461" alt="Screenshot 2026-11-05 160033" src="https://github.com/user-attachments/assets/63c5c420-3a06-4aba-b4d1-8f5de31c0d6d" />
<img width="396" height="151" alt="Screenshot 2026-11-05 160234" src="https://github.com/user-attachments/assets/6947bf51-4056-4457-a511-77b83bbec882" />
<img width="441" height="212" alt="Screenshot 2026-11-05 160427" src="https://github.com/user-attachments/assets/16960235-43a5-4af5-94c5-99984e94188f" />
<img width="560" height="72" alt="Screenshot 2026-11-05 160656" src="https://github.com/user-attachments/assets/93fc1192-ef8d-4b79-b14f-78db68dfeb0b" />











