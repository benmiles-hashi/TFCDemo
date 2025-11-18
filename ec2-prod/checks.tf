check "sg_ssh_not_public" {
  data "aws_vpc_security_group_ingress_rule" "ssh_live" {
    id = aws_vpc_security_group_ingress_rule.ssh_ingress.security_group_rule_id
  }

  assert {
    condition = data.aws_vpc_security_group_ingress_rule.ssh_live.cidr_ipv4 != "0.0.0.0/0"

    error_message = "SSH is exposed to 0.0.0.0/0 on Security Group 'myec2-sg'."
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
