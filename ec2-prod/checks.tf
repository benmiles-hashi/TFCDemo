check "sg_ssh_not_public" {
  # Re-read the live SG from AWS
  data "aws_security_group" "live_myec2_sg" {
    id = aws_security_group.myec2_sg.id
  }

  assert {
    condition = length([
      for rule in data.aws_security_group.live_myec2_sg.ingress :
      rule
      if rule.from_port == 22 &&
         rule.to_port == 22 &&
         rule.protocol == "tcp" &&
         contains(rule.cidr_blocks, "0.0.0.0/0")
    ]) == 0

    error_message = "Security Group myec2-sg exposes SSH (22) to 0.0.0.0/0."
  }
}

check "s3_bucket_encryption_enabled" {

  # Re-read the live bucket encryption config
  data "aws_s3_bucket" "live_mydemo_bucket" {
    bucket = aws_s3_bucket.mydemo_bucket.id
  }

  # Since AWS provider doesn't expose encryption via data.*,
  # re-read via the real resource configuration you manage.
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.mydemo_bucket_sse.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "S3 bucket ${aws_s3_bucket.mydemo_bucket.bucket} is not encrypted with AES256."
  }
}
