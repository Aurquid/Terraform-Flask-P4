# Overview
This project deploys a Python Flask app on an Amazon Linux 2023 EC2 instance via Terraform. At boot, a user-data script patches the OS, installs the app, runs it as a systemd service, and has Nginx in front as a reverse proxy on port 80. The system is accessed through SSM using an IAM role, with no SSH port open. A CloudWatch agent sends Nginx logs to CloudWatch for monitoring.
# Table of Contents
- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [Services Used](#services-used)
- [How It Works](#how-it-works)
- [Security](#security)
- [Cost Breakdown](#cost-breakdown)
- [Failure Scenarios](#failure-scenarios)
- [Lessons Learned](#lessons-learned)
- [Screenshots](#screenshots)
# Architecture Diagram
<img width="1151" height="706" alt="P4Flask (1)" src="https://github.com/user-attachments/assets/0dd6f9ca-97d4-4b7b-b2c7-f65609b1b74b" />


# Services Used
- VPC
- EC2
- Security Groups
- IAM
- SSM
- CloudWatch
- Terraform
- Nginx
- systemd
# How It Works
1. Terraform creates a VPC, public subnet, Internet Gateway, route table, security group, IAM role, and an EC2 instance.
2. On first boot, the user-data script runs `dnf update` to patch the OS, then installs Python, Nginx, and the CloudWatch agent.
3. It creates a non-root `myapp` user, writes the Flask app, and runs it as a systemd service on port 8000.
4. Nginx listens on port 80 and forwards requests to the app.
5. The CloudWatch agent sends the app and Nginx logs to CloudWatch.

# Security
- Security group allows only HTTP on port 80; no SSH port is open.
- Access is through SSM Session Manager using an IAM role, with no SSH keys.
- The app runs as a non-root user.
- The OS is patched at boot before anything else is installed.
- Not production-hardened: no HTTPS yet, and patching only runs at launch.

# Cost Breakdown
| Component | Approx. Cost | Notes |
|---|---|---|
| EC2 t3.micro | ~$7–8/mo | Charged while running |
| Public IPv4 address | ~$3.60/mo | AWS charges for public IPs |
| EBS volume | <$1/mo | Small default disk |
| CloudWatch Logs | <$1/mo | Low log volume |
| VPC, IAM, SSM | $0 | No direct cost |

Destroyed with `terraform destroy` after testing to avoid charges.

# Failure Scenarios
**App is down:** check `systemctl status myapp` and `journalctl -u myapp`, then restart the service.

**Nginx won't start:** run `nginx -t` to find the config error, fix it, then restart.

**Instance not in Fleet Manager:** confirm the IAM role is attached and the SSM agent is running.

**No logs in CloudWatch:** check the agent status and that the role allows CloudWatch writes.

# Lessons Learned
### Terraform
- Terraform has to run from the folder that holds the `.tf` files. Running it one level up gave a "No configuration files" error.
- `templatefile()` lets me keep the app, service, and Nginx files separate and inject them into user data, which is easier to maintain than one long script.
- `user_data_replace_on_change = true` rebuilds the instance when the boot script changes, so the server always matches the code.

### Linux and Patching
- Patching first, then installing packages, means the app starts on an up-to-date OS. `dnf history` confirmed the update ran before the installs.
- systemd keeps the app running across reboots and restarts it if it crashes, which matters after patching.
- Running `nginx -t` before restarting Nginx catches config errors before they take the site down.

### Validation
- Checking from several angles (systemctl, curl to the app, curl through Nginx, the public URL, and CloudWatch logs) gave me confidence everything worked end to end.
- During validation, a request to `localhost` returned Nginx's default 404 page. `localhost` resolved to IPv6, and my Nginx config only listened on IPv4, so the request hit the default server block. The fix is to add `listen [::]:80 default_server;` or remove the default block.

### Security
- The security group only allows port 80, so SSH and the app's port 8000 can't be reached from the internet, even though `ss -tlnp` shows them listening locally.
- Next improvements: bind Flask to `127.0.0.1` only, disable sshd since I use SSM, add HTTPS, and schedule ongoing patching with SSM Patch Manager.

# Screenshots

### Terraform Output
`terraform output` shows the instance ID, public IP, and the SSM command to connect.

<img width="560" height="72" alt="Screenshot 2026-11-05 160656" src="https://github.com/user-attachments/assets/93fc1192-ef8d-4b79-b14f-78db68dfeb0b" />

### Website
The Flask app served through Nginx at the instance's public IP.

<img width="396" height="151" alt="Screenshot 2026-11-05 160234" src="https://github.com/user-attachments/assets/6947bf51-4056-4457-a511-77b83bbec882" />

### Health Check
The `/health` endpoint returns `{"status":"ok"}`, confirming the app is up.

<img width="441" height="212" alt="Screenshot 2026-11-05 160427" src="https://github.com/user-attachments/assets/16960235-43a5-4af5-94c5-99984e94188f" />

### EC2 Instance
Amazon Linux 2023 on a t3.micro, running with the `p4-flask-app-ec2-role` IAM role attached.

<img width="1098" height="496" alt="Screenshot 2026-11-05 152442" src="https://github.com/user-attachments/assets/f8d78525-64eb-4556-8601-9267a74e76c1" />

### Security Group
Only one inbound rule: HTTP on port 80. No SSH port is open.

<img width="1118" height="564" alt="Screenshot 2026-11-05 152620" src="https://github.com/user-attachments/assets/d3464412-7832-4afe-8859-529032674eda" />

### VPC
The VPC (10.0.0.0/16) with its public subnet, route table, and Internet Gateway.

<img width="1084" height="503" alt="Screenshot 2026-11-05 152809" src="https://github.com/user-attachments/assets/bf7e975d-a9c6-42b7-9c0a-bbde520795a5" />

### Route Table
`0.0.0.0/0` routes to the Internet Gateway, giving the public subnet internet access.

<img width="1103" height="506" alt="Screenshot 2026-11-05 153129" src="https://github.com/user-attachments/assets/e84f9241-a6dc-4888-b273-97cbee8181c9" />

### Fleet Manager
The instance is managed by SSM and shows as Online, so it can be accessed without SSH.

<img width="1115" height="529" alt="Screenshot 2026-11-05 154013" src="https://github.com/user-attachments/assets/df46e56d-db68-4aab-a231-c647b1a9ba93" />

### systemd Services
Both `myapp` and `nginx` are active (running) and enabled to start on boot.

<img width="770" height="334" alt="Screenshot 2026-11-05 154250" src="https://github.com/user-attachments/assets/f10e8a19-7cc9-40d9-a7a5-be796e1ab09d" />

### Health Checks from the Server
`curl` to the app on port 8000 and through Nginx on port 80 both return `ok`.

<img width="471" height="161" alt="Screenshot 2026-11-05 154627" src="https://github.com/user-attachments/assets/238d3b6d-805d-462b-ba09-47a440d9381b" />

### Patching Proof
`dnf history` shows the OS update ran first, then the app packages were installed.

<img width="897" height="329" alt="Screenshot 2026-11-05 155022" src="https://github.com/user-attachments/assets/4db92498-0736-4c5c-b6f0-9d5dc6869341" />

### Listening Ports
Nginx on 80 and the app on 8000. SSH is listening locally but blocked by the security group.

<img width="1091" height="322" alt="Screenshot 2026-11-05 155414" src="https://github.com/user-attachments/assets/bcd137ab-cc47-4a36-8ca0-2745d5d2574e" />

### CloudWatch Log Groups
App, Nginx access, and Nginx error logs are all shipped to CloudWatch.

<img width="1104" height="461" alt="Screenshot 2026-11-05 155722" src="https://github.com/user-attachments/assets/27f05c1f-bdff-4ce5-8ea8-90aa1fb99bad" />

### CloudWatch Log Stream
Live Nginx access logs, including the health checks from validation.

<img width="1092" height="461" alt="Screenshot 2026-11-05 160033" src="https://github.com/user-attachments/assets/63c5c420-3a06-4aba-b4d1-8f5de31c0d6d" />
