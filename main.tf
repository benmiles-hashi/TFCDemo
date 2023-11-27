resource "aws_instance" "myec2" {
  ami                     = var.ami
  instance_type           = "t3.micro"

  tags = {
    Name = "MyEC2b"
  }

}
