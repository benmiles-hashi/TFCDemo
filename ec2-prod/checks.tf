check "s3_bucket_encryption_enabled" {
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.mydemo_bucket_sse.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "S3 bucket is not encrypted with AES256 as expected."
  }
}
check "sg_ssh_not_public" {

  # Re-read the SG as it currently exists (real world)
  data "aws_security_group" "live_sg" {
    id = aws_security_group.myec2_sg.id
  }

  # Evaluate the actual live inbound rules
  assert {
    condition = length([
      for rule in data.aws_security_group.live_sg.ingress :
      rule
      if rule.from_port == 22 &&
         rule.to_port == 22 &&
         contains(rule.cidr_blocks, "0.0.0.0/0")
    ]) == 0

    error_message = "Security Group myec2-sg exposes SSH (22) to 0.0.0.0/0."
  }
}
