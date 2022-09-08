data "aws_iam_policy_document" "lambda-assume-role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda-policy" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["dynamodb:Scan", "dynamodb:GetItem"]
    resources = [aws_dynamodb_table.todo.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PuLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-api-tf-stack-${var.stage}"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role.json

  inline_policy {
    name   = "lambda-api-tf-stack-${var.stage}"
    policy = data.aws_iam_policy_document.lambda-policy.json
  }
}
