resource "aws_instance" "myec2" {
  ami                     = var.ami
  instance_type           = "m5.large"

  tags = {
    Name = "MyEC2-VCS"
  }

}
