resource "aws_instance" "myec2" {
  ami                     = "ami-0230bd60aa48260c6"
  instance_type           = "t2.micro"

  tags = {
    Name = "MyEC2"
  }
}