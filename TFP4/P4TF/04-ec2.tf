# Latest Amazon Linux 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# EC2 instance for the Flask app
resource "aws_instance" "p4_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.p4_subnet.id

  # Security group
  vpc_security_group_ids = [aws_security_group.p4_sg.id]

  # IAM role (SSM + CloudWatch)
  iam_instance_profile = aws_iam_instance_profile.p4_instance_profile.name

  # Install and configure app + Nginx + CloudWatch
  user_data = templatefile("${path.module}/07-user_data.sh", {
    app_py           = file("${path.module}/../App/01-main.py")
    requirements_txt = file("${path.module}/../App/02-requirements.txt")
    service_unit     = file("${path.module}/../App/03-myapp.service")
    nginx_conf       = file("${path.module}/../App/04-nginx.conf")
    cloudwatch_json  = file("${path.module}/../App/cloudwatch-config.json")
  })

  # Rebuild the instance when the script or app files change
  user_data_replace_on_change = true

  # IAM + SG 
  depends_on = [
    aws_iam_instance_profile.p4_instance_profile,
    aws_security_group.p4_sg
  ]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
