
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
