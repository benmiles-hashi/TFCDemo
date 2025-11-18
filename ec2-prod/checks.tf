check "sg_ssh_not_public" {
  # Query ALL ingress rules for your SG from AWS
  data "aws_security_group_rules" "myec2_ingress" {
    filter {
      name   = "group-id"
      values = [aws_security_group.myec2_sg.id]
    }

    filter {
      name   = "type"
      values = ["ingress"]
    }
  }

  assert {
    condition = length([
      for r in data.aws_security_group_rules.myec2_ingress.rules :
      r
      if r.from_port == 22 &&
         r.to_port   == 22 &&
         r.protocol  == "tcp" &&
         contains(r.cidr_blocks, "0.0.0.0/0")
    ]) == 0

    error_message = "Security Group 'myec2-sg' exposes SSH port 22 to 0.0.0.0/0."
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
