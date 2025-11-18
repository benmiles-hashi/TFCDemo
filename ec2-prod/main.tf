data "aws_vpc" "default" {
  default = true
}
resource "aws_security_group" "myec2_sg" {
  name        = "myec2-sg"
  description = "Security group for MyEC2 demo instance"
  vpc_id      = aws_vpc.default.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "MyEC2-SG"
    Owner = "Ben Miles"
  }
}

resource "aws_instance" "myec2" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.myec2_sg.id]

  tags = {
    Name  = "MyEC2-VCS"
    Env   = "Prod"
    owner = "Ben Miles"
  }
}

resource "aws_s3_bucket" "mydemo_bucket" {
  bucket = "${var.prefix}-demo-bucket"

  tags = {
    Name  = "MyDemoBucket"
    Owner = "Ben Miles"
  }
}

resource "aws_s3_bucket_versioning" "mydemo_bucket_versioning" {
  bucket = aws_s3_bucket.mydemo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mydemo_bucket_sse" {
  bucket = aws_s3_bucket.mydemo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
