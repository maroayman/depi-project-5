# Security Groups for the Application

## Load Balancer Security Group
resource "aws_security_group" "LoadBalancer" {
  vpc_id      = aws_vpc.main.id
  name        = "LoadBalancer Security Group"
  description = "Security group for Load Balancer"

  ### Port 80 Ingress
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ### Port 443 Ingress (HTTPS)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ### Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## EC2 Instances Security Group
resource "aws_security_group" "web_servers" {
  vpc_id      = aws_vpc.main.id
  name        = "Web Servers Security Group"
  description = "Security group for web server instances"

  ### Allow HTTP from ALB only
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.LoadBalancer.id]
  }

  ### Allow SSH from bastion only
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }

  ### Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Bastion Host Security Group
resource "aws_security_group" "Bastion" {
  vpc_id      = aws_vpc.main.id
  name        = "Bastion Security Group"
  description = "Security group for Bastion Host"

  ### Port 22 Ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ### Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
