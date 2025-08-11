resource "aws_instance" "myec2" {
  ami                     = var.ami
  instance_type           = "t5.xlarge"

  tags = {
    Name = "MyEC2-VCS"
    Env = "Prod"
  }

}
