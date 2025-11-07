# Load Balancer Configuration for AWS

## Create Load Balancer (ALB)
resource "aws_lb" "Application_LB" {
  name                       = "Application-LoadBalancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.LoadBalancer.id]
  subnets                    = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  enable_deletion_protection = false
  tags = {
    Name = "application-load-balancer"
  }
}

## Create Target Group
resource "aws_lb_target_group" "LoadBalancer_tg" {
  name     = "Application-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    protocol = "HTTP"
    path     = "/"
  }
  tags = {
    Name = "TargetGroup-Application"
  }
}

## Create Listener for ALB
resource "aws_lb_listener" "ALB_Listener" {
  load_balancer_arn = aws_lb.Application_LB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LoadBalancer_tg.arn
  }
}