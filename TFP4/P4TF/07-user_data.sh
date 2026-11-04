#!/bin/bash -e
# Stop on any error (-e) and log progress for visibility.
# Terraform templatefile() fills the placeholders below with the files in TFP4/App.

echo "Updating system packages..."
dnf update -y

echo "Installing Python, Nginx and CloudWatch agent..."
dnf install -y python3-pip nginx amazon-cloudwatch-agent

echo "Creating app user and directories..."
id myapp &>/dev/null || useradd --system --no-create-home --shell /sbin/nologin myapp
mkdir -p /opt/myapp /var/log/myapp

echo "Writing Flask app..."
cat << 'EOF' > /opt/myapp/main.py
${app_py}
EOF

echo "Writing requirements.txt..."
cat << 'EOF' > /opt/myapp/requirements.txt
${requirements_txt}
EOF

echo "Installing Python packages..."
pip3 install -r /opt/myapp/requirements.txt

# Let the app user own its files and logs
chown -R myapp:myapp /opt/myapp /var/log/myapp

echo "Creating systemd service..."
cat << 'EOF' > /etc/systemd/system/myapp.service
${service_unit}
EOF

echo "Starting Flask app service..."
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp

echo "Configuring Nginx reverse proxy..."
cat << 'EOF' > /etc/nginx/conf.d/myapp.conf
${nginx_conf}
EOF

# Remove default_server from the stock server block so our site answers on port 80
sed -i -E 's/listen(\s+)(\[::\]:)?80(\s+)default_server;/listen\1\280;/' /etc/nginx/nginx.conf

echo "Checking Nginx config and restarting..."
nginx -t
systemctl enable nginx
systemctl restart nginx

echo "Configuring CloudWatch agent..."
cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
${cloudwatch_json}
EOF

# Load the config into the agent and start it
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "Setup complete. Flask app on port 8000, proxied through Nginx on port 80."
