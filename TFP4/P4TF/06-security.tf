# Security group for the Flask app
resource "aws_security_group" "p4_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP traffic only"
  vpc_id      = aws_vpc.p4_vpc.id   

  # Allow inbound HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
