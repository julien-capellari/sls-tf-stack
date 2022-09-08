data "aws_iam_policy_document" "todos-react-s3-access" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.todos-react.arn}/*"]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.todos.arn]
    }
  }
}

resource "aws_s3_bucket" "todos-react" {
  bucket = "todos-react-tf-stack-${var.stage}"
}

resource "aws_s3_bucket_acl" "todos-react" {
  bucket = aws_s3_bucket.todos-react.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "todos-react" {
  bucket = aws_s3_bucket.todos-react.id
  policy = data.aws_iam_policy_document.todos-react-s3-access.json
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.todos-react.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "todos-react" {
  bucket = aws_s3_bucket.todos-react.id

  versioning_configuration {
    status = "Enabled"
  }
}
