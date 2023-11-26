resource "aws_instance" "myec2" {
<<<<<<< HEAD
  ami                     = var.ami
  instance_type           = "t2.micro"
=======
  ami                     = "ami-0230bd60aa48260c6"
  instance_type           = "t3.micro"
>>>>>>> c984a2e3bed7a0075822a48087acbe3ba174cc6b

  tags = {
    Name = "MyEC2-2"
  }

}
