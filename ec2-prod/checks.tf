check "sg_ssh_not_public" {
  # Query the LIVE security group from AWS using the correct data source
  data "aws_security_group" "live_myec2_sg" {
    filter {
      name   = "group-id"
      values = [aws_security_group.myec2_sg.id]
    }
  }

  assert {
    condition = length([
      for rule in data.aws_security_group.live_myec2_sg.ingress :
      rule
      if rule.from_port == 22 &&
         rule.to_port   == 22 &&
         rule.protocol  == "tcp" &&
         contains(rule.cidr_blocks, "0.0.0.0/0")
    ]) == 0

    error_message = "Security Group 'myec2-sg' exposes SSH (22) to 0.0.0.0/0."
  }
}



check "s3_bucket_encryption_enabled" {
  assert {
    condition = length([
      for rule in aws_s3_bucket_server_side_encryption_configuration.mydemo_bucket_sse.rule :
      rule.apply_server_side_encryption_by_default[0].sse_algorithm
      if rule.apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    ]) > 0

    error_message = "S3 bucket is not encrypted with AES256."
  }
}
