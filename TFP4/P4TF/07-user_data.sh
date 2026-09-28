#!/bin/bash -e
# Stop on any error (-e) and log progress for visibility

echo "Updating system packages..."
dnf update -y

echo "Installing Python and dependencies..."
dnf install -y python3-pip nginx amazon-cloudwatch-agent
pip3 install flask

echo "Creating app directory..."
mkdir -p /opt/myapp
cd /opt/myapp

echo "Writing Flask app..."
cat << 'EOF' > /opt/myapp/main.py
from flask import Flask, jsonify
import logging

# Initialize Flask app
app = Flask(__name__)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

@app.route("/")
def index():
    app.logger.info("Root endpoint accessed")
    return "Hello from your EC2 instance!"

@app.route("/health")
def health():
    app.logger.info("Health check endpoint accessed")
    return jsonify(status="ok")

@app.route("/info")
def info():
    app.logger.info("Info endpoint accessed")
    return jsonify(
        app="Python EC2 Flask App",
        version="1.0",
        environment="production"
    )

if __name__ == "__main__":
    # Run the app on all interfaces, port 8000
    app.run(host="0.0.0.0", port=8000)
EOF

echo "Writing requirements.txt..."
cat << 'EOF' > /opt/myapp/requirements.txt
flask
EOF

echo "Installing Python packages..."
pip3 install -r /opt/myapp/requirements.txt

echo "Creating systemd service..."
cat << 'EOF' > /etc/systemd/system/myapp.service
[Unit]
Description=Flask App
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/myapp/main.py
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF

echo "Starting Flask app service..."
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp

echo "Configuring Nginx reverse proxy..."
cat << 'EOF' > /etc/nginx/conf.d/myapp.conf
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF

echo "Restarting Nginx..."
systemctl enable nginx
systemctl restart nginx

echo "Configuring CloudWatch agent..."
cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          { "file_path": "/var/log/nginx/access.log", "log_group_name": "nginx-access" },
          { "file_path": "/var/log/nginx/error.log", "log_group_name": "nginx-error" },
          { "file_path": "/var/log/messages", "log_group_name": "system-messages" }
        ]
      }
    }
  }
}
EOF

echo "Starting CloudWatch agent..."
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

echo "Setup complete. Flask app running on port 8000 and proxied through Nginx port 80."
