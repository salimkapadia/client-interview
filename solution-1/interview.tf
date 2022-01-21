terraform {
  # backend "s3" {}
}

provider "aws" {}


resource "aws_s3_bucket" "s3" {
  bucket = "${var.repository_name}-${terraform.workspace}-Bucket"
  tags   = local.tags
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3Access" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_metric" "s3_metrics" {
  bucket = aws_s3_bucket.s3.id
  name   = "EntireBucket"
}

resource "aws_s3_bucket_policy" "ssl_only_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.bucket_ssl_only_policy_document.json
}

data "aws_iam_policy_document" "bucket_ssl_only_policy_document" {
  // Force SSL-only access
  statement {
    sid    = "ForceSSLOnlyAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}
