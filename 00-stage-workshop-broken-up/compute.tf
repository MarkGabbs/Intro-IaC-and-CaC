data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

resource "aws_instance" "lab" {
  count                  = 3
  ami                    = data.aws_ami.linux.id
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.WEI-Workshop.id
  vpc_security_group_ids = [aws_security_group.WEI-Workshop.id]
  key_name               = var.key_name
}
