# Create Auto Scaling Group

## Create Launch Template for EC2 Instances

resource "aws_launch_template" "web_application" {
  name          = "web-application-launch-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.asg_key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  vpc_security_group_ids = [aws_security_group.web_servers.id]
  user_data              = filebase64("${path.module}/scripts/user_data.sh")
}

## Create Auto Scaling Group for EC2 Instances

resource "aws_autoscaling_group" "app-group" {
  name = "AutoScalingGroup"
  launch_template {
    id      = aws_launch_template.web_application.id
    version = "$Latest"
  }
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  target_group_arns   = [aws_lb_target_group.LoadBalancer_tg.arn]
  tag {
    key                 = "Name"
    value               = "AutoScalingInstance-$(aws:InstanceId)"
    propagate_at_launch = true
  }
}