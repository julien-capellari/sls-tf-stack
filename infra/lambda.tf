resource "aws_lambda_function" "lambda-api" {
  function_name = "todos-api-tf-stack-${var.stage}"
  role          = aws_iam_role.lambda-role.arn

  runtime          = "nodejs16.x"
  handler          = "lambda.handler"
  filename         = "../backend/dist/lambda.zip"
  source_code_hash = filebase64sha256("../backend/dist/lambda.zip")

  environment {
    variables = {
      FRONTEND_URL = "https://${aws_cloudfront_distribution.todos.domain_name}"
      TODO_TABLE   = aws_dynamodb_table.todo.name
    }
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "lambda-api" {
  function_name = aws_lambda_function.lambda-api.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.todos-api.execution_arn}/*/*/{proxy+}"
}
