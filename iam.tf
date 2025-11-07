# Create IAM Role and Policy configuration and Attaching

## Create IAM Role and Policy

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }] })
}

## Read Policy from external JSON file and create IAM Policy

resource "aws_iam_policy" "s3_policy" {
  name   = "s3_policy"
  policy = file("${path.module}/policies/s3_policy.json")
}

## Attach Policy to IAM Role

resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

## Attach IAM Role to EC2 Instances

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}