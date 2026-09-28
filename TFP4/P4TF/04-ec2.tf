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
  user_data = file("${path.module}/09-user_data.sh")

  # IAM + SG 
  depends_on = [
    aws_iam_instance_profile.p4_instance_profile,
    aws_security_group.p4_sg
  ]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
