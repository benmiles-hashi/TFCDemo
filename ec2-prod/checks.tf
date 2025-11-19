

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
check "s3_public_access_block_enabled" {
  data "aws_s3_bucket_public_access_block" "s3_acls" {
    bucket = aws_s3_bucket.mydemo_bucket.id
  }
  assert {
    condition = (
      data.aws_s3_bucket_public_access_block.s3_acls.block_public_acls &&
      data.aws_s3_bucket_public_access_block.s3_acls.block_public_policy &&
      data.aws_s3_bucket_public_access_block.s3_acls.ignore_public_acls &&
      data.aws_s3_bucket_public_access_block.s3_acls.restrict_public_buckets
    )

    error_message = "S3 bucket public access block is not fully enabled in AWS."
  }
}
check "s3_versioning_enabled" {
  assert {
    condition = aws_s3_bucket_versioning.mydemo_bucket_versioning.versioning_configuration[0].status == "Enabled"
    error_message = "S3 bucket versioning is not set to Enabled in the Terraform configuration."
  }
}

