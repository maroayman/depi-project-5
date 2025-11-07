# Create EC2 Instance as Bastion Jumper Host

## Keypair Definition Block

resource "aws_key_pair" "bastion" {
  key_name   = var.bastion_key_name
  public_key = file("./bastion-key.pub")
}

## Definition of the Bastion Jumper EC2 Instance
resource "aws_instance" "bastion-jumper" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.Bastion.id]
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name
  tags = {
    Name = "Bastion Jumper"
  }
}
